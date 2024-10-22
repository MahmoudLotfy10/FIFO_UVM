package FIFO_seq_item_pkg;
import uvm_pkg::*;
`include "uvm_macros.svh"
class FIFO_seq_item extends uvm_sequence_item;

`uvm_object_utils (FIFO_seq_item)
parameter FIFO_WIDTH = 16;
parameter FIFO_DEPTH = 8;

rand bit [FIFO_WIDTH-1:0] data_in;
rand bit rst_n, wr_en, rd_en;

bit [FIFO_WIDTH-1:0] data_out;
bit wr_ack, overflow,underflow; 
bit full, empty, almostfull, almostempty ;

int RD_EN_ON_DIST=30,WR_EN_ON_DIST=70;
function new (string name ="FIFO_seq_item");
  super.new (name);
    
endfunction

constraint RST {
    rst_n dist {0:=2, 1:=98};
}

constraint write_enable_dist {
    wr_en dist {1:=WR_EN_ON_DIST, 0:=(100-WR_EN_ON_DIST)};
}

constraint read_enable_dist {
    rd_en dist {1:=RD_EN_ON_DIST, 0:=(100-RD_EN_ON_DIST)};
}


function string convert2string ();
    return $sformatf("%s rst_n=0b%0b ,data_in=0h%0h ,wr_en=0b%0b, rd_en=0b%0b ,data_out=0h%0h, wr_ack=0b%0b, overflow=0b%0b, underflow=0b%0b , full=0b%0b, empty=0b%0b,almostfull=0b%0b, almostempty=0b%0b ",super.convert2string (), rst_n,data_in, wr_en, rd_en,data_out,wr_ack, overflow,underflow,full, empty, almostfull, almostempty);
endfunction
    

function string convert2string_stimulus ();
    return $sformatf("rst_n=0b%0b ,data_in=0h%0h ,wr_en=0b%0b, rd_en=0b%0b ,data_out=0h%0h, wr_ack=0b%0b, overflow=0b%0b, underflow=0b%0b , full=0b%0b, empty=0b%0b,almostfull=0b%0b, almostempty=0b%0b ",rst_n,data_in, wr_en, rd_en,data_out,wr_ack, overflow,underflow,full, empty, almostfull, almostempty);
endfunction
    
endclass
    
endpackage