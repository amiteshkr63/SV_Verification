`include "environment.sv"
module top_tb ();
	
	environment env;
	dif dif();
	
	d_ff dutt(dif);

	initial begin
		dif.clk<=0;
	end

	always #5 dif.clk<=~dif.clk;

	initial begin
		env=new(dif);
		env.gen.count=20;
		env.run();
	end

endmodule : top_tb