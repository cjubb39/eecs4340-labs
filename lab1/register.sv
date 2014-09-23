
module register #(
parameter SIZE = 5
)
(
  input clk,
  input reset_i,

  input logic [SIZE-1:0] data_i,
  output logic [SIZE- 1:0] data_o
);

ff #(.SIZE(SIZE)) ff_inst(.*);

endmodule
