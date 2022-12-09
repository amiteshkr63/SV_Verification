`include "transaction.sv"
class driver;
	virtual fifo_if fif;
	mailbox #(transaction) mbx;
	transaction tr_container; //not needed to call constructor for it. Because we are 
	//containing the contents of mailbox in tr_container  
	event next;// Notify completion of driver task 

	function new(mailbox #(transaction) mbx);
		this.mbx=mbx;
	endfunction : new

//NBA helps to get the correct behaviour as compared to blocking assignment
	task reset();
		fif.rst_n<=1'b0;
		fif.rd<=1'b0;
		fif.wr<=1'b0;
		fif.data_in<=1'b0;
      	repeat(5)@(posedge fif.clk);
		fif.rst_n<=1'b1;
	endtask : reset
//reset task will be handeled via environment class

	task run();
		forever begin//except generator every class will have "forever" in "run" ||Monitor and Scoreboard=> have forever
			mbx.get(tr_container);
	        tr_container.display("DRV");
			fif.rd<=tr_container.rd;
			fif.wr<=tr_container.wr;
			fif.data_in<=tr_container.data_in;
			repeat(2)@(posedge fif.clk);//Here, we are triggering interface, and waiting for 2 clk period
			->next;
		end
	endtask : run

endclass : driver

/*module tb ();
	generator gen;
	driver drv;
	event next;
	mailbox #(transaction) mbx;
	fifo_if fif(); //Instantiations must have brackets
	sync_FIFO_dut uut(fif.clk, fif.rst_n, fif.rd, fif.wr, fif.data_in,
		fif.data_out, fif.empty, fif.full);
	initial begin
		fif.clk<=0;
	end
	
	always #10 fif.clk<=~fif.clk;
	
	initial begin
		mbx=new();
		gen=new(mbx);
		gen.count=100;
		drv=new(mbx);
		drv.fif=fif;	//Connecting interface of driver with dut's interface
		drv.next=next;	//Merging of event of driver and generator via tb
		gen.next=next;
	end

	initial begin
      drv.reset();
		fork
			gen.run();
			drv.run();
		join
	end
	
	initial begin
		#1000;
		$finish();
	end

	initial begin
		$dumpfile("dump.vcd");
		$dumpvars;
	end*/
