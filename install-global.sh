#!/bin/bash

# Claude Code Global Hooks Installer
# This script installs the notification hooks globally for all Claude Code projects.

set -e

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo "Claude Code Global Hooks Installer"
echo "=================================="
echo

# Check dependencies
check_dependencies() {
    local missing_deps=()
    
    # Check for Node.js/npx
    if ! command -v npx &> /dev/null; then
        missing_deps+=("Node.js (for npx)")
    fi
    
    # Check for jq (only if we need to merge existing settings)
    if [ -f "$HOME/.claude/settings.json" ] && ! command -v jq &> /dev/null; then
        missing_deps+=("jq")
    fi
    
    if [ ${#missing_deps[@]} -gt 0 ]; then
        echo -e "${RED}Missing dependencies:${NC}"
        for dep in "${missing_deps[@]}"; do
            echo "  - $dep"
        done
        echo
        echo "Please install the missing dependencies:"
        echo
        echo "macOS:"
        echo "  brew install node jq"
        echo
        echo "Ubuntu/Debian:"
        echo "  sudo apt-get update"
        echo "  sudo apt-get install nodejs npm jq"
        echo
        echo "Windows (using Chocolatey):"
        echo "  choco install nodejs jq"
        echo
        echo "Or install manually from:"
        echo "  - Node.js: https://nodejs.org/"
        echo "  - jq: https://jqlang.github.io/jq/"
        echo
        exit 1
    fi
}

# Merge JSON files without jq (fallback)
merge_settings_fallback() {
    local existing_file="$1"
    local output_file="$2"
    
    # Simple Python script to merge JSON
    python3 -c "
import json
import sys

try:
    with open('$existing_file', 'r') as f:
        existing = json.load(f)
except:
    existing = {}

hooks = {
    'Notification': {
        'matcher': '*',
        'command': ['npx', 'tsx', '~/.claude/hooks/notification.ts', '--notify']
    },
    'Stop': {
        'matcher': '*',
        'command': ['npx', 'tsx', '~/.claude/hooks/stop.ts', '--chat']
    },
    'SubagentStop': {
        'matcher': '*',
        'command': ['npx', 'tsx', '~/.claude/hooks/subagent_stop.ts']
    }
}

existing['hooks'] = hooks

with open('$output_file', 'w') as f:
    json.dump(existing, f, indent=2)
"
}

echo -e "${YELLOW}Checking dependencies...${NC}"
check_dependencies

CLAUDE_CONFIG_DIR="$HOME/.claude"
if [ ! -d "$CLAUDE_CONFIG_DIR" ]; then
    echo -e "${YELLOW}Creating Claude Code config directory...${NC}"
    mkdir -p "$CLAUDE_CONFIG_DIR"
fi

GLOBAL_HOOKS_DIR="$CLAUDE_CONFIG_DIR/hooks"
if [ ! -d "$GLOBAL_HOOKS_DIR" ]; then
    echo -e "${YELLOW}Creating global hooks directory...${NC}"
    mkdir -p "$GLOBAL_HOOKS_DIR"
fi

echo -e "${GREEN}Copying hooks to global directory...${NC}"
cp -r .claude/hooks/* "$GLOBAL_HOOKS_DIR/"

echo -e "${GREEN}Copying sound files...${NC}"
cp *.wav "$CLAUDE_CONFIG_DIR/"

GLOBAL_SETTINGS="$CLAUDE_CONFIG_DIR/settings.json"

if [ -f "$GLOBAL_SETTINGS" ]; then
    echo -e "${YELLOW}Backing up existing global settings...${NC}"
    cp "$GLOBAL_SETTINGS" "$GLOBAL_SETTINGS.backup"
fi

TEMP_SETTINGS=$(mktemp)

if [ -f "$GLOBAL_SETTINGS" ]; then
    echo -e "${YELLOW}Merging with existing settings...${NC}"
    
    # Try jq first, fall back to Python if jq is not available
    if command -v jq &> /dev/null; then
        jq -s '.[0] * {
            hooks: {
                Notification: {
                    matcher: "*",
                    command: ["npx", "tsx", "~/.claude/hooks/notification.ts", "--notify"]
                },
                Stop: {
                    matcher: "*",
                    command: ["npx", "tsx", "~/.claude/hooks/stop.ts", "--chat"]
                },
                SubagentStop: {
                    matcher: "*",
                    command: ["npx", "tsx", "~/.claude/hooks/subagent_stop.ts"]
                }
            }
        }' "$GLOBAL_SETTINGS" > "$TEMP_SETTINGS"
    elif command -v python3 &> /dev/null; then
        echo -e "${YELLOW}jq not found, using Python fallback...${NC}"
        merge_settings_fallback "$GLOBAL_SETTINGS" "$TEMP_SETTINGS"
    else
        echo -e "${RED}Error: Neither jq nor Python3 found. Cannot merge settings.${NC}"
        echo "Please install jq or Python3, or remove the existing settings file:"
        echo "  rm $GLOBAL_SETTINGS"
        exit 1
    fi
else
    cat > "$TEMP_SETTINGS" <<EOF
{
  "hooks": {
    "Notification": {
      "matcher": "*",
      "command": ["npx", "tsx", "~/.claude/hooks/notification.ts", "--notify"]
    },
    "Stop": {
      "matcher": "*",
      "command": ["npx", "tsx", "~/.claude/hooks/stop.ts", "--chat"]
    },
    "SubagentStop": {
      "matcher": "*",
      "command": ["npx", "tsx", "~/.claude/hooks/subagent_stop.ts"]
    }
  }
}
EOF
fi

mv "$TEMP_SETTINGS" "$GLOBAL_SETTINGS"

GLOBAL_LOGS_DIR="$CLAUDE_CONFIG_DIR/logs"
if [ ! -d "$GLOBAL_LOGS_DIR" ]; then
    echo -e "${YELLOW}Creating global logs directory...${NC}"
    mkdir -p "$GLOBAL_LOGS_DIR"
fi

echo
echo -e "${GREEN}✓ Global installation complete!${NC}"
echo
echo "The following hooks are now available globally:"
echo "  - Notification hook: Plays sound when Claude needs attention"
echo "  - Stop hook: Plays sound when Claude completes a task"
echo "  - SubagentStop hook: Plays sound when subagent completes"
echo
echo "Hooks will log to: $GLOBAL_LOGS_DIR"
echo
echo -e "${YELLOW}Note: You may need to restart Claude Code for changes to take effect.${NC}"
