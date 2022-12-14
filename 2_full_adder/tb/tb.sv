module tb ()     ; 

	logic  a     ;
	logic  b     ;
	logic  cin   ;
	logic  sum	 ;
	logic  carry ;
	int    pkt   ;

	full_adder inst_full_adder (.a(a),
								.b(b),
								.cin(cin),
								.sum(sum),
								.carry(carry)
								);

	task init() 								       ;
		a <= '0 								       ;
		b <= '0 								       ;
		cin<='0 								       ;
		if (!($value$plusargs("PKT=%0d", pkt))) begin
			pkt=20 						               ;
		end
	endtask : init

	task drive(int iter) 											                           								 ;
		for(int it = 0; it < iter; it++) begin
			a <= $random 											                           								 ;
			b <= $random 											                           								 ;
			cin <= $random 											                           								 ;
			$display("[DRV]:  a:   %d   b:   %d   cin:   %d                             @%t", a, b, cin, $time)      		 ;
			#10 													                           								 ;
		end
	endtask : drive

	task monitor(int iter)																					                 ;
		for(int it = 0; it < iter; it++) begin
			$display("[MON]:  a:   %d   b:   %d   cin:   %d   SUM:   %d   CARRY:   %d     @%t", a, b, cin, sum, carry, $time);
			#10 																							                 ;
		end
	endtask : monitor

	task check(int iter)                                    																 ;
		for(int it = 0; it < iter; it++) begin
			if ( (sum == (a ^ b ^ cin) ) && ( carry == (a & b) || (b & cin) || (a & cin) ) ) begin
				$display("[CHCK]: DATA MATCHED                                           @%t", $time)						 ;
			end
			else begin
				$display("[CHCK]: DATA MISMATCHED                                        @%t", $time)						 ;
			end
			#10																												 ;
		end
	endtask	: check

	task run(int pkt)	 ;
		fork
			drive(pkt)	 ;
			monitor(pkt) ;
			check(pkt)	 ;
		join_any
	endtask : run

	initial begin
		init() 			 ;
		#10 			 ;
		run(pkt)         ;
		$finish() 		 ;
	end
endmodule
