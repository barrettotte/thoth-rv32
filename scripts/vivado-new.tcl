# Create Vivado project

# get system args
set project_name [lindex $argv 0]
set top_module [lindex $argv 1]
set fpga_part [lindex $argv 2]
set hdl_type [lindex $argv 3]

# fixes problem with "remote" files in project
set origin_dir "[file normalize "."]"
set project_dir "$origin_dir/project"

# add source files to filesets
proc add_fileset {fileset fileset_type dir file_type} {

    # create fileset if not exists
    if {[string equal [get_filesets -quiet $fileset] ""]} {
        create_fileset $fileset_type $fileset
    }

    # add each file to fileset
    foreach file [glob "$dir/*.$file_type"] {
        add_files -fileset $fileset $file
    }
}

# create project
create_project $project_name $project_dir -part $fpga_part -force

# add source files
add_fileset "sources_1" "-srcset" "$origin_dir/rtl" $hdl_type
set_property top $top_module [get_filesets sources_1]

# prevent source files being duplicated in simulation set
set design_top_obj [get_files -of_objects [get_filesets sources_1]]
set_property -name "used_in_simulation" -value "0" -objects $design_top_obj

# add simulation files
add_fileset "sim_1" "-simset" "$origin_dir/tb" $hdl_type

# add constraint files
add_fileset "constrs_1" "-constrset" "$origin_dir/constraints" "xdc"
set constr_file_obj [get_files -of_objects [get_filesets constrs_1]]
set_property -name "file_type" -value "XDC" -objects $constr_file_obj

# finish file setup
file mkdir "$project_dir/$project_name.gen/sources_1"

# configure project
update_compile_order -fileset sources_1
update_compile_order -fileset sim_1

# save project
write_project_tcl -force "$project_dir/$project_name.tcl"
close_project

puts "Created project $project_name in $project_dir"
