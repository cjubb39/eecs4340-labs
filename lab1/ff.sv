
module ff #(
parameter SIZE = 5
)
(
  input clk,
  input reset_i,

  input logic [SIZE-1:0] in,
  output logic [SIZE- 1:0] out 
);
 
always_ff @(posedge clk) begin
    if(~reset_i) begin
        /* dont bother reseting whole cam */
        out <= 'b0;
    end
    else begin
        out <= in;
    end
end




endmodule
