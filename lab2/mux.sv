module mux #(
	parameter WIDTH = 5,
)
(
	inp0_i,
	inp1_i,
	inp2_i,
	inp3_i,
	inp4_i,
	inp5_i,
	inp6_i,
	inp7_i,
	inp8_i,
	inp9_i,
	inp10_i,
	inp11_i,
	inp12_i,
	inp13_i,
	inp14_i,
	inp15_i,
	inp16_i,
	inp17_i,
	inp18_i,
	inp19_i,
	inp20_i,
	inp21_i,
	inp22_i,
	inp23_i,
	inp24_i,
	inp25_i,
	inp26_i,
	inp27_i,
	inp28_i,
	inp29_i,
	inp30_i,
	inp31_i,
	selector_i,
	out_o,
);

input inp0_i;
input inp1_i;
input inp2_i;
input inp3_i;
input inp4_i;
input inp5_i;
input inp6_i;
input inp7_i;
input inp8_i;
input inp9_i;
input inp10_i;
input inp11_i;
input inp12_i;
input inp13_i;
input inp14_i;
input inp15_i;
input inp16_i;
input inp17_i;
input inp18_i;
input inp19_i;
input inp20_i;
input inp21_i;
input inp22_i;
input inp23_i;
input inp24_i;
input inp25_i;
input inp26_i;
input inp27_i;
input inp28_i;
input inp29_i;
input inp30_i;
input inp31_i;
input [WIDTH-1:0] selector_i;
output out_o,

always_comb begin
	case (selector)
		5'd00: out_o = inp0_i;
		5'd01: out_o = inp1_i;
		5'd02: out_o = inp2_i;
		5'd03: out_o = inp3_i;
		5'd04: out_o = inp4_i;
		5'd05: out_o = inp5_i;
		5'd06: out_o = inp6_i;
		5'd07: out_o = inp7_i;
		5'd08: out_o = inp8_i;
		5'd09: out_o = inp9_i;
		5'd10: out_o = inp10_i;
		5'd11: out_o = inp11_i;
		5'd12: out_o = inp12_i;
		5'd13: out_o = inp13_i;
		5'd14: out_o = inp14_i;
		5'd15: out_o = inp15_i;
		5'd16: out_o = inp16_i;
		5'd17: out_o = inp17_i;
		5'd18: out_o = inp18_i;
		5'd19: out_o = inp19_i;
		5'd20: out_o = inp20_i;
		5'd21: out_o = inp21_i;
		5'd22: out_o = inp22_i;
		5'd23: out_o = inp23_i;
		5'd24: out_o = inp24_i;
		5'd25: out_o = inp25_i;
		5'd26: out_o = inp26_i;
		5'd27: out_o = inp27_i;
		5'd28: out_o = inp28_i;
		5'd29: out_o = inp29_i;
		5'd30: out_o = inp30_i;
		5'd31: out_o = inp31_i;
	endcase
end
endmodule
