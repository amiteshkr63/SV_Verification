`include "interface.sv"
module d_ff (dif dif);
	always_ff @(posedge dif.clk) begin
		if(~dif.rst_n) begin
			dif.dout <= 0;
		end else begin
			dif.dout <= dif.din;
		end
	end
endmodule : d_ff