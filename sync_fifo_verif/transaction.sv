`ifndef TRANSACTION
`define TRANSACTION

class transaction;
	rand bit rd;
	rand bit wr;
	rand bit [7:0]data_in;
	bit empty, full;
	bit [7:0]data_out;

	constraint wr_rd{
		rd!=wr;
		wr dist{0 :/50, 1:/50};
		rd dist{0 :/50, 1:/50};
	}

	constraint data_cons {
		data_in>0;
		data_in<10;
	}
	//tag_purpose: which class calling method_display, so that we can know where 
	//data_flow is not proper
	function void display(input string tag);
		$display("[%0s] : WR : %0b\tRD : %0b\tDATARD : %0d\tDATAWR : %0d\tEMPTY : %0b\tFULL : %0b\t @ %0t", tag, wr, rd, data_out, data_in, empty, full, $time);
	endfunction : display

//Deep_Copy
	function transaction copy(); //Only works when void is not used and function type is same as of class 
		copy=new();
		copy.rd=this.rd;
		copy.wr=this.wr;
		copy.data_in=this.data_in;
		copy.data_out=this.data_out;
		copy.empty=this.empty;
		copy.full=this.full;
	endfunction : copy
endclass
`endif

//Purpose of Copy: Sending deep copy of an object instead of sending
//an original object when we send the data from generator to driver

/*module tb ();
	transaction tr;
	initial begin
		tr=new();
		tr.display("TOP");
	end
endmodule : tb
*/