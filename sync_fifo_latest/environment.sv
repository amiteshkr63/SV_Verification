`include "generator.sv"
`include "driver.sv"
`include "monitor.sv"
`include "scoreboard.sv"

class environment;
	generator gen;
	driver drv;
	monitor mon;
	scoreboard sco;

	event done;

	mailbox #(transactor)gen2drv;
	mailbox #(transactor)drv2sco;
	mailbox #(transactor)mon2sco;

	virtual intf inf;

	function new(virtual intf inf);
		
		gen2drv=new();
		drv2sco=new();
		gen =new(gen2drv);
		drv =new(gen2drv, drv2sco);
		
		mon2sco=new();
		mon =new(mon2sco);
		sco = new(drv2sco, mon2sco);
		
		this.inf=inf;
		drv.inf=this.inf.drvmp;
		mon.inf=this.inf.monmp;

		sco.scodone=done;
		gen.ev_sco=done;

	endfunction : new

	task prereset();
		drv.reset();
	endtask : prereset

	task test();
		fork
			gen.run();
			drv.run();
			mon.run();
			sco.run();
		join_any
	endtask : test

	task post_test();
		wait(gen.ev_env.triggered);
	endtask : post_test

	task run();
		prereset();
		test();
		post_test();
	endtask : run
endclass : environment