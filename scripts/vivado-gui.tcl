# Open Vivado project in GUI

set project_name [lindex $argv 0]
set project_file [file normalize "project/$project_name.xpr"]

open_project $project_file
puts "Opening project $project_file in Vivado GUI"
start_gui
