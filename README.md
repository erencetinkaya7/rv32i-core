<div align="center">

# ⚙️ RV32I Single-Cycle Core

### A RISC-V processor and minimal SoC built from scratch in SystemVerilog and running on a Tang Nano 9K FPGA.

![SystemVerilog](https://img.shields.io/badge/SystemVerilog-RTL-blue)
![RISC-V](https://img.shields.io/badge/RISC--V-RV32I-darkgreen)
![FPGA](https://img.shields.io/badge/FPGA-Tang%20Nano%209K-purple)
![Status](https://img.shields.io/badge/Status-FPGA%20Running-success)

**37 instructions · Automated verification · GNU RISC-V toolchain · GPIO · UART TX · Hardware timer · FPGA implementation**

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
- ✅ SoC-level address decoding and memory-mapped peripherals
- ✅ GPIO input/output, UART TX and hardware timer
- ✅ Integrated 6-LED, button and UART FPGA demo

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
| `uart_tx.sv` | 8N1 UART transmitter |
| `uart.sv` | Memory-mapped UART peripheral |
| `timer.sv` | Memory-mapped hardware countdown timer |
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
- Button-controlled 6-LED chaser
- UART TX and `putc` demo
- Hardware-timer LED chaser
- Integrated GPIO + UART + timer SoC demo

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

### Memory Map

| Address | Peripheral |
|---|---|
| `0x1000_0000` | GPIO output |
| `0x1000_0004` | GPIO input |
| `0x2000_0000` | UART TX data |
| `0x2000_0004` | UART status |
| `0x3000_0000` | Timer load / start |
| `0x3000_0004` | Timer status |

The current FPGA demo combines GPIO, UART TX and the hardware timer in a single RISC-V program. It drives a bidirectional 6-LED chaser, changes direction using an onboard button, reports events over UART and supports physical system reset.

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
rtl/
├── core/               RV32I datapath and control
├── memory/             Instruction and data memories
├── peripherals/        GPIO, UART and hardware timer
└── soc/                SoC integration and address decoding

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
- ✅ Minimal SoC with GPIO, UART TX and hardware timer
- ✅ Integrated physical FPGA demo

### 🚧 Next

- ⬜ 5-stage pipelined RV32I core
- ⬜ Forwarding, stalls and hazard handling

### 🔬 Later

`UART RX` · `CSR` · `Interrupts` · `Exceptions` · `Cache` · `Timing / PPA optimization`

---

<div align="center">

**SystemVerilog · RISC-V · FPGA · Digital Design**

</div>
