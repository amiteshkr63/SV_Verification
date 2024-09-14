`include "transactor.sv"
class scoreboard;
	transactor tr_container_drv;
	transactor tr_container_mon;
	mailbox #(transactor)mbx_drv;
	mailbox #(transactor)mbx_mon;

	event scodone;

	bit [7:0]din[$];
	bit [7:0]temp;
	int rd_request=0;

	function new(mailbox #(transactor) mbx_drv, mailbox #(transactor) mbx_mon);
		this.mbx_drv=mbx_drv;
		this.mbx_mon=mbx_mon;
	endfunction : new

	task run();
		forever begin
			mbx_drv.get(tr_container_drv);
			mbx_mon.get(tr_container_mon);
			tr_container_drv.display("SCO_DRV");
			tr_container_mon.display("SCO_MON");

			if (rd_request) begin
				rd_request=0;
				if(tr_container_mon.dout == din.pop_back()) $display("[SCO]::Data Matched");
				else $display("[SCO]::Data Not Matched");
			end

			if (tr_container_drv.wr) begin
				if(~tr_container_mon.full) begin
					din.push_front(tr_container_drv.din);
					$display("[SCO]:: Data stored in Queue",);
				end
				else $display("[SCO]:: FIFO is Full",);
				->scodone;
			end

			if (tr_container_drv.rd) begin
				if (~tr_container_mon.empty) begin
					rd_request=1;
					$display("[SCO]::Read Request Received");
				end
				else begin
					rd_request=0;
					$display("[SCO]:: FIFO is Empty",);
				end
				->scodone;
			end
			else ->scodone;
		end
	endtask : run
endclass : scoreboard