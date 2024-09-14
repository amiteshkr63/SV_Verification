module sync_fifo_tb;

	intf inf();
	sync_fifo inst_sync_fifo (.inf(inf.dutmp));

	initial begin
		fork
			begin
				inf.rst_n <= 1'b0;
				#10;
				inf.rst_n <= 1'b1;
			end
			begin
				inf.clk <= 1'b0;
				forever #5 inf.clk <= ~inf.clk;
			end
		join
	end

	always begin
		{inf.wr, inf.rd} <= $random;
		inf.din <= $random;
		#10;
	end
endmodule : sync_fifo_tb