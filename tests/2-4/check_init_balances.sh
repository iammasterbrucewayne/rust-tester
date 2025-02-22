#!/bin/bash

# Path to the balances.rs file
BALANCES_FILE="src/balances.rs"

# Step 1: Check if the init_balances test is defined
if grep -q "#\[test\]" "$BALANCES_FILE" && grep -q "fn init_balances()" "$BALANCES_FILE"; then
    echo "Test 'init_balances' is defined."
else
    echo "Error: Test 'init_balances' is not defined."
    exit 1
fi

# Step 2: Check if Pallet is initialized in the test with either direct generics or a Config trait
if grep -q "let mut balances = super::Pallet::new();" "$BALANCES_FILE" || \
   grep -q "let mut balances = super::Pallet::<String, u128>::new();" "$BALANCES_FILE" || \
   grep -q "let mut balances = super::Pallet::<TestConfig>::new();" "$BALANCES_FILE"; then
    echo "Pallet is initialized correctly."
else
    echo "Error: Pallet is not initialized correctly in your test. Ensure you're using direct generics or a Config trait."
    exit 1
fi

# Step 3: Check if the balance and set_balance methods are called in the test
if grep -q "balances.balance" "$BALANCES_FILE" && grep -q "balances.set_balance" "$BALANCES_FILE"; then
    echo "balance and set_balance methods are used."
else
    echo "Error: balance or set_balance methods are not used correctly in the test."
    exit 1
fi

# Step 4: Check for assertions pattern
if grep -q "assert_eq!(balances\.balance(.*), *[0-9][0-9]*)" "$BALANCES_FILE" && \
   grep -q "balances\.set_balance(.*), *[0-9][0-9]*)" "$BALANCES_FILE" && \
   [ $(grep -c "assert_eq!(balances\.balance(.*), *[0-9][0-9]*)" "$BALANCES_FILE") -ge 2 ]; then
    echo "Assertions are correct."
else
    echo "Error: Test should include:
    - At least two balance checks using assert_eq!
    - At least one set_balance call"
    exit 1
fi

# Step 5: Run the test to validate functionality
cargo test init_balances

echo "All checks passed for 'init_balances' test."