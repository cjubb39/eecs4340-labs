
module cam #(
parameter ARRAY_WIDTH_LOG2 = 5,
parameter ARRAY_SIZE_LOG2 = 5
)
(
  input clk,
  input reset_i,

  input logic read_i,
  input logic [ARRAY_WIDTH_LOG2 - 1:0] read_index_i,
  input logic write_i,
  input logic [ARRAY_WIDTH_LOG2 - 1:0] write_index_i,
  input logic [2**ARRAY_WIDTH_LOG2 - 1:0] write_data_i,
  input logic search_i,
  input logic [2**ARRAY_WIDTH_LOG2 - 1:0] search_data_i,

  output logic read_valid_o,
  output logic [2**ARRAY_WIDTH_LOG2 - 1:0] read_value_o,
  output logic search_valid_o,
  output logic [ARRAY_WIDTH_LOG2 - 1:0] search_index_o
);
 
wire [2**ARRAY_WIDTH_LOG2 - 1:0] out_value; /* if we are reading */
wire [ARRAY_WIDTH_LOG2 - 1:0] out_index; /* if we are searching */

logic found;
logic written;

logic [2**ARRAY_WIDTH_LOG2 - 1:0] cam [2**ARRAY_SIZE_LOG2 - 1:0];
logic [2**ARRAY_SIZE_LOG2 - 1:0] cam_v; 

/* index for cam search */
logic [ARRAY_SIZE_LOG2-1:0] i;

assign read_valid_o = read_i && written;
assign search_valid_o = search_i && found;
assign read_value_o = out_value;
assign search_index_o = out_index;


/* read functionality */
always_comb begin
    if(~reset_i) begin
        out_value = 'b0;
        written = 1'b0;
    end
    else begin
        if(read_i) begin
            written = cam_v[read_index_i];
            /* not optimal to drive to 0 */
            out_value = (cam_v[read_index_i] == 1'b1) ? cam[read_index_i] : 'b0; 
        end
    end
end
      

/* search functionality */
always_comb begin
    if(~reset_i) begin
        out_index = 'b0;
        found = 1'b0;
    end
    else begin
        found = 1'b0;
        /* this is ugly */
        for(i='b0;i<2**ARRAY_SIZE_LOG2;i=i+1'b1) begin
            if(cam_v[i]==1'b1) begin
                if(cam[i] == search_data_i) begin
                    found = 1'b1;
                    out_index = i;
                    i = 2**ARRAY_SIZE_LOG2; /* break */
                end
            end
        end
    end
end

/* write functionality */
always_ff @(posedge clk) begin
    if(~reset_i) begin
        /* dont bother reseting whole cam */
        cam_v <= 'b0;
    end
    else begin
        if(write_i)
            /* need to replace this with stock FF */
            {cam[write_index_i],cam_v[write_index_i]} <= {write_data_i, 1'b1};
    end
end




endmodule