transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+C:/Users/shem-/OneDrive/Documents/ECE3710/VGA {C:/Users/shem-/OneDrive/Documents/ECE3710/VGA/vgaTimer.v}
vlog -vlog01compat -work work +incdir+C:/Users/shem-/OneDrive/Documents/ECE3710/VGA {C:/Users/shem-/OneDrive/Documents/ECE3710/VGA/bitGen1.v}
vlog -vlog01compat -work work +incdir+C:/Users/shem-/OneDrive/Documents/ECE3710/VGA {C:/Users/shem-/OneDrive/Documents/ECE3710/VGA/bitGen2.v}
vlog -vlog01compat -work work +incdir+C:/Users/shem-/OneDrive/Documents/ECE3710/VGA {C:/Users/shem-/OneDrive/Documents/ECE3710/VGA/topLevel.v}
vlog -vlog01compat -work work +incdir+C:/Users/shem-/OneDrive/Documents/ECE3710/VGA {C:/Users/shem-/OneDrive/Documents/ECE3710/VGA/TbirdFSM.v}
vlog -vlog01compat -work work +incdir+C:/Users/shem-/OneDrive/Documents/ECE3710/VGA {C:/Users/shem-/OneDrive/Documents/ECE3710/VGA/ClockDivider.v}

vlog -vlog01compat -work work +incdir+C:/Users/shem-/OneDrive/Documents/ECE3710/VGA {C:/Users/shem-/OneDrive/Documents/ECE3710/VGA/tb_TOP.v}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L cyclonev_ver -L cyclonev_hssi_ver -L cyclonev_pcie_hip_ver -L rtl_work -L work -voptargs="+acc"  tb_TOP

add wave *
view structure
view signals
run -all
