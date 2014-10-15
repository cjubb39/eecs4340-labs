`timescale 1ns/1ns

class transaction;

    int out_read;
    bit out_read_valid;

    int out_search;
    int out_search_valid;

    int cam[32];
    bit cam_valid[32];
    
    int last;
    int last_index;
    bit last_valid;
 

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
     * run a write operation NOTE: requires clock_tic before
     * it can be applied, to simulate sequential nature of logic
     */
    function void golden_result_write(int index, int value);
        last = cam[index];
	last_index = index;
	last_valid = cam_valid[index];
	cam[index] = value;
	cam_valid[index] = 1;
    endfunction

    /* calulate golden output of a read op */
    function void golden_result_read(int index);
	if(index == last_index) begin
	    out_read = last;
	    out_read_valid = last_valid;
	end else begin
	    out_read = cam[index];
	    out_read_valid = cam_valid[index];
	end
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
    rand logic[5:0] write_index;
    rand logic[5:0] read_index; 
    rand int search_value;

    bit read;
    bit write;
    bit search;
    bit reset;

    int read_thresh;
    int write_thresh;
    int search_thresh;
    int reset_thresh;

    int iter;

    function void read_config(string filename);
        int file, chars_returned, seed, value;
        string param;
        file = $fopen(filename, "r");

        while(!$feof(file)) begin
            chars_returned = $fscanf(file, "%s %d", param, value);
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

    function bit get_read();
        return((rn%1000)<read_thresh);
    endfunction

    function bit get_write();
        return((rn%1000)<write_thresh);
    endfunction

    function bit get_search();
        return((rn%1000)<search_thresh);
    endfunction

    function bit get_reset();
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

       repeat(10) begin
            ds.cb.reset <= 1'b1;
            @(ds.cb);
       end

       ds.cb.reset <= 1'b0;

       repeat(v.iter) begin
         t.randomize();
         v.randomize();

         //decide to read, write, search, or reset
         read = v.get_read();
         write = v.get_write();
         search = v.get_search();
         reset = v.get_reset();

         // drive inputs for next cycle
         $display("%t : %s \n", $realtime, "Driving New Values");
         
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
	 //golden results
	 t.golden_result_write(v.write_index, v.write_value);
	 t.golden_result_read(v.read_index);
	 t.golden_result_search(v.search_value);

         if(reset) begin
             $display("%t : %s \n", $realtime,t.check_reset(ds.cb.read_valid_o, ds.cb.search_valid_o)?"Pass-reset":"Fail-reset");
         end else begin
            if(read) begin
             $display("%t : %s \n", $realtime,t.check_read_write(ds.cb.read_value_o, ds.cb.read_valid_o)?"Pass-read":"Fail-read");
	    end
            if(search) begin
             $display("%t : %s \n", $realtime,t.check_search(ds.cb.search_index_o, ds.cb.search_valid_o)?"Pass-search":"Fail-search");
	    end
  	 end
      end
   end

endprogram
