<div align="center">

# ⚙️ RV32I Single-Cycle Core

### A RISC-V processor and minimal SoC built from scratch in SystemVerilog and running on a Tang Nano 9K FPGA.

![SystemVerilog](https://img.shields.io/badge/SystemVerilog-RTL-blue)
![RISC-V](https://img.shields.io/badge/RISC--V-RV32I-darkgreen)
![FPGA](https://img.shields.io/badge/FPGA-Tang%20Nano%209K-purple)
![Status](https://img.shields.io/badge/Status-FPGA%20Running-success)

**37 instructions · Automated verification · GNU RISC-V toolchain · Memory-mapped GPIO · FPGA implementation**

[Architecture](#-architecture) •
[Verification](#-verification) •
[FPGA](#-fpga-implementation) •
[Build](#️-build--run) •
[Roadmap](#️-roadmap)

</div>

---

## 🚀 Overview

This project is a **32-bit single-cycle RV32I processor and minimal SoC** developed from scratch as a hands-on study of digital design, computer architecture and FPGA development.

It currently supports:

- ✅ 37 RV32I instructions
- ✅ Arithmetic, control-flow and byte/halfword/word memory operations
- ✅ Function calls, nested calls, stack usage and basic RISC-V ABI
- ✅ Automated regression and GNU RISC-V software flow
- ✅ Tang Nano 9K FPGA execution with automated build & flash
- ✅ SoC-level address decoding and memory-mapped GPIO
- ✅ 6 onboard LED outputs and onboard button input

---

## 🧠 Architecture

The processor follows a **32-bit single-cycle architecture** with separate instruction and data paths.

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
| `gpio.sv` | Memory-mapped GPIO peripheral |
| `rv32i_core.sv` | RV32I processor datapath and control |
| `rv32i_soc.sv` | SoC integration, address decoding and peripheral interconnect |

The CPU core exposes a simple external data interface, allowing RAM and peripherals to be connected at the SoC level.

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

The core and SoC are tested with automated SystemVerilog regressions and RISC-V assembly programs.

```bash
./run_regression.sh
```

```text
ALL RV32I REGRESSIONS PASSED
```

<details>
<summary><b>What is covered?</b></summary>

Arithmetic, shifts, signed/unsigned comparisons, branches, jumps, byte/halfword/word memory operations, loops, arrays, function calls, stack usage, toolchain integration and integrated programs.

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

Example FPGA programs are stored under:

```text
fpga/rv32i/programs/
```

Current demos include:

- Basic MMIO LED blink
- RAM / stack / function integration
- 6-LED GPIO chaser
- Button-controlled LED chaser

---

## ⚡ FPGA Implementation

The processor and SoC are running on a **Tang Nano 9K**.

- **FPGA:** Gowin GW1NR-9
- **Board clock:** 27 MHz
- **Timing:** ✅ PASS at 27 MHz
- **Typical nextpnr Fmax estimate:** ~40 MHz
- **Synthesis:** `Yosys`
- **Place & Route:** `nextpnr`
- **Bitstream:** `gowin_pack`
- **Programming:** `openFPGALoader`

Memory-mapped GPIO currently uses:

- `0x1000_0000` — GPIO output
- `0x1000_0004` — GPIO input

The current FPGA demo drives all six onboard LEDs while reading the onboard button through MMIO. Each button press changes the direction of the moving LED pattern.

The demo verifies bidirectional MMIO between RISC-V software and physical FPGA I/O.

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

The generated bitstream is programmed to the FPGA through JTAG using `openFPGALoader`.

</details>

---

## 📁 Project Structure

```text
rtl/                    Processor, memory and peripheral RTL
tb/                     SystemVerilog verification and regression tests
sw/                     RISC-V assembly tests
fpga/bringup/           Initial FPGA bring-up
fpga/rv32i/             RV32I SoC FPGA implementation and build flow
fpga/rv32i/programs/    FPGA assembly demos
```

Generated simulation, toolchain and FPGA build artifacts are excluded through `.gitignore`.

---

## 🗺️ Roadmap

### ✅ Completed

- ✅ Single-cycle RV32I core with 37 instructions
- ✅ Automated SystemVerilog regression suite
- ✅ GNU RISC-V assembly and software flow
- ✅ Function calls, stack and basic ABI support
- ✅ Tang Nano 9K FPGA implementation
- ✅ Minimal SoC with memory-mapped GPIO
- ✅ 6-LED and onboard button FPGA demo

### 🚧 Next

- ⬜ Memory-mapped UART
- ⬜ Hardware timer
- ⬜ Expanded minimal RISC-V SoC
- ⬜ 5-stage pipelined RV32I core
- ⬜ Forwarding, stalls and hazard handling

### 🔬 Later

`CSR` · `Interrupts` · `Exceptions` · `Cache` · `Timing / PPA optimization`

---

<div align="center">

**SystemVerilog · RISC-V · FPGA · Digital Design**

</div>
