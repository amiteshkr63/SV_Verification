module sync_fifo (intf.dutmp inf);

	reg [7:0]mem[15:0];
	reg [3:0]wptr;
	reg [3:0]rptr;
	reg [3:0]cnt;

	always_ff @(posedge inf.clk) begin
		if(~inf.rst_n) begin
			inf.dout <= 0;
			wptr <= 0;
			rptr <= 0;
			cnt <= 0;
			for (int i = 0; i < 'd15; i++) begin
				mem[i] <= 'd0;
			end
		end else begin
			if (~inf.full && inf.wr && ~inf.rd) begin
				inf.dout <= 'd0;
				mem[wptr] <= inf.din;
				wptr <= wptr + 1'b1;
				cnt <= cnt + 1'b1; 
			end
			else if (~inf.empty && inf.rd && ~inf.wr) begin
				inf.dout <= mem[rptr];
				rptr <= rptr + 1'b1;
				cnt <= cnt - 1'b1; 
			end
			else if (inf.rd && inf.wr)begin
				if(~inf.empty) inf.dout <= mem[rptr];
				else inf.dout <= 0;
				if(~inf.full) mem[wptr] <= inf.din;
				else mem[wptr] <= mem[wptr];
				rptr <= rptr + 1'b1;
				wptr <= wptr + 1'b1;
				cnt <= cnt;
			end
		end
	end

	assign inf.full = (cnt =='d15)?1:0;
	assign inf.empty = (cnt =='d0)?1:0;

endmodule : sync_fifo