package FIFO_config_pkg;
import uvm_pkg::*;
`include "uvm_macros.svh"
class FIFO_config_class extends uvm_object;
  `uvm_object_utils (FIFO_config_class);

  virtual FIFO_Interface FIFO_vif;

function new (string name ="FIFO_config_class");
  super.new (name);
endfunction
endclass
    
endpackage