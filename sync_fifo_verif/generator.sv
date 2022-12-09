`include "transaction.sv"
class generator;
	transaction tr;	//Handler for transaction class
	//Because when we create an handler and add a constructor to a transaction class, then
	//only we are allowed to randomize the value for the data members
	
	mailbox #(transaction) mbx; //mailbox: mechanism to send data from generator to driver
	//parametrised mailbox helps to found bug 
	int count;
	event next;// used to know when to send next transaction
	event done;//conveys completion of requested no. of transaction
	//Helps to know ENVIRONMENT when to stop simulation

	function  new(mailbox #(transaction) mbx); //Here, we haven't mentioned direction
												//for mailbox of new(), by default-> Input direction
		this.mbx/*Class transaction mbx*/=mbx/*function new mbx*/;
		tr=new();//adding constructor for a handler
	endfunction : new

//Before we execute task run make sure, ther is count value.
	task run();
		repeat(count) begin
			//if(tr.randomize()) else $error("GEN:Randomization Failed");	
			assert(tr.randomize()) else $error("GEN:Randomization Failed");
			mbx.put(tr.copy);	//Here, referred mbx is from new() not of main generator mbx:)   
			tr.display("GEN");
			@(next);// next will sync when to generate next transaction to driver
		end
		->done;// conveys generator completes its task, It indicates the environment to take decision
		//to stop the simulation or to do the report generation process
	endtask : run
endclass : generator

/*module tb ();
	
	generator gen;
	mailbox #(transaction) mbx;

	initial begin
		//It is mandatory to call constructor for mailbox first because for mailbox, we added a
		//custom mailbox. and, also mailbox should not be void before calling constructor for handler of generator
		mbx=new();
		gen=new(mbx);
		gen.count=20;
		gen.run();
	end

endmodule : tb*/