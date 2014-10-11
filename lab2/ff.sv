
module ff #(
parameter SIZE =1 
)
(
  input clk,
  input reset_i,

  input logic [SIZE-1:0] data_i,
  output logic [SIZE- 1:0] data_o
);

reg [SIZE-1:0] data;

assign data_o = data;


always_ff @(posedge clk) begin
    if(reset_i) begin
        data <= 'b0;
    end
    else begin
        data <= data_i;
    end
end




endmodule
