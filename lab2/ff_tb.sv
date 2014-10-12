
module ff_tb #(
parameter SIZE = 1
)();
`define clk_per 10

    logic clk;
    logic reset_i;

    logic [SIZE-1:0] data_i;
    logic [SIZE-1:0] data_o;

    ff ff_inst (.*);

    always #(`clk_per/2) clk = ~clk;
    
    initial begin
    $vcdpluson;
    // making logic signals 0 at start
    

    end

    initial begin
    #200 $finish;
    end

    initial begin
	//$monitor("%d\t%d\t%d\t%d", read_value_o, read_valid_o, search_index_o, search_valid_o);
    end
endmodule
