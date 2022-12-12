`include "transaction.sv"
class driver;
	transaction trc;
	mailbox #(transaction)mbxgd;
	virtual dif dif;
	event next;

	function new(mailbox #(transaction)mbxgd);
		this.mbxgd=mbxgd;
	endfunction : new

	task reset();
		dif.rst_n<=1'b0;
		dif.din<=0;
		repeat(3)@(posedge dif.clk);
		dif.rst_n<=1'b1;
		$display("DUT DONE RESETING @%t",$time);
	endtask : reset

	task run();
		forever begin
			mbxgd.get(trc);
			dif.din<=trc.din;
			trc.display("DRV");
			@(posedge dif.clk);
			->next;
		end
	endtask : run
endclass : driver