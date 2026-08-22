# RV32I Single-Cycle Core

![SystemVerilog](https://img.shields.io/badge/SystemVerilog-RTL-blue)
![RISC--V](https://img.shields.io/badge/RISC--V-RV32I-orange)
![Status](https://img.shields.io/badge/status-v1%20complete-brightgreen)

A **single-cycle RV32I processor** implemented from scratch in SystemVerilog.

The project focuses on understanding how the **RISC-V ISA**, processor **datapath**, **control logic**, memory system, and RTL implementation fit together.

---

## ⚙️ Overview

|                   |                                      |
| ----------------- | ------------------------------------ |
| **ISA**           | RV32I                                |
| **Architecture**  | Single-cycle                         |
| **RTL**           | SystemVerilog                        |
| **Datapath**      | 32-bit                               |
| **Register File** | 32 × 32-bit                          |
| **Memory**        | Separate instruction & data memories |
| **Verification**  | Unit + regression + integration      |
| **Toolchain**     | GNU RISC-V bare-metal                |

---

## 🧩 Architecture

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
        │  Register File  │      │ Control Unit │
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

Each instruction completes in a **single clock cycle**.

---

## 📚 Supported Instructions

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

`LUI` · `AUIPC`

> **37 RV32I instructions implemented**

---

## 💾 Memory Support

```text
8-bit   → LB / LBU / SB
16-bit  → LH / LHU / SH
32-bit  → LW / SW
```

Includes:

* Sign extension
* Zero extension
* Byte-lane selection
* Halfword selection
* Signed and unsigned loads

---

## 📁 Project Structure

```text
rv32i-core/
│
├── rtl/                     # Processor RTL
├── tb/                      # Testbenches & regressions
├── sw/                      # RISC-V assembly programs
│
├── run_regression.sh
├── .gitignore
└── README.md
```

Main RTL blocks include:

```text
Program Counter
Register File
Immediate Generator
Control Unit
ALU Decoder
ALU
Branch Unit
Instruction Memory
Data Memory
Top-Level Core
```

---

## ✅ Verification

The design is verified at multiple levels.

| Test Area             | Status |
| --------------------- | :----: |
| Arithmetic / Logic    |    ✅   |
| Loads / Stores        |    ✅   |
| Branches              |    ✅   |
| LUI / AUIPC           |    ✅   |
| JAL / JALR            |    ✅   |
| Integrated Program    |    ✅   |
| GNU Toolchain Program |    ✅   |

Regression tests cover important edge cases including:

* signed vs. unsigned comparisons
* `SRL` vs. `SRA`
* negative immediates
* register shift amounts
* sign / zero extension
* byte and halfword accesses
* taken and not-taken branches
* JAL / JALR link addresses
* JALR target alignment

---

## 🔁 Integrated Program

A small program is used to verify multiple subsystems together:

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
Function Call
   JAL
 │
 ▼
f(x) = 2x + 3
 │
 ▼
Function Return
   JALR
 │
 ▼
Memory Store / Load
```

Expected results:

```text
sum   = 15
f(15) = 33
```

---

## 🛠️ RISC-V Toolchain

Assembly programs can be generated using the standard GNU RISC-V bare-metal toolchain and executed directly by the core.

```text
program.S
    │
    ▼
GNU RISC-V Assembler / Linker
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

Target configuration:

```text
-march=rv32i
-mabi=ilp32
```

---

## 🧪 Run Tests

Run the complete software build and regression suite with:

```bash
./run_regression.sh
```

Expected result:

```text
======================================
 ALL RV32I REGRESSIONS PASSED
======================================
```

---

## 🚧 Current Limitations

| Feature                    | Status |
| -------------------------- | ------ |
| `FENCE`                    | —      |
| `ECALL` / `EBREAK`         | —      |
| Exceptions / Traps         | —      |
| Interrupts                 | —      |
| Misaligned Access Handling | —      |
| Pipeline                   | —      |
| Cache                      | —      |

These features are intentionally outside the scope of the first single-cycle version.

---

## 🚀 Status

**RV32I single-cycle core — v1 complete**

```text
RV32I Core
████████████████████ 100%
```

### Next

**Tang Nano 9K FPGA implementation and peripheral integration**
