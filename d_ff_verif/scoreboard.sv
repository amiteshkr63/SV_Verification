`include "transaction.sv"
class scoreboard;
	transaction mtrc;
	transaction dtrc;
	mailbox #(transaction)mbxms;
	mailbox #(transaction)mbxds;
	event eventsg;

	function new(mailbox #(transaction)mbxms, mailbox #(transaction)mbxds);
		this.mbxds=mbxds;
		this.mbxms=mbxms;
	endfunction : new

	task run();
		forever begin
			mbxms.get(mtrc);
			mbxds.get(dtrc);
			trc.display("SCO");
			if (dtrc.din==mtrc.dout) begin
				$display("[SCO]  :  Data Matched");
			end
			else begin
				$display("[SCO]  :  Data Not Matched");
			end
			->eventsg;
		end
	endtask : run
endclass : scoreboard