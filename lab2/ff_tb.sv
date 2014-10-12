`timescale 1ns/1ns

class transaction;
    rand bit a;
    bit out;

    function void golden_result;
        out = a;
    endfunction

    function bit check_result(bit x);
        return(x == out);
    endfunction
endclass

program tb(ff_ifc.bench ds);
    transaction t;

    initial begin
        repeat(10000) begin
    t = new();
    t.randomize();

     // drive inputs for next cycle
     $display("%t : %s \n", $realtime, "Driving New Values");
     ds.cb.data_i <= t.a;
     @(ds.cb);
     t.golden_result();
     $display("%t : %s \n", $realtime,t.check_result(ds.cb.data_o)?"Pass":"Fail");
      end
   end

endprogram
