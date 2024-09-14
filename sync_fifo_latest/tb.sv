`include "environment.sv"
module tb;

	environment env;

	intf inf1();
	sync_fifo inst_sync_fifo (.inf(inf1.dutmp));

	initial begin
		inf1.clk = 0;
		forever #5 inf1.clk = ~inf1.clk;
	end

	initial begin
		env=new(inf1);
		env.gen.count=20;
		env.run();
	end
endmodule : tb