#!/bin/bash
PROVIDER_FILE="repos/account/src/services/nnas/routes/provider.ts"
OAUTH_FILE="repos/account/src/services/nnas/routes/oauth.ts"
VERIFY_FILE="repos/account/src/middleware/console-status-verification.ts"
PNID_FILE="repos/account/src/middleware/pnid.ts"
NASC_FILE="repos/account/src/middleware/nasc.ts"

REBUILD_NEEDED=0

if [ -f "$PROVIDER_FILE" ]; then
    if ! grep -q "titleID.replace(/-/g" "$PROVIDER_FILE"; then
        echo "Applying title ID dash-stripping patch..."
        sed -i "s/parseInt(titleID, 16)/parseInt(titleID.replace(\\/-\\/g, ''), 16)/g" "$PROVIDER_FILE"
        REBUILD_NEEDED=1
    fi
fi

for f in "$OAUTH_FILE" "$VERIFY_FILE" "$PNID_FILE" "$NASC_FILE"; do
    if [ -f "$f" ]; then
        if grep -q "access_level < 0" "$f" && ! grep -q "BAN_BYPASS" "$f"; then
            echo "Disabling ban check in $f..."
            python3 -c "
import re, sys
with open('$f', 'r') as fh: content = fh.read()
pattern = r'(\t+)(if\s*\([^)]*access_level\s*<\s*0[^)]*\)\s*\{[^}]*\n(?:[^}]*\n)*?\1\})'
def replacer(m):
    indent = m.group(1)
    block = m.group(2)
    return f'{indent}/* BAN_BYPASS - disabled for local private server */\n{indent}/*\n{indent}{block}\n{indent}*/'
result = re.sub(pattern, replacer, content)
if result != content:
    with open('$f', 'w') as fh: fh.write(result)
    print(f'  Patched {"$f"}')
" 2>/dev/null || echo "  Warning: Python fallback patch for $f may need manual review"
            REBUILD_NEEDED=1
        fi
    fi
done

if [ $REBUILD_NEEDED -eq 1 ]; then
    echo "Account service source files patched. The GUI will rebuild the account image when applying Cemu patches."
fi

BOSS_CFG="repos/BOSS/src/config-manager.ts"
if [ -f "$BOSS_CFG" ]; then
    if grep -q "5202ce5099232c3d365e28379790a919" "$BOSS_CFG"; then
        echo "Patching BOSS MD5 hash expectation for placeholder keys..."
        sed -i "s/5202ce5099232c3d365e28379790a919/e43881072b6c26928f8351c9c2f1381b/g" "$BOSS_CFG"
        sed -i "s/b4482fef177b0100090ce0dbeb8ce977/dcac47c7feace17a6aec0c171cc73f59/g" "$BOSS_CFG"
        sed -i "s/86fbc2bb4cb703b2a4c6cc9961319926/b06e25c2acdb585197493b738e64cdaf/g" "$BOSS_CFG"
    fi
fi
BOSS_GET="scripts/get-boss-keys.sh"
if [ -f "$BOSS_GET" ]; then
    if grep -q "5202ce5099232c3d365e28379790a919" "$BOSS_GET"; then
        sed -i "s/5202ce5099232c3d365e28379790a919/e43881072b6c26928f8351c9c2f1381b/g" "$BOSS_GET"
        sed -i "s/b4482fef177b0100090ce0dbeb8ce977/dcac47c7feace17a6aec0c171cc73f59/g" "$BOSS_GET"
        sed -i "s/86fbc2bb4cb703b2a4c6cc9961319926/b06e25c2acdb585197493b738e64cdaf/g" "$BOSS_GET"
    fi
fi
