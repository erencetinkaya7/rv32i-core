# RV32I Single-Cycle Core

<p align="center">
  <img src="https://img.shields.io/badge/RISC--V-RV32I-283272?style=flat-square" alt="RISC-V RV32I">
  <img src="https://img.shields.io/badge/SystemVerilog-RTL-6B4FBB?style=flat-square" alt="SystemVerilog">
  <img src="https://img.shields.io/badge/Status-v1%20Complete-2EA44F?style=flat-square" alt="Status">
</p>

A single-cycle RISC-V processor written in **SystemVerilog** as a learning project.

I built this core from scratch to better understand how RISC-V instructions translate into a processor **datapath**, **control logic**, **memory operations**, and RTL.

The current version implements the main RV32I instruction families, includes automated regression tests, and can execute assembly programs generated with the **GNU RISC-V toolchain**.

---

## ⚙️ Overview

|                        |                                      |
| ---------------------- | ------------------------------------ |
| **ISA**                | RV32I                                |
| **Architecture**       | Single-cycle                         |
| **RTL**                | SystemVerilog                        |
| **Datapath width**     | 32-bit                               |
| **Registers**          | 32 × 32-bit                          |
| **Memory model**       | Separate instruction and data memory |
| **Simulation**         | Icarus Verilog                       |
| **Software toolchain** | GNU RISC-V bare-metal toolchain      |

> Each instruction completes in a **single clock cycle**.

The design is split into separate RTL modules for the main datapath and control components:

* Program counter
* Register file
* Immediate generator
* Control unit
* ALU decoder
* ALU
* Branch unit
* Instruction memory
* Data memory
* Top-level core

---

## 📚 Supported Instructions

The core currently implements **37 instructions**.

| Category                      | Instructions                                                   |
| ----------------------------- | -------------------------------------------------------------- |
| **R-type arithmetic / logic** | `ADD` `SUB` `AND` `OR` `XOR` `SLL` `SRL` `SRA` `SLT` `SLTU`    |
| **I-type arithmetic / logic** | `ADDI` `ANDI` `ORI` `XORI` `SLLI` `SRLI` `SRAI` `SLTI` `SLTIU` |
| **Loads**                     | `LB` `LBU` `LH` `LHU` `LW`                                     |
| **Stores**                    | `SB` `SH` `SW`                                                 |
| **Branches**                  | `BEQ` `BNE` `BLT` `BGE` `BLTU` `BGEU`                          |
| **Upper immediate**           | `LUI` `AUIPC`                                                  |
| **Jumps**                     | `JAL` `JALR`                                                   |

Byte and halfword memory accesses include the required **sign/zero extension** and **byte-lane selection** behavior.

---

## 📁 Project Structure

```text
rv32i-core/
├── rtl/                  # Processor RTL
├── tb/                   # Unit, regression and integration tests
├── sw/                   # RISC-V assembly programs
├── run_regression.sh
├── .gitignore
└── README.md
```

---

## ✅ Verification

The core was tested incrementally while developing each part of the datapath.

The final regression suite covers:

* R-type and I-type arithmetic
* Signed and unsigned comparisons
* Logical and arithmetic shifts
* Negative immediates
* Byte, halfword and word memory accesses
* Sign and zero extension
* All six conditional branch instructions
* Taken and not-taken branches
* `LUI` and `AUIPC`
* `JAL` and `JALR`
* JAL/JALR link addresses
* JALR target alignment
* Integrated loop, memory and function-call behavior

### Integration test

A small integration program calculates:

```text
1 + 2 + 3 + 4 + 5 = 15
```

and then calls a function implementing:

```text
f(x) = 2x + 3
```

producing:

```text
f(15) = 33
```

The program uses loops, branches, loads/stores, `JAL` for the function call and `JALR` for the return.

### Run all regressions

```bash
./run_regression.sh
```

Expected final output:

```text
ALL RV32I REGRESSIONS PASSED
```

---

## 🛠️ RISC-V Toolchain

The project also includes a basic software flow using the **GNU RISC-V bare-metal toolchain**.

```text
Assembly (.S)
      │
      ▼
RISC-V assembler / linker
      │
      ▼
ELF
      │
      ▼
Binary
      │
      ▼
HEX
      │
      ▼
Instruction Memory
      │
      ▼
RV32I Core
```

Programs are built for:

```text
-march=rv32i
-mabi=ilp32
```

The generated machine code is loaded directly into the simulated instruction memory and executed by the core.

---

## 🚧 Current Limitations

This is the first single-cycle version of the processor.

The following features are not currently implemented:

* `FENCE`
* `ECALL` / `EBREAK`
* Exceptions and traps
* Interrupts
* Misaligned access handling
* Pipeline
* Cache

These were intentionally left outside the scope of the initial implementation.

---

## 🚀 Status

**Single-cycle core v1 complete.**

The next step is to bring the design onto a **Tang Nano 9K FPGA** and start adding basic peripheral / SoC integration.

