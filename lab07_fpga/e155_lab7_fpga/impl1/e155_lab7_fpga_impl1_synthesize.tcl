if {[catch {

# define run engine funtion
source [file join {C:/lscc/radiant/2026.1} scripts tcl flow run_engine.tcl]
# define global variables
global para
set para(gui_mode) "1"
set para(prj_dir) "C:/Users/jesli/Documents/GitHub/e155-lab7/lab07_fpga/e155_lab7_fpga"
if {![file exists {C:/Users/jesli/Documents/GitHub/e155-lab7/lab07_fpga/e155_lab7_fpga/impl1}]} {
  file mkdir {C:/Users/jesli/Documents/GitHub/e155-lab7/lab07_fpga/e155_lab7_fpga/impl1}
}
cd {C:/Users/jesli/Documents/GitHub/e155-lab7/lab07_fpga/e155_lab7_fpga/impl1}
# synthesize IPs
# synthesize VMs
# synthesize top design
file delete -force -- e155_lab7_fpga_impl1.vm e155_lab7_fpga_impl1.ldc
::radiant::runengine::run_engine_newmsg synthesis -f "C:/Users/jesli/Documents/GitHub/e155-lab7/lab07_fpga/e155_lab7_fpga/impl1/e155_lab7_fpga_impl1_lattice.synproj" -logfile "e155_lab7_fpga_impl1_lattice.srp"
::radiant::runengine::run_postsyn [list -a iCE40UP -p iCE40UP5K -t SG48 -sp High-Performance_1.2V -oc Industrial -top -w -o e155_lab7_fpga_impl1_syn.udb e155_lab7_fpga_impl1.vm] [list e155_lab7_fpga_impl1.ldc]

} out]} {
   ::radiant::runengine::runtime_log $out
   exit 1
}
