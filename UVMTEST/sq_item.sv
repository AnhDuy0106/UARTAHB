class uart_sq_item extends uvm_sequence_item;
  `uvm_object_utils(uart_sq_item)
  
  rand bit [31:0] addr;
  rand bit        write;
  rand bit [31:0]  data;

  //bit [7:0] read_data;
  
  function new(string name ="uart_sq_item");
    super.new(name);
    `uvm_info("sequence item class", "constructor", UVM_HIGH)
  endfunction
endclass
