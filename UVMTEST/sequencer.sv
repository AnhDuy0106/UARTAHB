class uart_sequencer extends uvm_sequencer#(uart_sq_item);
  `uvm_component_utils(uart_sequencer)
  
  function new(string name ="uart_sequencer", uvm_component parent);
    super.new(name, parent);
    `uvm_info("sequencer Class", "constructor", UVM_HIGH)
  endfunction
endclass
