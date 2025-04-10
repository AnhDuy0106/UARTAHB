interface UART_intf(input logic HCLK);
  logic HRESETn;
  logic [31:0] HTRANS;
  logic HSEL;
  logic [31:0] HADDR;
  logic HWRITE;
  logic HREADY;
  logic [31:0] HWDATA;
  logic [31:0] HRDATA;
  logic HREADYOUT;
  logic i_start;
  logic i_enable;
  logic uart_iqr;
endinterface
