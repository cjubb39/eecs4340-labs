
module register #(
	parameter SIZE = 5
)
(
	input clk,
	input reset,

	input logic [SIZE-1:0] data_i,
	output logic [SIZE- 1:0] data_o
);

cff #(.SIZE(SIZE)) ff_inst(.*);

endmodule
