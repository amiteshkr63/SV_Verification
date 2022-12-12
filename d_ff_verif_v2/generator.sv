`include "transaction.sv"
class generator;
	transaction tr;
	int count=0;//
	mailbox #(transaction)mbxgd;
	event eventsg;
	event done;

	function new(mailbox #(transaction)mbxgd);
		this.mbxgd=mbxgd;
		tr=new();
	endfunction : new

	task run();
		repeat(count) begin
			assert(tr.randomize()) else $display("Unable to randomize transaction class");
			mbxgd.put(tr.copy);
			tr.display("GEN");
			@eventsg;
		end
		->done;
	endtask : run

endclass : generator