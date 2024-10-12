# Generate bitstream

# get system args
set design_name [lindex $argv 0]
set top_module [lindex $argv 1]
set fpga_part [lindex $argv 2]
set hdl_type [lindex $argv 3]

# import utils
source [file normalize "scripts/utils.tcl"]

# read design sources
read_files "rtl" $hdl_type

# read simulation sources
read_files "tb" $hdl_type

# read constraints
read_files "constraints" "xdc"

# synthesis
synth_design -top $top_module -part $fpga_part

# place and route
opt_design
place_design
route_design

# write bitstream
set bitstream_out "build/$design_name.bit"
write_bitstream -force $bitstream_out

puts "Generated bitstream [file normalize "$bitstream_out"]"
