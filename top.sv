import uvm_pkg::*;
`include "uvm_macros.svh"
import FIFO_test_pkg::*;

module top();

bit clk;
initial begin
    clk=0;
    forever 
    #1 clk=~clk;
end
    FIFO_Interface FIFO_IF (clk);
    FIFO           DUT (FIFO_IF);
    bind           FIFO Assertions Assertions_inst (FIFO_IF);


    initial begin
        uvm_config_db#(virtual FIFO_Interface) :: set (null , "uvm_test_top","FIFO_if",FIFO_IF);
        run_test ("FIFO_test_class");
    end
endmodule