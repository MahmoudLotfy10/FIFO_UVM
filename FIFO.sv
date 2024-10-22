////////////////////////////////////////////////////////////////////////////////
// Author: Kareem Waseem
// Course: Digital Verification using SV & UVM
//
// Description: FIFO Design 
// 
////////////////////////////////////////////////////////////////////////////////
module FIFO(FIFO_Interface.DUT FIFO_IF);
 
localparam max_fifo_addr = FIFO_IF.max_fifo_addr;

reg [FIFO_IF.FIFO_WIDTH-1:0] mem [FIFO_IF.FIFO_DEPTH-1:0];

reg [max_fifo_addr-1:0] wr_ptr, rd_ptr;
reg [max_fifo_addr:0] count;

always @(posedge FIFO_IF.clk or negedge FIFO_IF.rst_n) begin
	if (!FIFO_IF.rst_n) begin
		wr_ptr <= 0;
		FIFO_IF.wr_ack <= 0; // modified
		FIFO_IF.overflow <= 0; // modified
	end
	else if (FIFO_IF.wr_en && count < FIFO_IF.FIFO_DEPTH) begin
		mem[wr_ptr] <= FIFO_IF.data_in;
		FIFO_IF.wr_ack <= 1;
		wr_ptr <= wr_ptr + 1;
		FIFO_IF.overflow <= 0; // modified
	end
	else begin 
		FIFO_IF.wr_ack <= 0; 
		if (FIFO_IF.full & FIFO_IF.wr_en)
			FIFO_IF.overflow <= 1;
		else
			FIFO_IF.overflow <= 0;
	end
end

always @(posedge FIFO_IF.clk or negedge FIFO_IF.rst_n) begin
	if (!FIFO_IF.rst_n) begin
		rd_ptr <= 0;
		FIFO_IF.underflow<=0; // modified
	end
	else if (FIFO_IF.rd_en && count != 0) begin
		FIFO_IF.data_out <= mem[rd_ptr];
		rd_ptr <= rd_ptr + 1;
		FIFO_IF.underflow<=0; // modified
	end
	else begin // modified
		if (FIFO_IF.empty && FIFO_IF.rd_en) begin
			FIFO_IF.underflow<=1;
		end
		else begin
			FIFO_IF.underflow<=0;
		end
	end
end

always @(posedge FIFO_IF.clk or negedge FIFO_IF.rst_n) begin
	if (!FIFO_IF.rst_n) begin
		count <= 0;
	end
	else begin
		if	( ({FIFO_IF.wr_en, FIFO_IF.rd_en} == 2'b10) && !FIFO_IF.full) 
			count <= count + 1;
		else if ( ({FIFO_IF.wr_en, FIFO_IF.rd_en} == 2'b01) && !FIFO_IF.empty)
			count <= count - 1;
		else if (({FIFO_IF.wr_en, FIFO_IF.rd_en} == 2'b11) && FIFO_IF.full) begin // modified
			count <= count - 1;
		end
		else if (({FIFO_IF.wr_en, FIFO_IF.rd_en} == 2'b11) && FIFO_IF.empty) begin // modified
			count <= count + 1;
		end
	end
end

assign FIFO_IF.full = (count == FIFO_IF.FIFO_DEPTH)? 1 : 0;
assign FIFO_IF.empty = (count == 0)? 1 : 0;
assign FIFO_IF.almostfull = (count == FIFO_IF.FIFO_DEPTH-1)? 1 : 0; /// modified (-2 => -1)
assign FIFO_IF.almostempty = (count == 1)? 1 : 0;

endmodule
