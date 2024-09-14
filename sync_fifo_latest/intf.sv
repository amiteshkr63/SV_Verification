interface intf();

	logic clk;
	logic rst_n;
	logic [7:0]din;
	logic wr;
	logic rd;
	logic [7:0]dout;
	logic full;
	logic empty;
	
	modport dutmp(input clk, input rst_n, input din, input wr, input rd, output dout, output full, output empty);
	modport drvmp(input clk, output rst_n, output din, output wr, output rd, input dout, input full, input empty);
	modport monmp(input clk, input rst_n, input din, input wr, input rd, input dout, input full, input empty);

endinterface : intf