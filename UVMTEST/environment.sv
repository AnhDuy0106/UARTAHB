class uart_env extends uvm_env;
  `uvm_component_utils(uart_env)
  
  uart_agent agent;
  uart_scoreboard scb;
  
  function new(string name ="uart_env", uvm_component parent);
    super.new(name, parent);
    `uvm_info("env Class", "constructor", UVM_HIGH)
  endfunction
  //build phase
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    agent = uart_agent::type_id::create("agent", this);
    scb = uart_scoreboard::type_id::create("scb", this);
  endfunction
  //connect phase
  
  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    `uvm_info("env Class", "connect phase", UVM_HIGH)
    agent.monitor.mon_port.connect(scb.mon_export);
  endfunction
  
endclass
