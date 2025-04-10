class uart_scoreboard extends uvm_scoreboard;
  `uvm_component_utils(uart_scoreboard)
  // Analysis export to receive transactions
  uvm_analysis_imp#(uart_sq_item, uart_scoreboard) mon_export;

  // Constructor
  function new(string name, uvm_component parent);
    super.new(name, parent);
    mon_export = new("mon_export", this);
    
  endfunction

  function void write(uart_sq_item tr);
    $display("[SCOREBOARD] Addr=%h, Data=%h", tr.addr, tr.data);
  endfunction

endclass
