`timescale 1ns/1ns

class transaction;

    int out_read;
    bit out_read_valid;

    int out_search;
    int out_search_valid;

    int cam[32];
    bit cam_valid[32];
    
    int next;
    int next_index;
 

    /* this checks that reset functions properly */
    function bit check_reset(bit read_valid_o, bit search_valid_o);
        int i;
        for(i=0;i<32;i=i+1) begin
            cam[i] = 0;
            cam_valid[i] = 0;
            out_search = 0;
            out_read = 0;
        end
        return((read_valid_o == 0 ) && (search_valid_o == 0));
    endfunction


    /* 
     * this is used to model the delay between
     * a combinational read and a sequential
     * write.
     */
    function void clock_tic();
        cam[next_index] = next;
        cam_valid[next_index] = 1;
    endfunction


    /*
     * run a write operation NOTE: requires clock_tic before
     * it can be applied, to simulate sequential nature of logic
     */
    function void golden_result_write(int index, int value);
        next = value;
        next_index = index;
    endfunction

    /* calulate golden output of a read op */
    function void golden_result_read(int index);
        out_read = cam[index];
        out_read_valid = cam_valid[index];
    endfunction

    /* calulate the golden output of a search */
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

    /* check if write/read functions correctly */
    function bit check_read_write(int value, bit valid);
        bit ret;
        ret = valid && out_read_valid;
        if(out_read_valid == 1) begin
            ret = ret && (value == out_read);
        end
        return ret;
    endfunction

    /* check if search functions correctly */
    function bit check_search(int index, int valid);
        bit ret;
        ret = valid && out_search_valid;
        if(out_search_valid == 1) begin
            ret = ret && (index == out_search);
        end
        return ret;    
    endfunction

endclass




/* these are used to determine how frequently
 * to run a read/write/search/reset op
 */
class testing_env;
    rand int unsigned rn;

    rand int write_value;
    rand bit write_index[5];
    rand bit read_index[5]; 
    rand int search_value;

    bit read;
    bit write;
    bit search;
    bit reset;

    int unsigned read_thresh;
    int unsigned write_thresh;
    int unsigned search_thresh;
    int unsigned reset_thresh;

    int iter;

    function void read_config(string filename);
        int file, chars_returned, seed, value;
        string param;
        file = $fopen(filename, "r");

        while(!feof(file)) begin
            chars_returned = $fscanf(file, "%s %s", param, value);
            if("RANDOM_SEED" == param) begin
                seed = value;
                $srandom(seed);
            end else if("ITERATIONS" == param) begin
                iter = value;
            end else if("READ_PROB" == param) begin
                read_thresh = value;
            end else if("WRITE_PROB" == param) begin
                write_thresh = value;
            end else if("SEARCH_PROB" == param) begin
                search_thresh = value;
            end else if("RESET_PROB" == param) begin
                reset_thresh = value;
            end
            else begin
                $display("Invalid parameter");
                $exit();
            end
        end
    endfunction

    function bit read();
        return((rn%1000)<read_thresh);
    endfunction

    function bit write();
        return((rn%1000)<write_thresh);
    endfunction

    function bit search();
        return((rn%1000)<search_thresh);
    endfunction

    function bit reset();
        return((rn%1000)<reset_thresh);
    endfunction

endclass



/* the testbench */
program cam_tb(cam_ifc.bench ds);
    transaction t;
    testing_env v;

    bit read;
    bit write;
    bit search;
    bit reset;

    initial begin
       t = new();
       v = new();
       v.read_config("config.txt");

       repeat(v.iter) begin
         t.randomize();
         v.randomize();

         //decide to read, write, search, or reset
         read = v.read();
         write = v.write();
         search = v.search();
         reset = v.reset();

         // drive inputs for next cycle
         $display("%t : %s \n", $realtime, "Driving New Values");
         //ds.cb.data_i <= t.a;
         if(reset) begin
            ds.cb.reset <= 1'b1;
         end else begin
            if(read) begin
                ds.cb.read_i <= 1'b1;
                ds.cb.read_index_i <= v.read_index; 
            end
            if(write) begin
                ds.cb.write_i <= 1'b1;
                ds.cb.write_index_i <= v.write_index;
                ds.cb.write_data_i <= v.write_value;
            end
            if(search) begin
                ds.cb.search_i <= 1'b1;
                ds.cb.search_data_i <= v.search_value;
            end
         end



         @(ds.cb);
         if(reset) begin

         end else begin
         //t.golden_result();
     
         //$display("%d \n", ds.cb.data_o);
         //$display("%d \n", t.last());

         //$display("%t : %s \n", $realtime,t.check_result(ds.cb.data_o)?"Pass":"Fail");
      end
   end

endprogram
