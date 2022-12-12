`include "transaction.sv"
class driver;
	transaction trc;
	transaction tr;
	mailbox #(transaction)mbxgd;
	mailbox #(transaction)mbxds;
	virtual dif dif;
	//event next;

	function new(mailbox #(transaction)mbxgd, mailbox #(transaction)mbxds);
		this.mbxgd=mbxgd;
		this.mbxds=mbxds;
		tr=new();
	endfunction : new

	task reset();
		dif.rst_n<=1'b0;
		dif.din<=0;
		repeat(3)@(posedge dif.clk);
		dif.rst_n<=1'b1;
		repeat(3)@(posedge dif.clk);
		$display("DUT DONE RESETING @%t",$time);
	endtask : reset

	task run();
		forever begin
			mbxgd.get(trc);
			mbxds.put(tr);
			@(posedge dif.clk);////////////
			dif.din<=trc.din;
			trc.display("DRV");
			//->next;///////
		end
	endtask : run
endclass : driver