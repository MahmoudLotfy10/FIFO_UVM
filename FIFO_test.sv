package FIFO_test_pkg;
import uvm_pkg::*;
`include "uvm_macros.svh"
import FIFO_env_pkg::*;
import FIFO_config_pkg::*;
import FIFO_sequence_pkg::*;
class FIFO_test_class extends uvm_test;

`uvm_component_utils (FIFO_test_class)

FIFO_env_class env;
FIFO_config_class FIFO_cnfg;

FIFO_sequence_reset reset_seq;
write_only_sequence write_only_seq;
read_only_sequence read_only_seq;
write_read_sequence write_read_seq;

function new (string name ="FIFO_test_class", uvm_component parent = null);
  super.new (name,parent);
    
endfunction

function void build_phase(uvm_phase phase);
  super.build_phase(phase);
    env = FIFO_env_class :: type_id :: create ("env", this);

    FIFO_cnfg = FIFO_config_class :: type_id :: create ("FIFO_cnfg");

    reset_seq = FIFO_sequence_reset :: type_id :: create ("reset_seq");

    write_only_seq = write_only_sequence :: type_id :: create ("write_only_seq");
    read_only_seq  = read_only_sequence  :: type_id :: create ("read_only_seq");
    write_read_seq = write_read_sequence :: type_id :: create ("write_read_seq");

    if(!uvm_config_db#(virtual FIFO_Interface) :: get(this,"","FIFO_if",FIFO_cnfg.FIFO_vif))
    `uvm_fatal ("build_phas","test - unable to get the virtual interface of the FIFO from uvm_config_db ");

    uvm_config_db #(FIFO_config_class) :: set (this,"*","CFG",FIFO_cnfg);
    
endfunction

task run_phase(uvm_phase phase);
    super.run_phase(phase);
    phase.raise_objection(this);
    `uvm_info("run_phase","RST is asserted",UVM_LOW)
    reset_seq.start(env.agt.sqr);
    `uvm_info("run_phase","RST is deasserted",UVM_LOW)

    `uvm_info("run_phase","stimulus generation write_only_seq started",UVM_LOW)
    write_only_seq.start(env.agt.sqr);
    `uvm_info("run_phase","stimulus generation write_only_seq ended",UVM_LOW)


    `uvm_info("run_phase","stimulus generation read_only_seq started",UVM_LOW)
    read_only_seq.start(env.agt.sqr);
    `uvm_info("run_phase","stimulus generation read_only_seq ended",UVM_LOW)

    `uvm_info("run_phase","stimulus generation write_read_seq started",UVM_LOW)
    write_read_seq.start(env.agt.sqr);
    `uvm_info("run_phase","stimulus generation write_read_seq ended",UVM_LOW)


    phase.drop_objection(this);
endtask : run_phase
    
endclass : FIFO_test_class
    
endpackage : FIFO_test_pkg