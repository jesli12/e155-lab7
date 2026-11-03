-L work
-reflib pmi_work
-reflib ovi_ice40up


"C:/Users/jesli/Documents/GitHub/e155-lab7/lab07_fpga/src/aes_core_tb.sv" 
"C:/Users/jesli/Documents/GitHub/e155-lab7/lab07_fpga/e155_lab7_fpga/source/impl1/subbytes.sv" 
"C:/Users/jesli/Documents/GitHub/e155-lab7/lab07_fpga/e155_lab7_fpga/source/impl1/input_to_state.sv" 
"C:/Users/jesli/Documents/GitHub/e155-lab7/lab07_fpga/e155_lab7_fpga/source/impl1/state_to_output.sv" 
"C:/Users/jesli/Documents/GitHub/e155-lab7/lab07_fpga/e155_lab7_fpga/source/impl1/shiftrows.sv" 
"C:/Users/jesli/Documents/GitHub/e155-lab7/lab07_fpga/e155_lab7_fpga/source/impl1/addroundkey.sv" 
"C:/Users/jesli/Documents/GitHub/e155-lab7/lab07_fpga/e155_lab7_fpga/source/impl1/keyexpansion.sv" 
"C:/Users/jesli/Documents/GitHub/e155-lab7/lab07_fpga/e155_lab7_fpga/source/impl1/aes.sv" 
"C:/Users/jesli/Documents/GitHub/e155-lab7/lab07_fpga/e155_lab7_fpga/source/impl1/aes_core.sv" 
"C:/Users/jesli/Documents/GitHub/e155-lab7/lab07_fpga/e155_lab7_fpga/source/impl1/aes_spi.sv" 
"C:/Users/jesli/Documents/GitHub/e155-lab7/lab07_fpga/e155_lab7_fpga/source/impl1/mixcolumns.sv" 
"C:/Users/jesli/Documents/GitHub/e155-lab7/lab07_fpga/e155_lab7_fpga/source/impl1/sbox.sv" 
"C:/Users/jesli/Documents/GitHub/e155-lab7/lab07_fpga/e155_lab7_fpga/source/impl1/sbox_sync.sv" 
-sv
-optionset VOPTDEBUG
+noacc+pmi_work.*
+noacc+ovi_ice40up.*

-vopt.options
  -suppress vopt-7033
-end

-gui
-top testbench_aes_core
-vsim.options
  -suppress vsim-7033,vsim-8630,3009,3389
-end

-do "view wave"
-do "add wave /*"
-do "run -all"
