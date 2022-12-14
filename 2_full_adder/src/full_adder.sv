module full_adder (
	input a,
	input b,
	input cin,
	output sum,
	output carry
);

assign {carry, sum} = a + b + cin;

endmodule : full_adder