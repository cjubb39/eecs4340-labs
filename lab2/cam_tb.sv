`timescale 1ns/1ns

class transaction;
    rand int in;
    int out_read;
    bit out_read_valid;

    int out_search;
    int out_search_valid;

    int cam[32];
    bit cam_valid[32];
 
    function bit check_reset(bit read_valid_o, bit search_valid_o);
        return((read_valid_o == 0 ) && (search_valid_o == 0));
    endfunction


    function void golden_result_write(int index, int value);
        cam[index] = value;
        cam_valid[index] = 1;
    endfunction

    function void golden_result_read(int index);
        out_read = cam[index];
        out_read_valid = cam_valid[index];
    endfunction

    function void golden_result_search(int value);
        int i = 0;
        int found = 0;
        for(i=0;i<32;i=i+1) begin
            if((cam[i] == value) &&(cam_valid[i] == 1)) begin
                found = 1;
                i = 32;
            end
        end
        if(found == 1) begin
            out_search = i;
            out_search_valid = 1;
        end else begin
            out_search_valid = 0;
        end

    endfunction

    function bit check_read_write(int value, bit valid);
        bit ret;
        ret = valid && out_read_valid;
        if(read_valid_o == 1) begin
            ret = ret && value = out_read;
        end
        return ret;
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
