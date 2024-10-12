<#
.SYNOPSIS
Automate tasks for simple FPGA projects. Supports Vivado automation via TCL scripts and Icarus Verilog simulation.
This script relies on project.json file in the same directory.

.DESCRIPTION
USAGE
    .\task.ps1 <command> [target-module]

COMMANDS
    vivado-build     builds HDL in Vivado (batch mode)
    vivado-upload    uploads generated bitstream file to board
    vivado-new       creates new project in Vivado (batch mode)
    vivado-gui       opens Vivado project in GUI
    gtkwave          opens generated waveform (.vcd) file for target module
    iverilog         simulates target module using Icarus Verilog in WSL
    verilator        simulate target module using Verilator in WSL
    ghdl             simulate target module using ghdl in WSL
    clean            cleans all temp/build files
    help, -?         show this help message
#>
param ([Parameter(Position=0)] [string] $task, [Parameter(Position=1)] [string] $target_module)
$ErrorActionPreference = 'Stop'

function Invoke-CmdAndEcho {
    param ([string] $cmd)
    Write-Host "Running command: $cmd"; Invoke-Expression $cmd
}

function Invoke-CleanTask {
    param ([string] $build_dir, [string] $project_dir)
    Remove-Item -Path (Join-Path $build_dir '*') -Recurse -Force -ErrorAction SilentlyContinue
    Remove-Item -Path (Join-Path $project_dir '*') -Recurse -Force -ErrorAction SilentlyContinue
}

function Invoke-VivadoTask {
    param ([string] $task, [string] $build_dir, [string] $tcl_args)
    $vivado = Get-Command vivado | Select-Object -ExpandProperty Source
    $vivado_bin = Split-Path $vivado -Parent
    $vivado_root = Split-Path $vivado_bin -Parent
    $vivado_settings = Join-Path $vivado_root 'settings64.bat'

    New-Item -ItemType Directory -Force -Path "$build_dir/logs" | Out-Null
    New-Item -ItemType Directory -Force -Path "$build_dir/sim" | Out-Null

    # load settings into shell instance and launch vivado in batch mode to run TCL script
    & $vivado_settings
    Invoke-CmdAndEcho "vivado -mode batch -nojournal -log logs/$task.log -source scripts/$task.tcl -tclargs $tcl_args"
}

function Invoke-IverilogTask {
    param ([string] $target_module, [string] $hdl_type, [string] $build_dir, [string] $src_dir, [string] $test_dir)
    $tb_module = "${target_module}_tb"
    $vvp_file = "$build_dir/$tb_module.vvp"
    Invoke-CmdAndEcho "wsl -e iverilog `"$test_dir/$tb_module.$hdl_type`" -I `"$src_dir`" -I `"$test_dir`" -o `"$vvp_file`""
    Invoke-CmdAndEcho "wsl -e vvp `"$vvp_file`""
    Move-Item -Path "$tb_module.vcd" -Destination "$build_dir" -Force
}

function Invoke-Task {
    param ([string] $task, [string] $target_module)
    $config = (Get-Content 'project.json' -Raw) | ConvertFrom-Json
    $design_name = $config.designName
    $hdl_type = $config.hdlType
    $top_module = $config.topModule
    $fpga_part = $config.fpgaPart
    $target_module = if (!$target_module) {$top_module} else {$target_module}

    $src_dir = 'rtl'
    $test_dir = 'tb'
    $build_dir = 'build'
    $project_dir = 'project'
    New-Item -ItemType Directory -Force -Path $build_dir | Out-Null
    New-Item -ItemType Directory -Force -Path $project_dir | Out-Null

    if (-not (@('v', 'sv', 'vhdl') -contains $hdl_type)) {
        Write-Host "Error: hdlType must be 'v', 'sv', or 'vhdl'."; exit 1
    }
    switch ($task) {
        'help'          {Get-Help $PSCommandPath}
        'clean'         {Invoke-CleanTask $build_dir $project_dir}
        'vivado-build'  {Invoke-VivadoTask $task $build_dir ($design_name, $top_module, $fpga_part, $hdl_type)}
        'vivado-upload' {Invoke-VivadoTask $task $build_dir ("$build_dir/$design_name.bit")}
        'vivado-new'    {Invoke-VivadoTask $task $build_dir ($design_name, $top_module, $fpga_part, $hdl_type)}
        'vivado-sim'    {Invoke-VivadoTask $task $build_dir ($design_name, $target_module, $fpga_part, $hdl_type)}
        'vivado-gui'    {Invoke-VivadoTask $task $build_dir ($design_name)}
        'gtkwave'       {Invoke-CmdAndEcho "wsl -e gtkwave `"$build_dir/${target_module}_tb.vcd`""}
        'iverilog'      {Invoke-IverilogTask $target_module $hdl_type $build_dir $src_dir $test_dir}
        'verilator'     {Write-Host "Error: Simulating with verilator not supported yet."; exit 1}
        'ghdl'          {Write-Host "Error: Simulating with ghdl not supported yet."; exit 1}
        default         {Write-Host "Error: Unknown task '$task'"; exit 1}
    }
}
Invoke-Task $task $target_module
