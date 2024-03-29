#Lab 1 Overview
---
A CAM implementation in SystemVerilog. It consists of three primary functions: Read, Write, and Search. We wrote a test bench to test not only that each functionality works indepently but also that all functionalities work simultaneously (i.e. read and search output immediately, write occurs at subsequent clock posedge).  This test bench was verified by both inspecting the waveforms and printing values directly from the test bench.

#CAM
Our cam is implemented using the registers we built in class. We connect to it from combinational logic in our file using wires. 

##Read
Read takes as input an index, and then simply returns the value on the output wires of the flip flops corresponding to that index, outputing valid if and only if the valid bit for that cam entry is 1. This means that the value had been written by a previous write. 

##Write
When we are given an index and data to write to, along with a valid bit, we put the data on the input of a flip flop. This way, the value is stored in the register only on the next cycle. We also put 1'b1 on the input of a separate set of flip flops which we use to indicate whether a value has been written or not. 


##Search
We wanted to avoid a large block of if-else. To do this, we AND the search value with the output values from every entry in the CAM and generate a 32-bit value where 1's indicate matches with the CAM value (only if the value in the cam is valid). We then run this into a priority encoder, which gives us the index of the first matching entry in the cam. If no entry is found, our search_valid_o is set to 0. 


Additional details can be found in the in-code comments.

##Testbench output
read_o 	read_valid 	search_o 	search_valid
0	     0	 	   0		      0 
3	     1	 	   0		      0
3	     0	 	   0		      0
5	     1	 	   5		      1
9	     1	 	   5		      0
9	     1	 	   5		      1

###Functionality check
Row 1: reset
Row 2: 3 written to index 3 previous, read index 3
Row 3: Read index 4 (nothing written there previously)
Row 4: Read index 5, search "5", write "9" to index 5
Row 5: Read index 5, search "5", write "5" to index 9
Row 6: Read index 5, search "9"

 
