# ⚙️ RV32I Core

A small **single-cycle RV32I CPU core** written in SystemVerilog.

Built as a hands-on project to learn how a RISC-V processor actually works.

## ✅ Done

- Instruction decode
- Register file
- 32-bit ALU
- Immediate generation (`I / S / B / U / J`)
- Program counter
- Instruction and data memory
- R-type / I-type instructions
- `LW` / `SW`
- Conditional branches
- `LUI` / `AUIPC`
- `JAL` / `JALR`

## 🚧 Working On

- Byte and halfword memory operations
- Full RV32I regression tests
- RISC-V toolchain integration

## 🧪 Example

```asm
addi  x1, x0, 5
addi  x2, x0, 5
beq   x1, x2, target
addi  x3, x0, 99

target:
lui   x4, 0x12345
auipc x5, 0x1
jal   x6, next
addi  x7, x0, 77

next:
addi  x8, x0, 48
jalr  x9, x8, 0
```

The core currently supports arithmetic, memory access and control-flow execution in simulation.

## 🛠️ Tools

`SystemVerilog` · `Icarus Verilog` · `GTKWave`
