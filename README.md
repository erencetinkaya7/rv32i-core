<div align="center">

# ⚙️ RV32I Single-Cycle Core

### A RISC-V processor built from scratch in SystemVerilog and running on a Tang Nano 9K FPGA.

![SystemVerilog](https://img.shields.io/badge/SystemVerilog-RTL-blue)
![RISC-V](https://img.shields.io/badge/RISC--V-RV32I-darkgreen)
![FPGA](https://img.shields.io/badge/FPGA-Tang%20Nano%209K-purple)
![Status](https://img.shields.io/badge/Status-FPGA%20Running-success)

**37 instructions · Automated verification · GNU RISC-V toolchain · FPGA implementation**

[Architecture](#-architecture) •
[Verification](#-verification) •
[FPGA](#-fpga-implementation) •
[Build](#️-build--run) •
[Roadmap](#️-roadmap)

</div>

---

## 🚀 Overview

This project is a **32-bit single-cycle RV32I processor** developed from scratch as a hands-on study of digital design, computer architecture and FPGA development.

It currently supports:

- ✅ 37 RV32I instructions
- ✅ Arithmetic, control-flow and byte/halfword/word memory operations
- ✅ Function calls, nested calls, stack usage and basic RISC-V ABI
- ✅ Automated regression and GNU RISC-V software flow
- ✅ Tang Nano 9K FPGA execution with automated build & flash
- ✅ RAM-based FPGA programs using loads, stores and function calls

---

## 🧠 Architecture

The processor follows a **32-bit single-cycle architecture** with separate instruction and data memories.

| RTL Module | Purpose |
|---|---|
| `program_counter.sv` | Program counter and PC update |
| `instruction_fields.sv` | Instruction field extraction |
| `immediate_generator.sv` | RISC-V immediate generation |
| `control_unit.sv` | Main instruction control |
| `alu_decoder.sv` | ALU operation decoding |
| `alu.sv` | Arithmetic, logic and shift operations |
| `branch_unit.sv` | Branch condition evaluation |
| `register_file.sv` | 32 × 32-bit register file |
| `instruction_memory.sv` | Instruction storage |
| `data_memory.sv` | 64 × 32-bit data memory with byte / halfword / word access |
| `rv32i_core.sv` | Top-level processor datapath and control |

---

## 🧩 Supported Instructions

**37 RV32I instructions** are currently implemented.

| Category | Instructions |
|---|---|
| **R-Type** | `ADD` `SUB` `AND` `OR` `XOR` `SLL` `SRL` `SRA` `SLT` `SLTU` |
| **I-Type** | `ADDI` `ANDI` `ORI` `XORI` `SLLI` `SRLI` `SRAI` `SLTI` `SLTIU` |
| **Loads** | `LB` `LBU` `LH` `LHU` `LW` |
| **Stores** | `SB` `SH` `SW` |
| **Branches** | `BEQ` `BNE` `BLT` `BGE` `BLTU` `BGEU` |
| **Upper Immediate** | `LUI` `AUIPC` |
| **Jumps** | `JAL` `JALR` |

---

## 🧪 Verification

The core is tested with automated SystemVerilog regressions and small RISC-V assembly programs.

```bash
./run_regression.sh
```

```text
ALL RV32I REGRESSIONS PASSED
```

<details>
<summary><b>What is covered?</b></summary>

Arithmetic, shifts, signed/unsigned comparisons, branches, jumps, byte/halfword/word memory operations, loops, arrays, function calls, stack usage and integrated programs.

</details>

---

## 🛠️ Software Flow

Assembly programs are built using the **GNU RISC-V bare-metal toolchain**:

`Assembly → Object → ELF → Binary → HEX → Instruction Memory`

Target:

```text
rv32i / ilp32
```

The generated HEX program is embedded into instruction memory during FPGA synthesis.

Example FPGA programs are kept under:

```text
fpga/rv32i/programs/
```

including a basic LED blink demo and a RAM / stack / function integration demo.

---

## ⚡ FPGA Implementation

The processor is running on a **Tang Nano 9K**.

- **FPGA:** Gowin GW1NR-9
- **Board clock:** 27 MHz
- **Timing:** ✅ PASS at 27 MHz
- **nextpnr Fmax estimate:** **42.02 MHz**
- **Synthesis:** `Yosys`
- **Place & Route:** `nextpnr`
- **Bitstream:** `gowin_pack`
- **Programming:** `openFPGALoader`

The current FPGA integration demo:

1. Stores an integer array in data memory
2. Calls a RISC-V function to sum only positive values
3. Uses the stack to preserve registers across nested function calls
4. Uses the calculated result as the number of onboard LED blinks

This verifies the complete path from **RISC-V assembly → GNU toolchain → instruction/data memory → CPU execution → physical FPGA output**.

---

## ▶️ Build & Run

From `fpga/rv32i`:

```bash
make          # Build
make flash    # Program the FPGA
make clean    # Remove generated files
```

<details>
<summary><b>What does make do?</b></summary>

`program.S → ELF → BIN → HEX → Yosys → nextpnr → Bitstream`

</details>

---

## 📁 Project Structure

```text
rtl/                    Processor RTL
tb/                     Verification and regression tests
sw/                     RISC-V assembly tests
fpga/bringup/           Initial FPGA bring-up
fpga/rv32i/             FPGA implementation and build flow
fpga/rv32i/programs/    FPGA assembly demos
```

---

## 🗺️ Roadmap

### ✅ Completed

- ✅ Single-cycle RV32I core
- ✅ 37 RV32I instructions
- ✅ Automated regression suite
- ✅ Assembly programs and basic ABI usage
- ✅ GNU RISC-V software flow
- ✅ Tang Nano 9K FPGA bring-up
- ✅ RV32I execution on FPGA
- ✅ Automated software-to-FPGA build flow
- ✅ RAM, stack and nested-function FPGA integration demo

### 🚧 Next

- ⬜ Memory-mapped GPIO
- ⬜ UART
- ⬜ Timer
- ⬜ Minimal RISC-V SoC
- ⬜ 5-stage pipelined RV32I core
- ⬜ Forwarding, stalls and hazard handling

### 🔬 Later

`CSR` · `Interrupts` · `Exceptions` · `Cache` · `Timing / PPA optimization`

---

<div align="center">

**SystemVerilog · RISC-V · FPGA · Digital Design**

</div>
