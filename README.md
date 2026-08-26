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
| **R-type arithmetic / logic** | `ADD` `SUB` `AND` `OR` `XOR` `SLL` `SRL` `SRA` `SLT` `SLTU` |
| **I-type arithmetic / logic** | `ADDI` `ANDI` `ORI` `XORI` `SLLI` `SRLI` `SRAI` `SLTI` `SLTIU` |
| **Loads**                     | `LB` `LBU` `LH` `LHU` `LW` |
| **Stores**                    | `SB` `SH` `SW` |
| **Branches**                  | `BEQ` `BNE` `BLT` `BGE` `BLTU` `BGEU` |
| **Upper immediate**           | `LUI` `AUIPC` |
| **Jumps**                     | `JAL` `JALR` |

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
