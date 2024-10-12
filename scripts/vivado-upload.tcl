# program board using bitstream created during build script

set bitstream_file [lindex $argv 0]
set bitstream_norm [file normalize "$bitstream_file"]

# connect to FPGA
open_hw_manager
connect_hw_server
current_hw_target
open_hw_target

# program FPGA
set_property PROGRAM.FILE $bitstream_norm [current_hw_device]
program_hw_devices [current_hw_device]
puts "Programmed FPGA with bitstream $bitstream_norm"
