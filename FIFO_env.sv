package FIFO_env_pkg;
import uvm_pkg::*;
`include "uvm_macros.svh" ;
import FIFO_agent_pkg::*;
import FIFO_coverage_pkg::*;
import FIFO_score_pkg::*;
class FIFO_env_class extends uvm_env;

    `uvm_component_utils (FIFO_env_class)

   FIFO_agent agt;
   FIFO_score sb;
   FIFO_coverage cov;
    
function new(string name ="FIFO_env_class", uvm_component parent = null);
       super.new (name,parent);  
endfunction

function void build_phase (uvm_phase phase);

super.build_phase(phase);
agt = FIFO_agent    :: type_id :: create ("agt",this);
sb  = FIFO_score    :: type_id :: create ("sb",this);
cov = FIFO_coverage :: type_id :: create ("cov",this);

endfunction

function void  connect_phase(uvm_phase phase);
   agt.agt_ap.connect(sb.sb_export) ;
   agt.agt_ap.connect(cov.cov_export);
endfunction


endclass
    
endpackage