filelist="-f ../00_src/flist.f"
tb_file="../01_tb/testbench.sv"
time_unit="-timescale 1ps/1ps"
acc_debug="+access+rwc"


PHONY:	sim
sim:
	xrun -sv \
	$(filelist) \
	$(tb_file) \
	$(time_unit) \
	$(acc_debug)

wave_data="waves.shm/"

PHONY: wave
wave:
	simvision $(wave_data) &
