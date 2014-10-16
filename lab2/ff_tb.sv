`timescale 1ns/1ns

class transaction;
	bit out;
	bit next;
	
	function void golden_result(bit reset, bit n);
		out = next;
		next = (reset==1) ? 0:n;
	endfunction

	function bit check_result(bit x);
		return(x == out);
	endfunction

        function bit check_reset(bit x);
        	return ((x==out)&&(next==0));
        endfunction

endclass




class testing_env;
    rand int unsigned rn;
    rand bit a;
    
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
            //read_thresh = value;
        end else if("WRITE_PROB" == param) begin
            //write_thresh = value;
        end else if("SEARCH_PROB" == param) begin
            //search_thresh = value;
        end else if("RESET_PROB" == param) begin
            reset_thresh = value;
        end
        else begin
            $display("Invalid parameter");
            $exit();
        end
    end
endfunction

function get_reset();
    return ((rn%1000)<reset_thresh);
endfunction

endclass




program ff_tb(ff_ifc.bench ds);
	transaction t;
    	testing_env v; 

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
			@(ds.cb);

		repeat(v.iter) begin
            		v.randomize();

            		reset = v.get_reset();

			// drive inputs for next cycle
		    	if(reset) begin
			    $display("%t : %s \n", $realtime, "Driving reset");
                	    ds.cb.reset <= 1'b1;
            		end else begin
				ds.cb.reset <= 1'b0;	
			    	$display("%t : %s : %d \n", $realtime, "Driving value ", v.a);
                	    	ds.cb.data_i <= v.a;
            		end

			@(ds.cb);
			t.golden_result(reset, v.a);

            		if(reset) begin
			    $display("%t : %s \n", $realtime,t.check_reset(ds.cb.data_o)?"Pass-reset":"Fail-reset");
//			    $display("%d : %d \n", ds.cb.data_o, t.out);
            		end else begin
			    $display("%t : %s \n", $realtime,t.check_result(ds.cb.data_o)?"Pass-write":"Fail-write");
//			    $display("%d : %d : %d \n", ds.cb.data_o, t.out, t.next);
            		end
		end
	end

endprogram
