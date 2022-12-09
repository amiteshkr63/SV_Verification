`include "transaction.sv"
class scoreboard;
	mailbox #(transaction) mbx;
	transaction tr_container;
	event next;

	bit [7:0]din[$];
	bit [7:0]temp;

	function new(mailbox #(transaction) mbx);
		this.mbx=mbx;
	endfunction : new

	task run();
		forever begin
			mbx.get(tr_container);
			if (tr_container.wr) begin
				if (!tr_container.full) begin
					din.push_front(tr_container.data_in);
					$display("[SCO]: Data stored in queue",);			
				end
				else $display("[SCO]: FIFO is Full");
				->next;
			end		
			if (tr_container.rd) begin
				if (!tr_container.empty) begin
					if(tr_container.data_out==din.pop_back()) begin
						$display("[SCO]: Data Matched");
					end
					else $display("[SCO]: Data Mismatched");
				end
				else $display("[SCO]: FIFO is Empty");
			->next;
			end
			else ->next;
		end
	endtask : run
endclass : scoreboard


/*module tb ();
	scoreboard sco;
	monitor mon;
	event next;
	mailbox #(transaction) mbx;
  fifo_if fif();
  
  	sync_FIFO_dut uut(fif.clk, fif.rst_n, fif.rd, fif.wr, fif.data_in,
		fif.data_out, fif.empty, fif.full);

	initial begin
		fif.clk<=0;
	end
  
	always #10 fif.clk<=~fif.clk;
	initial begin
		mbx=new();
		mon=new(mbx);
		sco=new(mbx);
		mon.fif=fif;
		mon.next=next;
		sco.next=next;
	end

	initial begin
		fork
			mon.run();
			sco.run();
		join
	end
	
	initial begin
		#800;
		$finish();
	end
  
  	initial begin
		$dumpfile("dump.vcd");
		$dumpvars;
	end
  
endmodule : tb*/