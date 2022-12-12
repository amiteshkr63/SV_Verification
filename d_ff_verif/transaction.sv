`ifndef TRANSACTION
`define TRANSACTION
class transaction;
	rand logic din;
	logic dout;
	
	function void display(input string tag);
		$display("[%s]   :   DIN:%d   :   DOUT:%d   @%t", tag, din, dout, $time);
	endfunction : display

	//Deep Copy
	function transaction copy();
		copy=new();
		copy.din=this.din;
		copy.dout=this.dout;
	endfunction : copy
endclass : transaction
`endif