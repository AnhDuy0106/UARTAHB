class uart_sequence extends uvm_sequence #(uart_sq_item);
  `uvm_object_utils(uart_sequence)
  
  function new(string name = "uart_sequence");
    super.new(name);
    `uvm_info("SEQUENCE", "Constructor called", UVM_HIGH);
  endfunction

  // No phase

  task body();
    uart_sq_item tr;
 	repeat (5) begin
      tr = uart_sq_item::type_id::create("tr");
      assert(tr.randomize() with { write == 1; addr == 32'h00; });
      start_item(tr);
      finish_item(tr);
    end
  endtask
endclass
