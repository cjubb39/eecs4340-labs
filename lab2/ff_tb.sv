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

    function bit check_reset(bit x);
        out=0;
        next = 0;
        return (x==0);
    endfunction

endclass

class testing_env;
    rand int unsigned rn;
    int reset_thresh;
    int write_thresh;
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
            write_thresh = value;
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

function get_write();
    return ((rn%1000)<write_thresh);
endfunction
function get_reset();
    return ((rn%1000)<reset_thresh);
endfunction

endclass

program ff_tb(ff_ifc.bench ds);
	transaction t;
    testing_env v; 

	initial begin
		t = new();
        v = new();
        v.read_config("config.txt");

		repeat(v.iter) begin
			t.randomize();
            v.randomize();

            write = v.get_write();
            reset = v.get_reset();

			// drive inputs for next cycle
		    if(reset) begin
			    $display("%t : %s \n", $realtime, "Driving reset");
                ds.cb.reset <= 1'b1;
            end else if(write) begin
			    $display("%t : %s : %d \n", $realtime, "Driving value ", t.a);
                ds.cb.data_i <= t.a;
            end

			@(ds.cb);
			t.golden_result();

            if(reset) begin
			    $display("%t : %s \n", $realtime,t.check_reset(ds.cb.data_o)?"Pass-reset":"Fail-reset");
            end else if(write) begin
			    $display("%t : %s \n", $realtime,t.check_result(ds.cb.data_o)?"Pass-write":"Fail-write");
            end

		end
	end

endprogram
