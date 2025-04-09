module UART_AHB
  (
  input 	   HCLK,
  input		   HRESETn,
  input [31:0] HTRANS,
  input 	   HSEL,
  input [31:0] HADDR,
  input 	   HWRITE,
  input		   HREADY,
  input [31:0] HWDATA,
  
  output [31:0] HRDATA,
  output	    HREADYOUT,
  // Declare TX/RX 
  input   i_start,
  input   i_enable,
  output  uart_irq 
);
  
  //Data I/O between AHB and FIFO
  wire [7:0] uart_wdata;  
  wire [7:0] uart_rdata;
  
  //Signals from TX/RX to FIFOs
  wire uart_wr;
  wire uart_rd;
  
  //wires between FIFO and TX/RX
  wire [7:0] tx_data;
  wire [7:0] rx_data;
  wire [7:0] status;
  
  //FIFO Status
  wire tx_full;
  wire tx_empty;
  wire rx_full;
  wire rx_empty;
  
  //UART status ticks
  wire tx_done;
  wire rx_done;
  wire TX_Active;
  wire o_TX, i_RX;
  
  assign i_RX = TX_Active ? o_TX : 1'b1;
  //baud rate signal
  wire b_tick;
  
  //AHB Regs
  reg [1:0] last_HTRANS;
  reg [31:0] last_HADDR;
  reg last_HWRITE;
  reg last_HSEL;
  
  //Set Registers for AHB Address State
  always@ (posedge HCLK)
  begin
    if(HREADY)
    begin
      last_HTRANS <= HTRANS;
      last_HWRITE <= HWRITE;
      last_HSEL   <= HSEL;
      last_HADDR  <= HADDR;
    end
  end
  
  //If Read and FIFO_RX is empty - wait.
  assign HREADYOUT = ~tx_full;
   
  //UART  write select
  assign uart_wr = last_HTRANS[1] & last_HWRITE & last_HSEL& (last_HADDR[7:0]==8'h00);
  //Only write last 8 bits of Data
  assign uart_wdata = HWDATA[7:0];

  //UART read select
  assign uart_rd = last_HTRANS[1] & ~last_HWRITE & last_HSEL & (last_HADDR[7:0]==8'h00);
  

  assign HRDATA = (last_HADDR[7:0]==8'h00) ? {24'h0000_00,uart_rdata}:{24'h0000_00,status};
  assign status = {6'b000000,tx_full,rx_empty};
  
  assign uart_irq = ~rx_empty; 
  
  Baud_rate baud_rate (
    .i_Clock(HCLK),
    .i_reset(HRESETn),
    .brg_reg(8'h1A),  // Example register value for 115200 baud
    .tick(b_tick)
  );
  
  fifo  #(.DWIDTH(8), .AWIDTH(8)) uFIFO_TX 
  (
    .clk(HCLK),
    .resetn(HRESETn),
    .rd(tx_done),
    .wr(uart_wr),
    .w_data(uart_wdata),
    .empty(tx_empty),
    .full(tx_full),
    .r_data(tx_data)
  );
  
  //Receiver FIFO
  fifo #(.DWIDTH(8), .AWIDTH(8)) uFIFO_RX
  (
    .clk(HCLK),
    .resetn(HRESETn),
    .rd(uart_rd),
    .wr(rx_done),
    .w_data(rx_data),
    .empty(rx_empty),
    .full(rx_full),
    .r_data(uart_rdata)
  );
  
  UART_RX #(.TICK_PER_BIT(16)) UART_RX_Inst
    (.i_Clock(HCLK),
     .i_RX(i_RX),
     .i_reset(HRESETn),
     .sample_tick(b_tick),
     .o_RX_DV(rx_done),
     .o_RX_Data(rx_data)
     );
  
  UART_TX #(.TICK_PER_BIT(16)) UART_TX_Inst
    (.i_Clock(HCLK),
     .i_start(i_start),
     .i_data(tx_data),
     .i_reset(HRESETn),
     .i_enable(i_enable),
     .sample_tick(b_tick),	
     .o_TX_Active(TX_Active),
     .o_TX(o_TX),
     .o_TX_Done(tx_done)
     );
  
endmodule  
