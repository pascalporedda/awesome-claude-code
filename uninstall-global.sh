#!/bin/bash

# Claude Code Global Hooks Uninstaller
# This script removes the globally installed notification hooks

set -e

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo "Claude Code Global Hooks Uninstaller"
echo "===================================="
echo

CLAUDE_CONFIG_DIR="$HOME/.claude"

if [ ! -d "$CLAUDE_CONFIG_DIR" ]; then
    echo -e "${RED}No Claude Code configuration found at $CLAUDE_CONFIG_DIR${NC}"
    exit 1
fi

# Remove hooks directory
GLOBAL_HOOKS_DIR="$CLAUDE_CONFIG_DIR/hooks"
if [ -d "$GLOBAL_HOOKS_DIR" ]; then
    echo -e "${YELLOW}Removing global hooks directory...${NC}"
    rm -rf "$GLOBAL_HOOKS_DIR"
fi

# Remove sound files (only for non-macOS systems)
if [[ "$OSTYPE" != "darwin"* ]]; then
    echo -e "${YELLOW}Removing sound files...${NC}"
    rm -f "$CLAUDE_CONFIG_DIR"/*.wav
else
    echo -e "${GREEN}macOS detected - no sound files to remove (uses built-in system sounds)${NC}"
fi

# Remove hooks from global settings.json
GLOBAL_SETTINGS="$CLAUDE_CONFIG_DIR/settings.json"
if [ -f "$GLOBAL_SETTINGS" ]; then
    echo -e "${YELLOW}Removing hooks from global settings...${NC}"
    
    # Use jq to remove hooks key
    TEMP_SETTINGS=$(mktemp)
    jq 'del(.hooks)' "$GLOBAL_SETTINGS" > "$TEMP_SETTINGS"
    
    # If the settings file is now empty or just {}, remove it
    if [ "$(jq -r 'keys | length' "$TEMP_SETTINGS")" -eq 0 ]; then
        rm -f "$GLOBAL_SETTINGS"
        rm -f "$TEMP_SETTINGS"
        echo -e "${GREEN}Removed empty settings file${NC}"
    else
        mv "$TEMP_SETTINGS" "$GLOBAL_SETTINGS"
        echo -e "${GREEN}Updated settings file${NC}"
    fi
fi

# Optionally remove logs
echo
read -p "Remove log files? (y/N) " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    GLOBAL_LOGS_DIR="$CLAUDE_CONFIG_DIR/logs"
    if [ -d "$GLOBAL_LOGS_DIR" ]; then
        rm -rf "$GLOBAL_LOGS_DIR"
        echo -e "${GREEN}Removed log directory${NC}"
    fi
fi

echo
echo -e "${GREEN}✓ Global hooks uninstalled successfully!${NC}"