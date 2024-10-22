module Assertions(FIFO_Interface.DUT FIFO_IF);

localparam max_fifo_addr = DUT.max_fifo_addr;
logic [max_fifo_addr-1:0] wr_ptr, rd_ptr;
logic [max_fifo_addr:0] count;

assign wr_ptr = DUT.wr_ptr;
assign rd_ptr = DUT.rd_ptr;
assign count  = DUT.count;
//EXTA
// max_fifo_addr Assertions
always_comb begin  
	max_fifo_addr_p: assert final (max_fifo_addr == $clog2(FIFO_IF.FIFO_DEPTH));	
end
//EXTA
// wr_ptr Assertions
//immediate because the rst is async
always_comb begin  
	if(!FIFO_IF.rst_n)
	wr_ptr1_p: assert final (wr_ptr == 0);	
end

property wr_ptr2;
 @(posedge FIFO_IF.clk) disable iff (!FIFO_IF.rst_n)  (FIFO_IF.wr_en && count < FIFO_IF.FIFO_DEPTH) |-> ##1 (wr_ptr == ($past(wr_ptr)+1'b1));
endproperty
wr_ptr2_p: assert property (wr_ptr2);
wr_ptr2_c: cover  property (wr_ptr2);
//EXTA
// rd_ptr Assertions
//immediate because the rst is async
always_comb begin  
	if(!FIFO_IF.rst_n)
	rd_ptr1_p: assert final (rd_ptr == 0);	
end

property rd_ptr2;
 @(posedge FIFO_IF.clk) disable iff (!FIFO_IF.rst_n)  (FIFO_IF.rd_en && count != 0) |-> ##1 (rd_ptr == ($past(rd_ptr)+1'b1));
endproperty
rd_ptr2_p: assert property (rd_ptr2);
rd_ptr2_c: cover  property (rd_ptr2);


// Counter Assertions 
//immediate because the rst is async
always_comb begin  
	if(!FIFO_IF.rst_n)
	counter1_p: assert final (count == 0);	
end

property counter2;
 @(posedge FIFO_IF.clk) disable iff (!FIFO_IF.rst_n) (({FIFO_IF.wr_en, FIFO_IF.rd_en} == 2'b10) && !FIFO_IF.full) |-> ##1 (count == ($past(count)+1'b1))
endproperty
counter2_p: assert property (counter2);
counter2_c: cover  property (counter2);


property counter3;
 @(posedge FIFO_IF.clk) disable iff (!FIFO_IF.rst_n) (({FIFO_IF.wr_en, FIFO_IF.rd_en} == 2'b01) && !FIFO_IF.empty) |-> ##1 (count == ($past(count)-1'b1))
endproperty
counter3_p: assert property (counter3);
counter3_c: cover  property (counter3);

property counter4;
 @(posedge FIFO_IF.clk) disable iff (!FIFO_IF.rst_n) (({FIFO_IF.wr_en, FIFO_IF.rd_en} == 2'b11) && FIFO_IF.full) |-> ##1 (count == ($past(count)-1'b1))
endproperty
counter4_p: assert property (counter4);
counter4_c: cover  property (counter4);

property counter5;
 @(posedge FIFO_IF.clk) disable iff (!FIFO_IF.rst_n) (({FIFO_IF.wr_en, FIFO_IF.rd_en} == 2'b11) && FIFO_IF.empty) |-> ##1 (count == ($past(count)+1'b1))
endproperty
counter5_p: assert property (counter5);
counter5_c: cover  property (counter5);

// wr_ack Assertions
//immediate because the rst is async
always_comb begin  
	if(!FIFO_IF.rst_n)
	wr_ack1_p: assert final (FIFO_IF.wr_ack == 0);	
end

property wr_ack2;
 @(posedge FIFO_IF.clk) disable iff (!FIFO_IF.rst_n) (FIFO_IF.wr_en && count < FIFO_IF.FIFO_DEPTH)  |-> ##1 (FIFO_IF.wr_ack == 1);
endproperty
wr_ack2_p: assert property (wr_ack2);
wr_ack2_c: cover  property (wr_ack2);

property wr_ack3;
 @(posedge FIFO_IF.clk) disable iff (!FIFO_IF.rst_n) (!FIFO_IF.wr_en || !(count < FIFO_IF.FIFO_DEPTH))  |-> ##1 (FIFO_IF.wr_ack == 0);
endproperty
wr_ack3_p: assert property (wr_ack3);
wr_ack3_c: cover  property (wr_ack3);

//overflow Assertions
//immediate because the rst is async
always_comb begin  
	if(!FIFO_IF.rst_n)
	overflow1_p: assert final (FIFO_IF.overflow == 0);	
end

property overflow2;
 @(posedge FIFO_IF.clk) disable iff (!FIFO_IF.rst_n) (FIFO_IF.full && FIFO_IF.wr_en) |-> ##1 (FIFO_IF.overflow == 1);
endproperty
overflow2_p: assert property (overflow2);
overflow2_c: cover  property (overflow2);

