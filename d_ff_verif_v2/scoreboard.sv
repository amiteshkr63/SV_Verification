`include "transaction.sv"
class scoreboard;
	transaction mtrc;
	transaction dtrc;
	transaction strc;
	mailbox #(transaction)mbxms;
	mailbox #(transaction)mbxds;
	event eventsg;

	function new(mailbox #(transaction)mbxms,
				 mailbox #(transaction)mbxds);
		this.mbxds=mbxds;
		this.mbxms=mbxms;
		strc=new();
	endfunction : new

	task run();
		forever begin
			mbxms.get(mtrc);
			mbxds.get(dtrc);
			strc.din=dtrc.din;
			strc.dout=mtrc.dout;
			strc.display("SCO");
			if (strc.din==strc.dout) begin
				$display("[SCO]  :  Data Matched");
			end
			else begin
				$display("[SCO]  :  Data Not Matched");
			end
			->eventsg;
		end
	endtask : run
endclass : scoreboard