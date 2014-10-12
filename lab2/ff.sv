
module ff #(parameter SIZE =32)(ifc.dut d);

reg [SIZE-1:0] data;

assign data_o = data;


always_ff @(posedge d.clk) begin
    if(d.reset) begin
        data <= 'b0;
    end
    else begin
        data <= d.data_i;
    end
end


endmodule
