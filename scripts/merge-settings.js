#!/usr/bin/env node

import fs from 'fs';
import os from 'os';
import path from 'path';

// Get command line arguments
const args = process.argv.slice(2);
if (args.length < 2 || args.length > 4) {
    console.error('Usage: node merge-settings.js <existing_file> <output_file> [speech] [voice]');
    process.exit(1);
}

const [existingFile, outputFile, mode, voice] = args;
const useSpeak = mode === 'speech';
const home = os.homedir();

let existing = {};
try {
    if (fs.existsSync(existingFile)) {
        const content = fs.readFileSync(existingFile, 'utf8').trim();
        if (content) {
            existing = JSON.parse(content);
        }
    }
} catch (e) {
    // Silently continue with empty object if file doesn't exist or can't be read
    existing = {};
}

const speakFlag = useSpeak ? ` --speak${voice ? ` --voice ${voice}` : ''}` : '';

const new_hooks = {
    'PreToolUse': [],
    'PostToolUse': [],
    'Notification': [
        {
            'matcher': '',
            'hooks': [
                {
                    'type': 'command',
                    'command': `npx tsx ${home}/.claude/hooks/notification.ts --notify${speakFlag}`
                }
            ]
        }
    ],
    'Stop': [
        {
            'matcher': '',
            'hooks': [
                {
                    'type': 'command',
                    'command': `npx tsx ${home}/.claude/hooks/stop.ts --chat${speakFlag}`
                }
            ]
        }
    ],
    'SubagentStop': [
        {
            'matcher': '',
            'hooks': [
                {
                    'type': 'command',
                    'command': `npx tsx ${home}/.claude/hooks/subagent_stop.ts${speakFlag}`
                }
            ]
        }
    ]
};

// Only update hooks, don't modify permissions
existing.hooks = new_hooks;

try {
    fs.writeFileSync(outputFile, JSON.stringify(existing, null, 2));
    console.log('Settings merged successfully');
} catch (e) {
    console.error('Error writing output file:', e.message);
    process.exit(1);
}