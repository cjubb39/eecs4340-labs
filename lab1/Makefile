build:
	vcs -full64 -sverilog +lint=all,noVCDE -debug_pp cam.sv cam_test.sv register.sv ff.sv priorityencoder.sv -o cam

run:
	./cam

view:
	vpd2vcd vcdplus.vpd vcdplus.vcd &
	gtkwave vcdplus.vcd &

clean:
	rm -rf csrc *.daidir *.exe *.log *.inf .leda_work *.key *.vpd *.vcd DVEfiles cam
