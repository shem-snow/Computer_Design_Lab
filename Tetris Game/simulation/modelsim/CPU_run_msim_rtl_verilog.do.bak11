transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+C:/Users/samwi/Desktop/ECE3710/CPU {C:/Users/samwi/Desktop/ECE3710/CPU/memory.v}
vlog -vlog01compat -work work +incdir+C:/Users/samwi/Desktop/ECE3710/CPU {C:/Users/samwi/Desktop/ECE3710/CPU/FSM.v}
vlog -vlog01compat -work work +incdir+C:/Users/samwi/Desktop/ECE3710/CPU {C:/Users/samwi/Desktop/ECE3710/CPU/Decoder.v}
vlog -vlog01compat -work work +incdir+C:/Users/samwi/Desktop/ECE3710/CPU {C:/Users/samwi/Desktop/ECE3710/CPU/cpu.v}
vlog -vlog01compat -work work +incdir+C:/Users/samwi/Desktop/ECE3710/CPU {C:/Users/samwi/Desktop/ECE3710/CPU/datapath.v}
vlog -vlog01compat -work work +incdir+C:/Users/samwi/Desktop/ECE3710/CPU {C:/Users/samwi/Desktop/ECE3710/CPU/Alu.v}
vlog -vlog01compat -work work +incdir+C:/Users/samwi/Desktop/ECE3710/CPU {C:/Users/samwi/Desktop/ECE3710/CPU/regMux.v}
vlog -vlog01compat -work work +incdir+C:/Users/samwi/Desktop/ECE3710/CPU {C:/Users/samwi/Desktop/ECE3710/CPU/PS2Handler.v}
vlog -vlog01compat -work work +incdir+C:/Users/samwi/Desktop/ECE3710/CPU {C:/Users/samwi/Desktop/ECE3710/CPU/cmpDecoder.v}
vlog -vlog01compat -work work +incdir+C:/Users/samwi/Desktop/ECE3710/CPU {C:/Users/samwi/Desktop/ECE3710/CPU/exmem2.v}
vlog -vlog01compat -work work +incdir+C:/Users/samwi/Desktop/ECE3710/CPU {C:/Users/samwi/Desktop/ECE3710/CPU/regfile.v}

vlog -vlog01compat -work work +incdir+C:/Users/samwi/Desktop/ECE3710/CPU {C:/Users/samwi/Desktop/ECE3710/CPU/tb_cpu.v}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L cyclonev_ver -L cyclonev_hssi_ver -L cyclonev_pcie_hip_ver -L rtl_work -L work -voptargs="+acc"  tb_cpu

add wave *
view structure
view signals
run -all
