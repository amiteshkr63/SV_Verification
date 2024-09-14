vlib work
vlog ./intf.sv
vlog ./sync_fifo.sv
vlog ./transactor.sv
vlog ./generator.sv
vlog ./driver.sv
vlog ./monitor.sv
vlog ./scoreboard.sv
vlog ./environment.sv
vlog ./tb.sv
vsim -voptargs=+acc -fsmdebug -debugDB work.tb
add wave -r *
run 200