# ⚙️ RV32I Core

A small **single-cycle RV32I CPU core** written in SystemVerilog.

Built as a hands-on project to learn how a RISC-V processor actually works.

## ✅ Done

- Instruction decode
- Register file
- 32-bit ALU
- Immediate generation
- Program counter
- Instruction memory
- Data memory
- R-type / I-type instructions
- `LW` / `SW`

## 🚧 Working On

- Branches
- Jumps
- Completing the single-cycle datapath

## 🧪 Example

```asm
addi x1, x0, 5
addi x2, x0, 7
add  x3, x1, x2
sw   x3, 8(x0)
lw   x4, 8(x0)
```

```text
x1 = 5
x2 = 7
x3 = 12
x4 = 12
```

## 🛠️ Tools

`SystemVerilog` · `Icarus Verilog` · `GTKWave`
