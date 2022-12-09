`include "environment.sv"
module tb ();
	environment env;
  	fifo_if fif();
  	sync_FIFO_dut uut(fif.clk, fif.rst_n, fif.rd, fif.wr, fif.data_in,
		fif.data_out, fif.empty, fif.full);

	initial begin
		fif.clk<=0;
	end
  
	always #10 fif.clk<=~fif.clk;

	initial begin
		env=new(fif);
		env.gen.count=40;//
		env.run();
	end

	initial begin
		#10000;
		$finish();
	end
  
  	initial begin
		$dumpfile("dump.vcd");
		$dumpvars;
	end
  
endmodule : tb