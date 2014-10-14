
module cam #(
parameter ARRAY_WIDTH_LOG2 = 5,
parameter ARRAY_SIZE_LOG2 = 5
)
(cam_ifc.dut d);
 
/* combinational outputs */
logic [2**ARRAY_WIDTH_LOG2 - 1:0] out_value; /* if we are reading */
logic [ARRAY_WIDTH_LOG2 - 1:0] out_index; /* if we are searching */

/* indicate data found (search) or data previously written (read) */
logic found;
logic written;


/* these connect a 32x32 CAM and 32x1 valid array
 * with registers we designed in class
 */
logic [2**ARRAY_WIDTH_LOG2 - 1:0] cam_i [2**ARRAY_SIZE_LOG2 - 1:0];
wire [2**ARRAY_WIDTH_LOG2 - 1:0] cam_o [2**ARRAY_SIZE_LOG2 - 1:0];
logic [2**ARRAY_SIZE_LOG2 - 1:0] cam_v_i; 
wire [2**ARRAY_SIZE_LOG2 - 1:0] cam_v_o; 



/* CAM search */
logic [2**ARRAY_SIZE_LOG2-1:0] priority_in; /*output of ANDing CAM entries with input */
logic [ARRAY_SIZE_LOG2-1:0] result; /*output of priority encoder (index of entry) */
wire priority_res; /* search result is valid */


assign d.read_valid_o = d.read_i && written; /*read if value was previously written */
assign d.search_valid_o = d.search_i && found; /*search_o if value found in CAM */
assign d.read_value_o = out_value; /*output read result */
assign d.search_index_o = out_index;/*output search index */


/* read functionality */
/* read_valid_o = exists in cam AND valid entry */
/* read_o = entry in cam */
always_comb begin
    if(d.reset) begin
        out_value = 'b0;
        written = 1'b0;
    end
    else begin
        if(d.read_i) begin
	    /* cam_v_o high if previously written */
            written = cam_v_o[d.read_index_i];
            /* only update output if the entry is valid (lower power) */
		case(cam_v_o[d.read_index_i])
			1'b0: out_value = out_value;
			1'b1: out_value = cam_o[d.read_index_i];
		endcase
        end
    end
end
      


priorityencoder #(.SIZE(ARRAY_SIZE_LOG2)) pri_inst (.inp_i(priority_in), .out_o(out_index), .valid_o(priority_res));

/* search functionality */
/* STEPS:
 * AND search input with cam entries
 * AND that with validity of entries
 * this generates a 32 bit value where 1's indicate
 *    valid hits in the CAM
 * send this to a priority encoder to generate
 *    an index
 * output this index 
 */
always_comb begin
    if(d.reset) begin
        found = 'b0;
    end
    else begin
        if(d.search_i) begin
           /* AND cam entries with input, and that with validity of entry */
	   priority_in = {(cam_o[31] == d.search_data_i)&cam_v_o[31],   
                               (cam_o[30]==d.search_data_i)&cam_v_o[30],         
                               (cam_o[29]==d.search_data_i)&cam_v_o[29],         
                               (cam_o[28]==d.search_data_i)&cam_v_o[28],         
                               (cam_o[27]==d.search_data_i)&cam_v_o[27],         
                               (cam_o[26]==d.search_data_i)&cam_v_o[26],         
                               (cam_o[25]==d.search_data_i)&cam_v_o[25],         
                               (cam_o[24]==d.search_data_i)&cam_v_o[24],        
                               (cam_o[23]==d.search_data_i)&cam_v_o[23],         
                               (cam_o[22]==d.search_data_i)&cam_v_o[22],         
                               (cam_o[21]==d.search_data_i)&cam_v_o[21],        
                               (cam_o[20]==d.search_data_i)&cam_v_o[20],         
                               (cam_o[19]==d.search_data_i)&cam_v_o[19],         
                               (cam_o[18]==d.search_data_i)&cam_v_o[18],         
                               (cam_o[17]==d.search_data_i)&cam_v_o[17],         
                               (cam_o[16]==d.search_data_i)&cam_v_o[16],         
                               (cam_o[15]==d.search_data_i)&cam_v_o[15],         
                               (cam_o[14]==d.search_data_i)&cam_v_o[14],         
                               (cam_o[13]==d.search_data_i)&cam_v_o[13],         
                               (cam_o[12]==d.search_data_i)&cam_v_o[12],         
                               (cam_o[11]==d.search_data_i)&cam_v_o[11],         
                               (cam_o[10]==d.search_data_i)&cam_v_o[10],         
                               (cam_o[9]==d.search_data_i)&cam_v_o[9],         
                               (cam_o[8]==d.search_data_i)&cam_v_o[8],         
                               (cam_o[7]==d.search_data_i)&cam_v_o[7],         
                               (cam_o[6]==d.search_data_i)&cam_v_o[6],         
                               (cam_o[5]==d.search_data_i)&cam_v_o[5],         
                               (cam_o[4]==d.search_data_i)&cam_v_o[4],         
                               (cam_o[3]==d.search_data_i)&cam_v_o[3],         
                               (cam_o[2]==d.search_data_i)&cam_v_o[2],         
                               (cam_o[1]==d.search_data_i)&cam_v_o[1],         
			       (cam_o[0]==d.search_data_i)&cam_v_o[0]}; 
            found = priority_res;
        end
    end
end




/* write functionality */
/* cam valid register */
register #(.SIZE(2**ARRAY_SIZE_LOG2)) ar_inst (.clk(d.clk), .reset(d.reset), .data_i(cam_v_i), .data_o(cam_v_o));

/*generate registers for CAM entries */
generate
for(genvar iter = 0; iter<2**ARRAY_SIZE_LOG2;iter++) begin
register #(.SIZE(2**ARRAY_SIZE_LOG2)) ar_inst(.clk(d.clk), .reset(d.reset), .data_i(cam_i[iter]), .data_o(cam_o[iter]));
end
endgenerate

/* if write, place on input of FF */
always_comb begin
    if(d.reset) begin
        cam_v_i = 'b0;
    end
    else begin
        if(d.write_i)
            // places on input wires of FF  
            {cam_i[d.write_index_i],cam_v_i[d.write_index_i]} = {d.write_data_i, 1'b1};
    end
end


endmodule
