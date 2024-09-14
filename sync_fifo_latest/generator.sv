`include "transactor.sv"
class generator;

	transactor tr;
	mailbox #(transactor) mbx;

	
	int count;

	event ev_sco; //Scoreboard Event
	event ev_env; //Environment event

	function new(mailbox #(transactor) mbx);
		this.mbx = mbx;
		tr=new();
	endfunction : new

	task run();
		repeat(count) begin
			assert(tr.randomize()) else $display("GEN:: Randomization Failed");
			mbx.put(tr.copy);
			tr.display("GEN");
			@(ev_sco);
			$display("=================================================================================================");
		end
		->ev_env;
		$finish();
	endtask : run
endclass : generator