//`include "param.sv"
module cam_test #(parameter ARRAY_WIDTH_LOG2 = 5, parameter ARRAY_SIZE_LOG2 = 5)();
`define clk_per 10

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
		$vcdpluson;
	// making logic signals 0 at start
    clk = 1'b0;
    reset_i = 1'b1;
    read_i = 1'b0;
    read_index_i = 'b0;
    write_i = 1'b0;
    write_index_i = 'b0;
    write_data_i = 'b0;
    search_i = 1'b0;
    search_data_i = 'b0;
    #10;//clk low
		reset_i = 1'b0;
    write_index_i = 5'b00001;
    write_data_i = 32'h0000_0001;
    write_i = 1'b1;
    #5 //clk high
    #5 //clk low
    write_index_i = 5'b00011;
    write_data_i = 32'h0000_0003;
    #5 //clk high
    #5 //clk low
    write_index_i = 5'b00101;
    write_data_i = 32'h0000_0005;
    #5 //clk high
    #5 //clk low
    write_index_i = 5'b00111;
    write_data_i = 32'h0000_0007;
    #5//h
    #5 //l
    write_i=1'b0;
    read_index_i = 5'b00011;
    read_i = 1'b1;
    #5 //h
    read_index_i = 5'b00100;
    read_i = 1'b1;
    #5 //l
    read_index_i = 5'b00101;
    read_i = 1'b1;
    search_i = 1'b1;
    search_data_i = 32'h0000_0005;
    write_index_i = 5'b01001;
    write_data_i = 32'h0000_0009;
    write_i = 1'b1;
    #5 //h
    read_index_i = 5'b00101;
    read_i = 1'b1;
    write_index_i = 5'b00101;
    write_data_i = 32'h0000_0009;
    write_i = 1'b1;
    #5 //l
    search_i = 1'b1;
    search_data_i = 32'h0000_0005;
    read_index_i = 5'b00101;
    read_i = 1'b1;
    #5 //h
    #5 //l
    search_i = 1'b1;
    search_data_i = 32'h0000_0009;
    #5 //h
    #5 //l
    
    #2 $display("value of valid signal is %d\n",search_valid_o);

		end

    initial begin
    #200 $finish;
    end

endmodule
