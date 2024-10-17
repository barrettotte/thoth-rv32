# thoth-rv32

Single cycle RISC-V core supporting most of RV32I.

Implemented RV32I instructions minus `FENCE`, `ECALL`, `EBREAK`, and `CSRR`.

## Limitations

- I did not implement entire RV32I instruction set
- Memory is small and does not synthesize to BRAM of FPGA
- This is only partially tested since this was meant as a warmup project (and I'm lazy)
  - everyone seems to recommend testing with - https://github.com/riscv-software-src/riscv-tests
- I'm not sure if I'll convert this to a pipelined design or save it for another project

## Development

Requirements:
- Vivado 2024.1+ (installed in Windows, not WSL)
- WSL
- GTKWave (in WSL `apt-get install gtkwave -y`)
- Icarus Verilog (in WSL `apt-get install iverilog -y`)

Verify Vivado is installed on Windows and its binaries (`xilinx/Vivado/2024.1/bin`) 
are in system path with `vivado -version`.

### Workflow

```sh
# simulate module with Icarus Verilog
./task.ps1 iverilog top

# open waveform
./task.ps1 gtkwave top

# simulate specific module's testbench and generate waveform
./task.ps1 vivado-sim top

# build bitstream file
./task.ps1 vivado-build

# build and upload bitstream to FPGA
./task.ps1 vivado-upload
```

## References

- [Basys 3 Reference Manual](https://digilent.com/reference/programmable-logic/basys-3/reference-manual)
- [Vivado Design Suite Tcl Command Reference Guide](https://docs.amd.com/r/en-US/ug835-vivado-tcl-commands)
- https://projectf.io/posts/vivado-tcl-build-script/
- https://github.com/riscv/riscv-isa-manual/releases/tag/20240411
