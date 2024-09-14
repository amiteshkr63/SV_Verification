`include "transactor.sv"
class monitor;

	virtual intf.monmp inf;
	transactor tr_container;
	mailbox #(transactor)mbx;

	function new(mailbox #(transactor)mbx);
		this.mbx=mbx;
	endfunction : new

	task run();
		tr_container=new();
		forever begin
			@(posedge inf.clk);
			tr_container.wr=inf.wr;
			tr_container.rd=inf.rd;
			tr_container.din=inf.din;
			tr_container.dout=inf.dout;
			tr_container.empty=inf.empty;
			tr_container.full=inf.full;
			mbx.put(tr_container);
			tr_container.display("MON");
		end
	endtask : run
endclass : monitor