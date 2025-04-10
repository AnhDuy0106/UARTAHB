class uart_test extends uvm_test;
  `uvm_component_utils(uart_test)
  uart_env env;
  uart_sequence seq;
  
  //standard constructor
  function new(string name = "uart_test", uvm_component parent);
    super.new(name, parent);
    `uvm_info("Test Class", "constructor", UVM_HIGH)
  endfunction
  
  //build phase
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    env = uart_env::type_id::create("env", this);
    seq = uart_sequence::type_id::create("seq", this);
  endfunction
  
  //connect phase
  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    `uvm_info("Test Class", "connect phase", UVM_HIGH)
  endfunction
  
   virtual function void end_of_elaboration();
     `uvm_info("Test Class", "elob phase", UVM_HIGH)
    print();
  endfunction
  
  //run phase
   task run_phase(uvm_phase phase);
    `uvm_info("Test Class", "run phase", UVM_HIGH)
    
    phase.raise_objection(this);
    seq.start(env.agent.sequencer);
    phase.drop_objection(this);
  endtask
endclass
    
