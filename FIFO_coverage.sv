package FIFO_coverage_pkg;
import FIFO_seq_item_pkg::*;
import uvm_pkg::*;
`include "uvm_macros.svh"
class FIFO_coverage extends uvm_component;
    
  `uvm_component_utils(FIFO_coverage);
    FIFO_seq_item seq_item;
    uvm_analysis_export #(FIFO_seq_item) cov_export;
    uvm_tlm_analysis_fifo #(FIFO_seq_item) cov_fifo;


covergroup g1;

// EXTRA will cover rst also
      RST           : coverpoint  seq_item.rst_n;
      wr_en         : coverpoint  seq_item.wr_en;
      rd_en         : coverpoint  seq_item.rd_en;
      wr_ack        : coverpoint  seq_item.wr_ack;
      overflow      : coverpoint  seq_item.overflow;
      underflow     : coverpoint  seq_item.underflow;
      full          : coverpoint  seq_item.full;
      empty         : coverpoint  seq_item.empty;
      almostfull    : coverpoint  seq_item.almostfull;
      almostempty   : coverpoint  seq_item.almostempty;

        wr_en_rd_en_wr_ack      : cross wr_en , rd_en , wr_ack  iff (seq_item.rst_n)
        {
          ignore_bins ignore_bin1  =  binsof(wr_en)  intersect {0} && binsof(wr_ack)    intersect {1};
      
        }  // only if rst deasseted
        wr_en_rd_en_overflow    : cross wr_en , rd_en , overflow iff (seq_item.rst_n) 
        {
          ignore_bins ignore_bin2  =  binsof(wr_en)  intersect {0} &&  binsof(overflow) intersect {1}; 
        }// only if rst deasseted
        wr_en_rd_en_underflow   : cross wr_en , rd_en , underflow iff (seq_item.rst_n) 
        {
          ignore_bins ignore_bin3  =  binsof(rd_en)  intersect {0} && binsof(underflow) intersect {1};
        } // only if rst deasseted
        wr_en_rd_en_full        : cross wr_en , rd_en , full     iff (seq_item.rst_n) 
        {                                        
          ignore_bins ignore_bin4 =   binsof(rd_en)  intersect {1} && binsof(full)      intersect {1};
        } // only if rst deasseted
        wr_en_rd_en_empty       : cross wr_en , rd_en , empty    iff (seq_item.rst_n) 
        {                               
          ignore_bins ignore_bin5 =  binsof(wr_en)  intersect {1} && binsof(empty)     intersect {1};
        } // only if rst deasseted
        wr_en_rd_en_almostfull  : cross wr_en , rd_en , almostfull   iff (seq_item.rst_n) ; // only if rst deasseted
        wr_en_rd_en_almostempty : cross wr_en , rd_en , almostempty  iff (seq_item.rst_n) ; // only if rst deasseted
        endgroup

function new (string name ="FIFO_coverage", uvm_component parent = null);
    super.new (name,parent);  
    g1=new();  
endfunction

function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    cov_export = new("cov_export",this);
    cov_fifo = new("cov_fifo",this);
endfunction

function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    cov_export.connect(cov_fifo.analysis_export);
endfunction

task  run_phase(uvm_phase phase);
  super.run_phase(phase);

    forever begin
      cov_fifo.get(seq_item);
      g1.sample();
    end  
endtask
endclass 
    
endpackage