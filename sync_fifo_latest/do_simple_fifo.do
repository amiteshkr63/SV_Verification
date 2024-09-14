vlib work
vlog ./intf.sv
vlog ./sync_fifo.sv
vlog ./sync_fifo_tb.sv

vsim -voptargs=+acc -fsmdebug -debugDB work.sync_fifo_tb
add wave -r *
run 2000