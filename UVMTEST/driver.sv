class uart_driver extends uvm_driver#(uart_sq_item);
  `uvm_component_utils(uart_driver)
  
  virtual UART_intf intf;
  uart_sq_item tr;
  
  function new(string name ="uart_driver", uvm_component parent);
    super.new(name, parent);
    `uvm_info("driver class", "constructor", UVM_HIGH)
  endfunction
  
   //build phase
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    if(!uvm_config_db#(virtual UART_intf)::get(this, "", "vif", intf))
      `uvm_fatal("no_inif in driver","virtual interface get failed from config db");
  endfunction
  
   //run phase
  
   task run_phase(uvm_phase phase);
    forever begin
      seq_item_port.get_next_item(tr);
    
      intf.HSEL    <= 1;
      intf.HADDR   <= tr.addr;
      intf.HTRANS  <= 2'b10;
      intf.HWRITE  <= tr.write;
      intf.HWDATA  <= tr.data;
      intf.HREADY  <= 1;

      @(posedge intf.HCLK);

      intf.HSEL   <= 0;
      intf.HTRANS <= 0;

      seq_item_port.item_done();
    end
  endtask
endclass
