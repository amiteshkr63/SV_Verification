`include "environment.sv"
module tb ();
	
	environment env;
	bit[31:0] pkt;
	fifo_if fif();
  	
  	sync_FIFO_dut uut(fif.clk, fif.rst_n, fif.rd, fif.wr, fif.data_in,
		fif.data_out, fif.empty, fif.full);

	initial begin
		fif.clk<=0;
	end
  
	always #10 fif.clk<=~fif.clk;

	initial begin
		env=new(fif);
		if ($value$plusargs("PKT=%d",pkt)) begin
			env.gen.count=pkt;
			$display("TOTAL PACKET GENERATED=%d", pkt);
		end
		else begin
			env.gen.count=20;
			$display("HELLO pkt=%d", pkt);
		end 
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