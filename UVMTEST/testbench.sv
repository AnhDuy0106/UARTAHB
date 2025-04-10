`timescale 1ns/1ns
`include "uvm_macros.svh"
import uvm_pkg::*;

`include "interface.sv"
`include "seq_item.sv"
`include "sequence.sv"
`include "sequencer.sv"
`include "driver.sv"
`include "monitor.sv"
`include "agent.sv"
`include "scoreboard.sv"
`include "environment.sv"
`include "test.sv"
`include "UART_AHB.v"

module UART_AHB_tb;
logic HCLK;
  
  initial HCLK = 0;
  always #5 HCLK = ~HCLK; // 100MHz clock

  // Instantiate DUT
  UART_AHB dut (
    .HCLK(intf.HCLK),
    .HRESETn(intf.HRESETn),
    .HTRANS(intf.HTRANS),
    .HSEL(intf.HSEL),
    .HADDR(intf.HADDR),
    .HWRITE(intf.HWRITE),
    .HREADY(intf.HREADY),
    .HWDATA(intf.HWDATA),
    .HRDATA(intf.HRDATA),
    .HREADYOUT(intf.HREADYOUT),
    .i_start(intf.i_start),
    .i_enable(intf.i_enable),
    .uart_irq()
  );
  
  UART_intf intf(.HCLK(HCLK));
initial begin
  uvm_config_db#(virtual UART_intf)::set(null,"*","vif",intf);
end


  
  initial begin
    $monitor($time, "clk = %d", HCLK);
    $dumpfile("dump.vcd");
    $dumpvars;
    //#100000 
    $finish;
  end
  
  initial begin
    run_test("uart_test");
  end
endmodule
  
