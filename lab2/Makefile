DUV=ff
TEST=ff_tb
BENCH=ff_tb.exe


all: 
	make clean
	make test
	make view

test:
	vcs -full64 -PP -sverilog +define+SV +define+VPD $(DUV).sv $(TEST).sv -o $(BENCH)
	./$(BENCH)
	
view:
	dve -full64 -vpd vcdplus.vpd &

leda:
	leda -full64 -sverilog -top $(DUV) $(DUV).sv
	
clean:
	rm -rf csrc *.exe.daidir *.exe *.log *.inf .leda_work *.key *.vpd *.vcd DVEfiles
