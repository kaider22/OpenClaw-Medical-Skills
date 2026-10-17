#!/bin/bash
# Check the bundled Wikipedia script without changing global skill installation.
set -euo pipefail
SKILL_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
chmod +x "$SKILL_DIR/scripts/wiki.py"
python3 "$SKILL_DIR/scripts/wiki.py" --help
