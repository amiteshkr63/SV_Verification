module sync_FIFO_dut (
	input clk,    // Clock
	input rst_n,  // Asynchronous reset active low
	input rd,
	input wr,
  input [7:0]data_in,
  output reg [7:0]data_out,
	output empty, full
);
reg [3:0]rdptr,wrptr;
reg [7:0]fifo_mem[7:0];

always_ff @(posedge clk) begin
	if(~rst_n) begin
		rdptr<=0;
		wrptr<=0;
		data_out <=0;
		for (int i = 0; i < 8; i++) begin
			fifo_mem[i] <= 0;
		end
	end else begin
      if(rd && (!empty)) begin
		 data_out <=fifo_mem[rdptr[2:0]];
		 fifo_mem[rdptr[2:0]]<=0;
		 rdptr<=rdptr+1; 
		end
      else if(wr && (!full)) begin
			data_out<=0;
			fifo_mem[wrptr[2:0]]<=data_in;
			wrptr<=wrptr+1;
		end
		else begin
			data_out<=0;
			rdptr<=rdptr;
			wrptr<=wrptr;
		end
	end
end

assign empty=(rdptr==wrptr);
assign full=(rdptr[3]!=wrptr[3])&&(rdptr[2:0]==wrptr[2:0]);

endmodule : sync_FIFO_dut

/*interface fifo_if ();
	logic clk;
	logic rst_n;
	logic rd;
	logic wr;
	logic [7:0]data_in;
	logic [7:0]data_out;
	logic empty;
	logic full;
endinterface : fifo_if*/