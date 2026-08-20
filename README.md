# RV32I Core

A single-cycle RV32I CPU core written in SystemVerilog.

This project is being developed step by step as a practical computer architecture and RTL design exercise. The goal is to build a clean RV32I processor, verify it in simulation, and eventually run it on FPGA hardware.

## ✅ Completed

- RV32I instruction field extraction
- 32 × 32-bit register file
- 32-bit ALU
- R-type and I-type ALU decoding
- I-type and S-type immediate generation
- Program counter
- Instruction memory
- Basic control unit
- Data memory
- R-type and I-type arithmetic execution
- `LW` / `SW` support
- ALU and memory writeback paths
- Unit tests for individual modules
- Integrated program execution in simulation

## 🚧 In Progress

- Branch instructions
- Jump instructions
- Remaining RV32I instruction formats
- Full RV32I single-cycle datapath
- Regression testing with larger programs

## 🎯 Planned

- Standard RISC-V toolchain integration
- Running compiled RISC-V programs
- Tang Nano 9K FPGA implementation
- Memory-mapped peripherals and SoC integration

## 🧪 Current Test Program

The current integrated core can execute programs such as:

```asm
addi x1, x0, 5
addi x2, x0, 7
add  x3, x1, x2
sw   x3, 8(x0)
lw   x4, 8(x0)
