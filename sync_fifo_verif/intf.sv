/*interface intf (input bit clk);
	logic rd_wrbar;
	logic data_in;
	logic data_out;
	
	clocking drvrcb @(posedge clk);
		default input #1ns output #1ns;
		output rd_wrbar;
		output data_in;
	endclocking

	modport drvrmp (clocking drvrcb, output rst_n, input clk);
	
	clocking moncb @(posedge clk);
		default input #1ns output #1ns;
		input rd_wrbar;
		input data_in;
		input data_out;
	endclocking
	
	 modport monmp (clocking moncb, input clk);

endinterface : intf*/

interface fifo_if ();
	logic clk;
	logic rst_n;
	logic rd;
	logic wr;
	logic [7:0]data_in;
	logic [7:0]data_out;
	logic empty;
	logic full;
endinterface : fifo_if