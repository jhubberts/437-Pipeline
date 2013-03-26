# ECE437 Makefile

COMPILE.VHDL = vcom
COMPILE.VHDLFLAGS = -93
COMPILE.V = vlog
COMPILE.VFLAGS = +acc
COMPILE.SV = vlog
COMPILE.SVFLAGS = -sv
SRCDIR = ./source
WORKDIR = ./work

#Rules

%.vhd : $(SRCDIR)/%.vhd
	if [ ! -d $(WORKDIR) ]; then vlib $(WORKDIR); fi
	$(COMPILE.VHDL) $(COMPILE.VHDLFLAGS) $(SRCDIR)/$@

%.v : $(SRCDIR)/%.v
	if [ ! -d $(WORKDIR) ]; then vlib $(WORKDIR); fi
	$(COMPILE.V) $(COMPILE.VFLAGS) $(SRCDIR)/$@

%.sv : $(SRCDIR)/%.sv
	if [ ! -d $(WORKDIR) ]; then vlib $(WORKDIR); fi
	$(COMPILE.SV) $(COMPILE.SVFLAGS) $(SRCDIR)/$@

# begin HDL files (keep this)

# lab1
#registerFile_tb.vhd : registerFile.vhd
#regTest.vhd: registerFile.vhd

# lab2
#alu.vhd : shifter.vhd adder32.vhd
#tb_alu.vhd : alu.vhd
#aluTest.vhd : alu.vhd 7segDecoder.vhd

# lab4
#cpu_datapath.vhd : alu.vhd extender.vhd registerFile.vhd
#mycpu.vhd : rami.vhd ramd.vhd cpu_datapath.vhd cpu_controller.vhd
#cpu.vhd : mycpu.vhd
#tb_cpu.vhd : cpu.vhd
#cpuTest.vhd : tb_cpu.vhd bintohexDecoder.vhd

# lab 5,6,7,8,9,10,11,12,+



alu.vhd : adder32.vhd shifter.vhd
cpu_datapath.vhd : IFIDreg.vhd IDEXreg.vhd MEMWBreg.vhd EXMEMreg.vhd cpu_controller.vhd extender.vhd registerFile.vhd alu.vhd adder32.vhd hazard_controller.vhd forwarding_unit.vhd
cache.vhd : data16x55.vhd data16x64.vhd
dcache.vhd : dcache_ctrl.vhd cache.vhd
#also hitcounter.vhd
mycpu.vhd : arbiter.vhd cpu_datapath.vhd icache.vhd dcache.vhd
VarLatRAM.vhd : ram.vhd
cpu.vhd : mycpu.vhd VarLatRAM.vhd
tb_cpu.vhd : cpu.vhd
cpuTest.vhd : tb_cpu.vhd bintohexDecoder.vhd

# end HDL files (keep this)

# Lab Rules DO NOT CHANGE THESE
# OR YOU MAY FAIL THE GRADING SCRIPT
lab1: registerFile_tb.vhd
lab2: tb_alu.vhd
lab4: tb_cpu.vhd
lab5: tb_cpu.vhd
lab6: tb_cpu.vhd
lab7: tb_cpu.vhd
lab8: tb_cpu.vhd
lab9: tb_cpu.vhd
lab10: tb_cpu.vhd
lab11: tb_cpu.vhd
lab12: tb_cpu.vhd


# Time Saving Rules
clean:
	$(RM) -rf $(WORKDIR) *.log transcript \._* mapped/* *.hex \.leda* *.sdo