property overflow3;
 @(posedge FIFO_IF.clk) disable iff (!FIFO_IF.rst_n) ((!FIFO_IF.full) && FIFO_IF.wr_en) |-> ##1 (FIFO_IF.overflow == 0);
endproperty
overflow3_p: assert property (overflow3);
overflow3_c: cover  property (overflow3);

//underflow Assertions
//immediate because the rst is async
always_comb begin  
	if(!FIFO_IF.rst_n)
	underflow1_p: assert final (FIFO_IF.underflow == 0);	
end

property underflow2;
 @(posedge FIFO_IF.clk) disable iff (!FIFO_IF.rst_n) (FIFO_IF.empty && FIFO_IF.rd_en) |-> ##1 (FIFO_IF.underflow == 1);
endproperty
underflow2_p: assert property (underflow2);
underflow2_c: cover  property (underflow2);

property underflow3;
 @(posedge FIFO_IF.clk) disable iff (!FIFO_IF.rst_n) ((!FIFO_IF.empty) && FIFO_IF.rd_en) |-> ##1 (FIFO_IF.underflow == 0);
endproperty
underflow3_p: assert property (underflow3);
underflow3_c: cover  property (underflow3);


// full Assertions
property full1;
 @(posedge FIFO_IF.clk)  (count == FIFO_IF.FIFO_DEPTH)  |->  (FIFO_IF.full == 1);
endproperty
full1_p: assert property (full1);
full1_c: cover  property (full1);

property full2;
 @(posedge FIFO_IF.clk)  (count != FIFO_IF.FIFO_DEPTH)  |->  (FIFO_IF.full == 0);
endproperty
full2_p: assert property (full2);
full2_c: cover  property (full2);

// almostfull Assertions
property almostfull1;
 @(posedge FIFO_IF.clk)  (count == (FIFO_IF.FIFO_DEPTH-1'b1))  |->  (FIFO_IF.almostfull == 1);
endproperty
almostfull1_p: assert property (almostfull1);
almostfull1_c: cover  property (almostfull1);

property almostfull2;
 @(posedge FIFO_IF.clk)  (count != (FIFO_IF.FIFO_DEPTH-1'b1))  |->  (FIFO_IF.almostfull == 0);
endproperty
almostfull2_p: assert property (almostfull2);
almostfull2_c: cover  property (almostfull2);
//EXTRA
// compination assertions between full and almostfull 
property full_almostfull1;
 @(posedge FIFO_IF.clk) disable iff (!FIFO_IF.rst_n) (FIFO_IF.almostfull && (!(FIFO_IF.rd_en)&&(FIFO_IF.wr_en)) )  |-> ##1  (FIFO_IF.full);
endproperty
full_almostfull1_p: assert property (full_almostfull1);
full_almostfull1_c: cover  property (full_almostfull1);


property full_almostfull2;
 @(posedge FIFO_IF.clk) disable iff (!FIFO_IF.rst_n) (FIFO_IF.full && ((FIFO_IF.rd_en)&&(!FIFO_IF.wr_en)) )  |-> ##1  (FIFO_IF.almostfull);
endproperty
full_almostfull2_p: assert property (full_almostfull2);
full_almostfull2_c: cover  property (full_almostfull2);

// empty Assertions
property empty1;
 @(posedge FIFO_IF.clk)  (count == 0)  |->  (FIFO_IF.empty == 1);
endproperty
empty1_p: assert property (empty1);
empty1_c: cover  property (empty1);

property empty2;
 @(posedge FIFO_IF.clk)  (count != 0)  |->  (FIFO_IF.empty == 0);
endproperty
empty2_p: assert property (empty2);
empty2_c: cover  property (empty2);


// almostempty Assertions
property almostempty1;
 @(posedge FIFO_IF.clk)  (count == 1)  |->  (FIFO_IF.almostempty == 1);
endproperty
almostempty1_p: assert property (almostempty1);
almostempty1_c: cover  property (almostempty1);

property almostempty2;
 @(posedge FIFO_IF.clk)  (count != 1)  |->  (FIFO_IF.almostempty == 0);
endproperty
almostempty2_p: assert property (almostempty2);
almostempty2_c: cover  property (almostempty2);

//EXTRA
// compination assertions between empty and almostempty
property empty_almostempty1;
 @(posedge FIFO_IF.clk) disable iff (!FIFO_IF.rst_n) (FIFO_IF.almostempty && (!(FIFO_IF.wr_en)&& (FIFO_IF.rd_en)) )  |-> ##1  (FIFO_IF.empty);
endproperty
empty_almostempty1_p: assert property (empty_almostempty1);
empty_almostempty1_c: cover  property (empty_almostempty1);


property empty_almostempty2;
 @(posedge FIFO_IF.clk) disable iff (!FIFO_IF.rst_n) (FIFO_IF.empty && ((FIFO_IF.wr_en)&& (!FIFO_IF.rd_en)) )  |-> ##1  (FIFO_IF.almostempty);
endproperty
empty_almostempty2_p: assert property (empty_almostempty2);
empty_almostempty2_c: cover  property (empty_almostempty2);
    
endmodule