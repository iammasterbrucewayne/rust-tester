#!/bin/bash
./tests/helpers/update_version.sh "0.3.2"

BALANCES_FILE="src/balances.rs"

source ./tests/helpers/check_struct_and_update_version.sh

check_struct_and_update_version "$BALANCES_FILE" "pub struct Pallet<AccountId, Balance>" "0.4.3"
check_struct_and_update_version "$BALANCES_FILE" "pub struct Pallet<T: Config>" "0.4.6"

cargo test test_system_interactions