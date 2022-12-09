`include "generator.sv"
`include "transaction.sv"
`include "driver.sv"
`include "monitor.sv"
`include "scoreboard.sv"
class environment;

	generator gen;
	driver drv;
	monitor mon;
	scoreboard sco;

	mailbox #(transaction) gdmbx; 	//generator + driver
	mailbox #(transaction) msmbx;	//monitor + scoreboard

	event nextgs;	//to tell scorebpoard generator generated one stimulus

	virtual fifo_if fif;

function new(virtual fifo_if fif);

	gdmbx=new();
	gen=new(gdmbx);
	drv=new(gdmbx);

	msmbx=new();
	mon=new(msmbx);
	sco=new(msmbx);

	this.fif=fif;
	drv.fif=this.fif;
	mon.fif=this.fif;

	gen.next=nextgs;
	sco.next=nextgs;

endfunction : new

task pre_test();
	drv.reset();
endtask : pre_test

task test();
	fork  				//We are using fork join because we want these task to run parallely
		gen.run();
		drv.run();
		mon.run();
		sco.run();
	join_any 			//If any of one of them are over then we are going to exit "test" task
endtask : test

task post_test();
	wait(gen.done.triggered); //event done in generator specify generator done generating stimulus
	$finish();
endtask : post_test

task run();
	pre_test();
	test();
	post_test();
endtask : run
endclass : environment
