#!/bin/bash
CEMU_ACT_DIR="$HOME/.local/share/Cemu/mlc01/usr/save/system/act"

if [ -d "$CEMU_ACT_DIR" ]; then
    echo "Checking Cemu account.dat files..."
    for account_dir in "$CEMU_ACT_DIR"/*/; do
        account_dat="$account_dir/account.dat"
        if [ -f "$account_dat" ]; then
            if ! grep -q "ServerAccountStatus" "$account_dat"; then
                echo "Fixing $account_dat - adding ServerAccountStatus=0"
                cp "$account_dat" "$account_dat.backup"
                sed -i '/IsServerAccountDeleted=0/a ServerAccountStatus=0' "$account_dat"
            fi
        fi
    done
    echo "Cemu account.dat files checked and fixed"
fi
