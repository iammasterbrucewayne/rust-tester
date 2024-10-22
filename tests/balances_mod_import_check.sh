#!/bin/bash

# Path to the main.rs
MAIN_FILE="src/main.rs"

# Check if the file exists
if [ ! -f "$MAIN_FILE" ]; then
    echo "Error: $MAIN_FILE not found in $(pwd)"
    exit 1
fi

# Check for private module declaration
if grep -q "^mod balances;" "$MAIN_FILE"; then
    echo "Module 'balances' is correctly declared as private"
    exit 0
elif grep -q "^pub mod balances;" "$MAIN_FILE"; then
    echo "Error: Module 'balances' is declared as public"
    exit 1
else
    echo "Error: Module 'balances' declaration not found"
    exit 1
fi