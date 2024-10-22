package FIFO_score_pkg;
   import FIFO_seq_item_pkg::*;
    import uvm_pkg::*;
    `include "uvm_macros.svh"

class FIFO_score extends uvm_scoreboard;
    `uvm_component_utils (FIFO_score)

    FIFO_seq_item seq_item;
    uvm_analysis_export #(FIFO_seq_item) sb_export;
    uvm_tlm_analysis_fifo #(FIFO_seq_item) sb_fifo;

parameter FIFO_WIDTH = 16;
parameter FIFO_DEPTH = 8;

bit [FIFO_WIDTH-1:0] data_out_ref;
bit wr_ack_ref, overflow_ref,underflow_ref; 
bit full_ref, empty_ref, almostfull_ref, almostempty_ref ;
int queue_check[$];

int error_count =0;
int correct_count =0;
        
function new (string name ="FIFO_score", uvm_component parent = null);
    super.new (name,parent);  
endfunction

function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    sb_export = new("sb_export",this);
    sb_fifo = new("sb_fifo",this);
endfunction

function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    sb_export.connect(sb_fifo.analysis_export);
endfunction

task run_phase(uvm_phase phase);
    super.run_phase(phase);
    forever begin
        sb_fifo.get(seq_item);
        ref_model(seq_item);
            if(seq_item.data_out !== data_out_ref || seq_item.wr_ack !== wr_ack_ref|| seq_item.overflow !== overflow_ref|| seq_item.underflow !== underflow_ref|| seq_item.full !== full_ref|| seq_item.empty !== empty_ref|| seq_item.almostfull !== almostfull_ref|| seq_item.almostempty !== almostempty_ref) begin
                `uvm_error("run_phase",$sformatf("Comparsion failed, Transaction received by the dut: %s while the data_out_ref: 0b%0h  while the wr_ack_ref: 0b%0b while the overflow_ref: 0b%0b while the underflow_ref: 0b%0b while the full_ref: 0b%0b while the empty_ref: 0b%0b while the almostfull_ref: 0b%0b while the almostempty_ref: 0b%0b",seq_item.convert2string(),data_out_ref,wr_ack_ref, overflow_ref,underflow_ref,full_ref, empty_ref, almostfull_ref, almostempty_ref));
                error_count++;
            end
            else begin
                `uvm_info("run_phase",$sformatf("Correct Shift reg out: %s",seq_item.convert2string()),UVM_HIGH);
                correct_count++;
            end
                end
endtask

task ref_model(FIFO_seq_item seq_item_chk);

if (!seq_item_chk.rst_n) begin
		wr_ack_ref = 0; 
		overflow_ref = 0; 
	end
	else if (seq_item_chk.wr_en && !full_ref) begin
		queue_check.push_front(seq_item_chk.data_in);
		wr_ack_ref = 1;
    overflow_ref = 0;
	end
	else begin 
		wr_ack_ref = 0; 
		if (full_ref & seq_item_chk.wr_en)
			overflow_ref = 1;
		else
			overflow_ref = 0;
	end

    if (!seq_item_chk.rst_n) begin
		underflow_ref=0; 
    queue_check.delete();
	end
	else if (seq_item_chk.rd_en && !empty_ref) begin
		data_out_ref = queue_check.pop_back();
    underflow_ref=0; 
	end
	else begin 
		if (empty_ref && seq_item_chk.rd_en) begin
			underflow_ref =1;
		end
		else begin
			underflow_ref =0;
		end
	end

 
    full_ref        = (queue_check.size() == seq_item_chk.FIFO_DEPTH)? 1 : 0;
    empty_ref       = (queue_check.size() == 0)? 1 : 0;
    almostfull_ref  = (queue_check.size() == seq_item_chk.FIFO_DEPTH-1)? 1 : 0; 
    almostempty_ref = (queue_check.size() == 1)? 1 : 0;


endtask

function void report_phase(uvm_phase phase);
    super.report_phase(phase);
    `uvm_info("report_phase",$sformatf("Total successful Transaction: %0d",correct_count),UVM_MEDIUM);
    `uvm_info("report_phase",$sformatf("Total Failed Transaction: %0d",error_count),UVM_MEDIUM);
endfunction

endclass 
    
endpackage