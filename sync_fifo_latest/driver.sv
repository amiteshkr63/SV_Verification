`include "transactor.sv"
class driver;
	
	virtual intf.drvmp inf;
	mailbox #(transactor) mbx_gen;
	mailbox #(transactor) mbx_sco;
	transactor tr_container;

	event ev_driven;
	function new(mailbox #(transactor) mbx_gen, mailbox #(transactor) mbx_sco);
		this.mbx_gen=mbx_gen;
		this.mbx_sco=mbx_sco;
	endfunction : new

	task reset();
		inf.rst_n <= 0;
		inf.din <= 0;
		inf.rd <= 0;
		inf.wr <= 0;
		@(posedge inf.clk);
		@(posedge inf.clk);
		@(posedge inf.clk);
		@(posedge inf.clk);
		@(posedge inf.clk);
		@(posedge inf.clk);
		@(posedge inf.clk);
		inf.rst_n <= 1;
	endtask : reset

	task run();
		forever begin
			mbx_gen.get(tr_container);
			tr_container.display("DRV");
			inf.rst_n <= 1;
			inf.din <= tr_container.din;
			inf.rd <= tr_container.rd;
			inf.wr <= tr_container.wr;
			//////////////////////////////
			tr_container.dout=inf.dout;
			tr_container.full=inf.full;
			tr_container.empty=inf.empty;
			mbx_sco.put(tr_container);
			@(posedge inf.clk);
		end
	endtask : run
endclass : driver