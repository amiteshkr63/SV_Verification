`include "transaction.sv"
class monitor;
	
	transaction tr;
	mailbox #(transaction)mbxms;
	virtual dif dif;
	
	function new(mailbox #(transaction)mbxms);
		this.mbxms=mbxms;
	endfunction : new

	task run();
		tr=new();
		forever begin
			@(posedge dif.clk);
			tr.dout=dif.dout;
			mbxms.put(tr);
			tr.display("MON");
		end
	endtask : run

endclass : monitor