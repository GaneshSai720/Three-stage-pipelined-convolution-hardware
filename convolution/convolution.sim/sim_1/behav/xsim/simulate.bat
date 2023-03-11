@echo off
REM ****************************************************************************
REM Vivado (TM) v2019.2 (64-bit)
REM
REM Filename    : simulate.bat
REM Simulator   : Xilinx Vivado Simulator
REM Description : Script for simulating the design by launching the simulator
REM
REM Generated by Vivado on Mon Feb 20 12:56:25 +0530 2023
REM SW Build 2708876 on Wed Nov  6 21:40:23 MST 2019
REM
REM Copyright 1986-2019 Xilinx, Inc. All Rights Reserved.
REM
REM usage: simulate.bat
REM
REM ****************************************************************************
echo "xsim top_module_tb_behav -key {Behavioral:sim_1:Functional:top_module_tb} -tclbatch top_module_tb.tcl -view C:/Users/Lenovo/Desktop/Verilog_files/convolution/Simulation_files/top_module_tb_behav.wcfg -log simulate.log"
call xsim  top_module_tb_behav -key {Behavioral:sim_1:Functional:top_module_tb} -tclbatch top_module_tb.tcl -view C:/Users/Lenovo/Desktop/Verilog_files/convolution/Simulation_files/top_module_tb_behav.wcfg -log simulate.log
if "%errorlevel%"=="0" goto SUCCESS
if "%errorlevel%"=="1" goto END
:END
exit 1
:SUCCESS
exit 0
