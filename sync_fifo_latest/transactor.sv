`ifndef TRANSACTION
`define TRANSACTION
class transactor;
	rand bit wr;
	rand bit rd;
	rand bit [7:0]din;
	bit [7:0]dout;
	bit full;
	bit empty;

	constraint wr_rd_cons {
		wr != rd;
		wr dist {0:/50, 1:/50};
		rd dist {0:/50, 1:/50};
	}

	constraint din_cons {
		din > 0;
		din < 10;
	}

	function void display(input string tag);
		$display("[%s]::@%0t\tWR=%b\tRD=%b\tDIN=%d\tDOUT=%d\tFULL=%b\tEMPTY=%b\t\n", tag, $time, wr, rd, din, dout, full, empty);
	endfunction : display

	//DEEP COPY
	function transactor copy();
		copy = new();
		copy.wr = this.wr;
		copy.rd = this.rd;
		copy.din = this.din;
		copy.dout = this.dout;
		copy.empty = this.empty;
		copy.full = this.full;
	endfunction : copy

endclass : transactor
`endif