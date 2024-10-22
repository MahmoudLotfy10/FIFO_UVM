vlib work
vlog *v +cover -covercells 
vsim -voptargs=+acc work.top -cover +UVM_VERBOSITY=UVM_MEDIUM -classdebug -uvmcontrol=all 

add wave -position insertpoint sim:/top/FIFO_IF/*

add wave /top/DUT/Assertions_inst/max_fifo_addr_p /top/DUT/Assertions_inst/wr_ptr1_p 
add wave /top/DUT/Assertions_inst/wr_ptr2_p /top/DUT/Assertions_inst/rd_ptr1_p 
add wave /top/DUT/Assertions_inst/rd_ptr2_p /top/DUT/Assertions_inst/counter1_p 
add wave /top/DUT/Assertions_inst/counter2_p /top/DUT/Assertions_inst/counter3_p 
add wave /top/DUT/Assertions_inst/counter4_p /top/DUT/Assertions_inst/counter5_p 
add wave /top/DUT/Assertions_inst/wr_ack1_p /top/DUT/Assertions_inst/wr_ack2_p 
add wave /top/DUT/Assertions_inst/wr_ack3_p /top/DUT/Assertions_inst/overflow1_p 
add wave /top/DUT/Assertions_inst/overflow2_p /top/DUT/Assertions_inst/overflow3_p 
add wave /top/DUT/Assertions_inst/underflow1_p /top/DUT/Assertions_inst/underflow2_p 
add wave /top/DUT/Assertions_inst/underflow3_p /top/DUT/Assertions_inst/full1_p /top/DUT/Assertions_inst/full2_p 
add wave /top/DUT/Assertions_inst/almostfull1_p /top/DUT/Assertions_inst/almostfull2_p 
add wave /top/DUT/Assertions_inst/full_almostfull1_p /top/DUT/Assertions_inst/full_almostfull2_p 
add wave /top/DUT/Assertions_inst/empty1_p /top/DUT/Assertions_inst/empty2_p /top/DUT/Assertions_inst/almostempty1_p 
add wave /top/DUT/Assertions_inst/almostempty2_p /top/DUT/Assertions_inst/empty_almostempty1_p 
add wave /top/DUT/Assertions_inst/empty_almostempty2_p


coverage save top.ucdb -onexit
run -all
#vcover report top.ucdb -details -annotate -all -output code_coverage_rpt.txt