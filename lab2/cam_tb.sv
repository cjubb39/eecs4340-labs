`timescale 1ns/1ns

class transaction;
    rand int in;
    int out_read;
    int out_search;
    int cam[32];
 
    function bit check_reset(bit read_valid_o, bit search_valid_o);
        return((read_valid_o == 0 ) && (search_valid_o == 0));
    endfunction


    function void golden_result_write(int index, int value);
        cam[index] = value;
    endfunction

    function void golden_result_read(int index);
        out_read = cam[index];
    endfunction

    //function void golden_result_search(int value);
        
    //endfunction

    function bit check_read_write(int val);
        return(val = out_read);
    endfunction

    //function bit check_search(int x)
    //
    //endfunction

endclass


program cam_tb(cam_ifc.bench ds);
    transaction t;

    initial begin
       t = new();
       repeat(100) begin
         //t.randomize();

         // drive inputs for next cycle
         $display("%t : %s \n", $realtime, "Driving New Values");
         //ds.cb.data_i <= t.a;

         @(ds.cb);
         //t.golden_result();
     
         //$display("%d \n", ds.cb.data_o);
         //$display("%d \n", t.last());

         //$display("%t : %s \n", $realtime,t.check_result(ds.cb.data_o)?"Pass":"Fail");
      end
   end

endprogram
