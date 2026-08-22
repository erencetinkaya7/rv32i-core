# RV32I Single-Cycle Core

> A simple single-cycle RV32I processor implemented from scratch in SystemVerilog.

This project focuses on understanding the relationship between the **RISC-V ISA**, processor **datapath**, **control logic**, memory system, and their RTL implementation.

---

## Overview

|                        |                                       |
| ---------------------- | ------------------------------------- |
| **ISA**                | RV32I                                 |
| **Architecture**       | Single-cycle                          |
| **RTL**                | SystemVerilog                         |
| **Datapath width**     | 32-bit                                |
| **Register file**      | 32 × 32-bit                           |
| **Instruction memory** | Separate                              |
| **Data memory**        | Separate                              |
| **Verification**       | Unit + regression + integration tests |
| **Software flow**      | GNU RISC-V bare-metal toolchain       |

---

## Architecture

```text
                     ┌──────────────────┐
                     │ Program Counter  │
                     └────────┬─────────┘
                              │
                              ▼
                   ┌────────────────────┐
                   │ Instruction Memory │
                   └─────────┬──────────┘
                             │
                 ┌───────────┴───────────┐
                 │                       │
                 ▼                       ▼
        ┌─────────────────┐      ┌──────────────┐
        │ Register File   │      │ Control Unit │
        └────────┬────────┘      └──────┬───────┘
                 │                      │
                 ▼                      │
        ┌─────────────────┐             │
        │ Immediate Gen.  │             │
        └────────┬────────┘             │
                 │                      │
                 └──────────┬───────────┘
                            ▼
                     ┌─────────────┐
                     │     ALU     │
                     └──────┬──────┘
                            │
               ┌────────────┴────────────┐
               │                         │
               ▼                         ▼
        ┌─────────────┐           ┌─────────────┐
        │ Data Memory │           │ Branch / PC │
        └──────┬──────┘           │    Logic    │
               │                  └─────────────┘
               ▼
        ┌─────────────┐
        │ Write Back  │
        └─────────────┘
```

The design uses a **single-cycle datapath**, meaning each instruction completes within one clock cycle.

---

## Supported Instructions

### Arithmetic & Logic

| R-Type | I-Type  |
| ------ | ------- |
| `ADD`  | `ADDI`  |
| `SUB`  | `ANDI`  |
| `AND`  | `ORI`   |
| `OR`   | `XORI`  |
| `XOR`  | `SLLI`  |
| `SLL`  | `SRLI`  |
| `SRL`  | `SRAI`  |
| `SRA`  | `SLTI`  |
| `SLT`  | `SLTIU` |
| `SLTU` |         |

### Memory

| Loads | Stores |
| ----- | ------ |
| `LB`  | `SB`   |
| `LBU` | `SH`   |
| `LH`  | `SW`   |
| `LHU` |        |
| `LW`  |        |

### Control Flow

| Branches | Jumps  |
| -------- | ------ |
| `BEQ`    | `JAL`  |
| `BNE`    | `JALR` |
| `BLT`    |        |
| `BGE`    |        |
| `BLTU`   |        |
| `BGEU`   |        |

### Upper Immediate

* `LUI`
* `AUIPC`

**37 RV32I instructions are currently implemented.**

---

## Datapath Features

```text
ALU operations
├── Arithmetic
│   ├── ADD / SUB
│   ├── SLT
│   └── SLTU
│
├── Logical
│   ├── AND
│   ├── OR
│   └── XOR
│
└── Shifts
    ├── SLL
    ├── SRL
    └── SRA
```

Memory accesses support:

```text
8-bit   → LB / LBU / SB
16-bit  → LH / LHU / SH
32-bit  → LW / SW
```

Including:

* signed and unsigned loads
* sign extension
* zero extension
* byte-lane selection
* halfword selection

---

## Project Structure

```text
rv32i-core/
│
├── rtl/
│   ├── alu.sv
│   ├── alu_decoder.sv
│   ├── branch_unit.sv
│   ├── control_unit.sv
│   ├── data_memory.sv
│   ├── immediate_generator.sv
│   ├── instruction_fields.sv
│   ├── instruction_memory.sv
│   ├── program_counter.sv
│   ├── register_file.sv
│   └── rv32i_core.sv
│
├── tb/
│   ├── arithmetic_regression_tb.sv
│   ├── load_store_regression_tb.sv
│   ├── control_flow_regression_tb.sv
│   ├── integrated_program_tb.sv
│   ├── toolchain_program_tb.sv
│   └── toolchain_integrated_tb.sv
│
├── sw/
│   ├── program.S
│   └── integrated_program.S
│
├── run_regression.sh
├── .gitignore
└── README.md
```

---

## Verification

The core is tested at multiple levels.

### ISA Regression

```text
Arithmetic / Logic     ✓
Loads / Stores         ✓
Branches               ✓
LUI / AUIPC            ✓
JAL / JALR             ✓
```

Tests include corner cases such as:

* signed vs. unsigned comparison
* `SRL` vs. `SRA`
* negative immediates
* shift amounts
* sign and zero extension
* byte and halfword accesses
* taken and not-taken branches
* JAL/JALR link addresses
* JALR target alignment

### Integrated Program

A larger program verifies several subsystems together:

```text
Loop
 │
 ▼
1 + 2 + 3 + 4 + 5
 │
 ▼
Memory Store / Load
 │
 ▼
Function Call (JAL)
 │
 ▼
2x + 3
 │
 ▼
Function Return (JALR)
 │
 ▼
Memory Store / Load
```

Expected result:

```text
sum = 15
f(15) = 33
```

---

## RISC-V Toolchain

The project can execute programs generated by the standard GNU RISC-V bare-metal toolchain.

```text
program.S
    │
    ▼
GNU RISC-V Assembler / Linker
    │
    ▼
program.elf
    │
    ▼
Raw Binary
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

The toolchain targets:

```text
-march=rv32i
-mabi=ilp32
```

---

## Running the Regression Suite

Run all software builds and regression tests with:

```bash
./run_regression.sh
```

The expected final result is:

```text
======================================
 ALL RV32I REGRESSIONS PASSED
======================================
```

---

## Current Limitations

The first version intentionally does **not** implement:

| Feature                    | Status          |
| -------------------------- | --------------- |
| `FENCE`                    | Not implemented |
| `ECALL` / `EBREAK`         | Not implemented |
| Exceptions / traps         | Not implemented |
| Interrupts                 | Not implemented |
| Misaligned access handling | Not implemented |
| Pipeline                   | Not implemented |
| Cache                      | Not implemented |

These features are outside the scope of the initial single-cycle implementation.

---

## Status

```text
RV32I Core
████████████████████  v1
```

**Functional single-cycle RV32I processor complete.**

Next step:

> **Tang Nano 9K FPGA implementation and peripheral integration**
