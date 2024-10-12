# common utilities

# read files based on type
proc read_files {dir file_type} {
    switch -exact $file_type {
        "v" {
            foreach file [glob "$dir/*.v"] {
                read_verilog $file
            }
        }
        "sv" {
            foreach file [glob "$dir/*.sv"] {
                read_verilog -sv $file
            }
        }
        "vhdl" {
            foreach file [glob "$dir/*.vhd"] {
                read_vhdl $file
            }
        }
        "xdc" {
            foreach file [glob "$dir/*.xdc"] {
                read_xdc $file
            }
        }
        default {
            puts "Unknown file type: $file_type"
            exit 1
        }
    }
}

# return HDL language name from file extension
proc lang_from_file_type {file_type} {
    switch -exact $file_type {
        "v" {
            return "Verilog"
        }
        "sv" {
            return "SystemVerilog"
        }
        "vhdl" {
            return "VHDL"
        }
        default {
            puts "Unknown file type: $file_type"
            exit 1
        }
    }
}
