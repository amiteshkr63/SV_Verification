`include "transaction.sv"
`include "driver.sv"
`include "monitor.sv"
`include "generator.sv"
`include "scoreboard.sv"

class environment;
	generator gen;
	driver drv;
	mailbox #(transaction)mbxgd;
	mailbox #(transaction)mbxds;
	monitor mon;
	scoreboard sco;
	mailbox #(transaction)mbxms;
	event eventsg;
	virtual dif dif;

	function new(virtual dif dif);
		mbxgd=new();
		mbxds=new();
		gen=new(mbxgd);
		drv=new(mbxgd, mbxds);
		mbxms=new();
		mon=new(mbxms);
		sco=new(mbxms, mbxds);

		this.dif=dif;
		drv.dif=this.dif;
		mon.dif=this.dif;

		gen.eventsg=eventsg;
		sco.eventsg=eventsg;
	endfunction : new

	task pre_test();
		drv.reset();
	endtask : pre_test

	task test();
		fork		
			gen.run();
			drv.run();
			mon.run();
			sco.run();
		join_any
	endtask : test

	task post_test();
		wait(gen.done.triggered);
		$finish();
	endtask : post_test

	task run();
		pre_test();
		test();
		post_test();
	endtask : run

endclass : environment