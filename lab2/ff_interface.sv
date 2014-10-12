`timescale 1ns/1ns

interface ff_ifc #(paramter SIZE=1)(input bit clk);
   logic [SIZE-1:0] data_i;
   logic [SIZE-1:0] data_o;

   // note that the outputs and inputs are reversed from the dut
   clocking cb @(posedge clk);
      output    data_i;
      input     data_o;
   endclocking

   modport bench (clocking cb);

   modport dut (
        input  data_i,
        output data_o
        );
endinterface