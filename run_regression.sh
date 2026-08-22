#!/bin/bash

set -e

echo "======================================"
echo " RV32I CORE FINAL REGRESSION"
echo "======================================"
echo


run_test () {

    TB_NAME=$1
    PASS_TEXT=$2

    echo "Running $TB_NAME..."

    iverilog -g2012 \
        -s "$TB_NAME" \
        -o "${TB_NAME}_sim" \
        rtl/*.sv \
        "tb/${TB_NAME}.sv" \
        2> compile.log

    OUTPUT=$(vvp "${TB_NAME}_sim")

    echo "$OUTPUT"

    if echo "$OUTPUT" | grep -q "$PASS_TEXT"; then
        echo "[OK] $TB_NAME"
    else
        echo "[FAIL] $TB_NAME"
        exit 1
    fi

    echo
}


# ---------------------------------------
# Build software
# ---------------------------------------

echo "Building RISC-V programs..."

riscv64-unknown-elf-gcc \
    -march=rv32i \
    -mabi=ilp32 \
    -nostdlib \
    -Ttext=0x0 \
    -o sw/program.elf \
    sw/program.S

riscv64-unknown-elf-objcopy \
    -O binary \
    sw/program.elf \
    sw/program.bin


riscv64-unknown-elf-gcc \
    -march=rv32i \
    -mabi=ilp32 \
    -nostdlib \
    -Ttext=0x0 \
    -o sw/integrated_program.elf \
    sw/integrated_program.S

riscv64-unknown-elf-objcopy \
    -O binary \
    sw/integrated_program.elf \
    sw/integrated_program.bin


# ---------------------------------------
# Binary -> HEX
# ---------------------------------------

python3 - <<'PY'

def convert(filename):
    data = open(f"sw/{filename}.bin", "rb").read()

    with open(f"sw/{filename}.hex", "w") as f:
        for i in range(0, len(data), 4):
            word = int.from_bytes(
                data[i:i+4],
                byteorder="little"
            )
            f.write(f"{word:08x}\n")


convert("program")
convert("integrated_program")

PY


echo "Software build complete."
echo


# ---------------------------------------
# Run regressions
# ---------------------------------------

run_test arithmetic_regression_tb \
    "ARITHMETIC REGRESSION PASS"

run_test load_store_regression_tb \
    "LOAD/STORE REGRESSION PASS"

run_test control_flow_regression_tb \
    "CONTROL FLOW REGRESSION PASS"

run_test integrated_program_tb \
    "INTEGRATED PROGRAM PASS"

run_test toolchain_program_tb \
    "TOOLCHAIN PROGRAM PASS"

run_test toolchain_integrated_tb \
    "TOOLCHAIN INTEGRATED PROGRAM PASS"


echo "======================================"
echo " ALL RV32I REGRESSIONS PASSED"
echo "======================================"
