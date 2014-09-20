`include "param.sv"
module cam_test #(parameter ARRAY_WIDTH_LOG2 = 5, parameter ARRAY_SIZE_LOG2 = 5)();
`define clk_per 100

    logic clk;
    logic reset_i;

    logic read_i;
    logic [ARRAY_WIDTH_LOG2 - 1:0] read_index_i;
    logic write_i;
    logic [ARRAY_WIDTH_LOG2 - 1:0] write_index_i;
    logic [2**ARRAY_WIDTH_LOG2 - 1:0] write_data_i;
    logic search_i;
    logic [2**ARRAY_WIDTH_LOG2 - 1:0] search_data_i;

    logic read_valid_o;
    logic [2**ARRAY_WIDTH_LOG2 - 1:0] read_value_o;
    logic search_valid_o;
    logic [ARRAY_WIDTH_LOG2 - 1:0] search_index_o;



    cam cam_inst (.*);

    always #(`clk_per/2) clk = ~clk;
    
    initial begin
	/* $vcdpluson; */
	// making logic signals 0 at start
	
    /* #2 $display("value of valid signal is %d\n",valid); */


	end

    initial begin
    #200 $finish;
    end

endmodule
