# fpga-dev-vscode

Simple FPGA development workflow with VS Code.

The goal of this workflow is to avoid opening Vivado GUI.
The example in this repo is a simple DFF using Basys 3 Artix-7 board (XC7A35TCPG236-1).

## Development

Requirements:
- Vivado 2024.1+ (installed in Windows, not WSL)
- WSL
- GTKWave (in WSL `apt-get install gtkwave -y`)
- Icarus Verilog (in WSL `apt-get install iverilog -y`)

Verify Vivado is installed on Windows and its binaries (`xilinx/Vivado/2024.1/bin`) 
are in system path with `vivado -version`.

### Workflow

Project settings can be configured in `project.json`

```js
// example project.json
{
    "designName": "dff-test",           // design/project name
    "hdlType" : "v",                    // HDL type (v, sv, vhdl)
    "topModule": "top",                 // top module of design (used as default target module if none specified in task.ps1)
    "fpgaPart": "xc7a35tcpg236-1",      // FPGA part #
}
```

```sh
# build bitstream file
./task.ps1 vivado-build

# simulate specific module's testbench and generate waveform
./task.ps1 vivado-sim top

# open waveform
./task.ps1 gtkwave top

# open waveform in gtkwave via WSL
wsl -e gtkwave build/top_tb.vcd

# build and upload bitstream to FPGA
./task.ps1 vivado-upload
```

Optionally, you can still develop in project mode with the following:

```sh
# create Vivado project
./task.ps1 vivado-new

# open Vivado project in GUI
./task.ps1 vivado-gui
```

### Icarus Verilog

To speed up development with Verilog, Icarus Verilog can be used in WSL.

```sh
# install dependencies
apt-get install iverilog -y

# build, simulate, and open waveform for module
./task.ps1 iverilog top
```

## To Do

Things I hope to add over time.

- support for verilator
- support for vhdl
- support for specifiying optional `.gtkw` files for `gtkwave` task
- make directory paths configurable in `task.ps1` and TCL scripts
- look into adding build caching for Vivado builds?
- option to use Docker for all WSL commands?
- support for IP cores
- support for Vitis

## References

- [Basys 3 Reference Manual](https://digilent.com/reference/programmable-logic/basys-3/reference-manual)
- [Vivado Design Suite Tcl Command Reference Guide](https://docs.amd.com/r/en-US/ug835-vivado-tcl-commands)
- https://projectf.io/posts/vivado-tcl-build-script/
