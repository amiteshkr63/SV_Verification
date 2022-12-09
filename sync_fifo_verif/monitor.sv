`include "transaction.sv"
class monitor;
	transaction tr;
	virtual fifo_if fif;
	mailbox #(transaction) mbx;
	event next;
	
	function  new(mailbox #(transaction) mbx);
		this.mbx=mbx;
	endfunction : new

	task run();
		tr=new();
		forever begin
			repeat(2)@(posedge fif.clk);//Here, we are capturing interface, after 2 clk period: As opposite of driver
			tr.wr=fif.wr;
			tr.rd=fif.rd;
			tr.data_in=fif.data_in;
			tr.data_out=fif.data_out;
			tr.full=fif.full;
			tr.empty=fif.empty;
			mbx.put(tr);
			tr.display("MON");
		end
	endtask : run

endclass : monitor
