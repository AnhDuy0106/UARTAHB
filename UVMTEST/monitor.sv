class uart_monitor extends uvm_monitor;
  `uvm_component_utils(uart_monitor)
  virtual UART_intf intf;
  
  uvm_analysis_port #(uart_sq_item) mon_port;
  
  function new(string name ="uart_monitor", uvm_component parent);
    super.new(name, parent);
    `uvm_info("monitor class", "constructor", UVM_HIGH)
  endfunction
  
  //build phase 
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    mon_port = new("mon_port", this);
    if(!uvm_config_db#(virtual UART_intf)::get(this, "", "vif", intf))
      `uvm_fatal("no_inif in driver","virtual interface get failed from config db");
  
  endfunction
  
  //run phase
  task run_phase(uvm_phase phase);
    uart_sq_item tr;
    forever begin
      @(posedge intf.HCLK);
      if (intf.HREADYOUT && !intf.HWRITE) begin
        tr = uart_sq_item::type_id::create("tr");
        tr.addr = intf.HADDR;
        tr.data = intf.HRDATA;
        tr.write = 0;
        mon_port.write(tr);
      end
    end
  endtask
endclass
