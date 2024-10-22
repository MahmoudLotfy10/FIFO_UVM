interface FIFO_Interface(clk);
parameter FIFO_WIDTH = 16;
parameter FIFO_DEPTH = 8;
parameter max_fifo_addr = $clog2(FIFO_DEPTH);
input clk;
logic [FIFO_WIDTH-1:0] data_in;
logic rst_n, wr_en, rd_en;
logic [FIFO_WIDTH-1:0] data_out;
logic wr_ack, overflow,underflow; 
logic full, empty, almostfull, almostempty ;



modport DUT (
input data_in,
input clk, rst_n, wr_en, rd_en,

output data_out,
output wr_ack, overflow,underflow,
output full, empty, almostfull, almostempty 
);

endinterface