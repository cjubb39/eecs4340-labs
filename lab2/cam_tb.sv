`timescale 1ns/1ns

class transaction;
    rand bit a;
    bit out;
    bit next;
 
    function void golden_result;
        out = next;
	next = a;
    endfunction

    function bit last;
        return next;
    endfunction

    function bit check_result(bit x);
        return(x == out);
    endfunction
endclass


program cam_tb(cam_ifc.bench ds);
    transaction t;

    initial begin
       t = new();
       repeat(100) begin
         t.randomize();

         // drive inputs for next cycle
         $display("%t : %s \n", $realtime, "Driving New Values");
         ds.cb.data_i <= t.a;

         @(ds.cb);
         t.golden_result();
     
         $display("%d \n", ds.cb.data_o);
         $display("%d \n", t.last());

         $display("%t : %s \n", $realtime,t.check_result(ds.cb.data_o)?"Pass":"Fail");
      end
   end

endprogram
