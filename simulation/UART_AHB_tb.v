`timescale 1us/1us
`include "Baud_rate.v"
`include "UART_RX.v"
`include "UART_AHB.v"
`include "fifo.v"
module UART_AHB_tb;

  // AHB Signals
  reg         HCLK;
  reg         HRESETn;
  reg  [1:0]  HTRANS;
  reg         HSEL;
  reg  [31:0] HADDR;
  reg         HWRITE;
  reg         HREADY;
  reg  [31:0] HWDATA;
  wire [31:0] HRDATA;
  wire        HREADYOUT;

  // UART Signals
  reg         i_start;
  reg         i_enable;
  wire        uart_irq;

  // Clock Generation
  initial HCLK = 0;
  always #5 HCLK = ~HCLK; // 100MHz clock

  // Instantiate DUT
  UART_AHB uut (
    .HCLK(HCLK),
    .HRESETn(HRESETn),
    .HTRANS(HTRANS),
    .HSEL(HSEL),
    .HADDR(HADDR),
    .HWRITE(HWRITE),
    .HREADY(HREADY),
    .HWDATA(HWDATA),
    .HRDATA(HRDATA),
    .HREADYOUT(HREADYOUT),
    .i_start(i_start),
    .i_enable(i_enable),
    .uart_irq(uart_irq)
  );

  // Test Sequence
  initial begin
    // Initial conditions
    HRESETn   = 1;
    HTRANS    = 2'b00;
    HSEL      = 0;
    HADDR     = 32'h0;
    HWRITE    = 0;
    HREADY    = 1;
    HWDATA    = 32'h0;
    i_start   = 0;
    i_enable  = 0;
    

    #20;
    HRESETn = 0;
    i_enable = 1;
    #20;

    // Write a byte (0xAB) to UART TX FIFO
    @(posedge HCLK);
    HSEL    = 1;
    HWRITE  = 1;
    HTRANS  = 2'b10;
    HADDR   = 32'h00;
    HWDATA  = 32'h000000AB;

    @(posedge HCLK);
    HSEL    = 0;
    HWRITE  = 0;
    HTRANS  = 2'b00;
    HADDR   = 32'h00;

    // Start transmission
    @(posedge HCLK);
    i_start = 1;
    @(posedge HCLK);
    i_start = 0;

    // Wait for UART transmission to complete
    repeat (200) @(posedge HCLK);

    // Optional: Read back from RX (if loopback set externally)
    @(posedge HCLK);
    HSEL    = 1;
    HWRITE  = 0;
    HTRANS  = 2'b10;
    HADDR   = 32'h00;

    @(posedge HCLK);
    HSEL    = 0;
    HTRANS  = 2'b00;

    #100000;
    $finish;
  end
initial begin
  $dumpfile("dump.vcd");
  $dumpvars(0);
end
  

endmodule
