# Awesome Claude Code Sound Notifications

Sound notification hooks for Claude Code that play audio alerts when Claude needs attention or completes tasks. Works on macOS, Windows, and Linux without external dependencies.

**🎵 macOS Enhancement**: Now uses built-in system sounds on macOS - no sound files needed!

> **Vision**: This repository aims to become the central hub for awesome Claude Code hooks, featuring a curated collection of community-contributed hooks
> and eventually a hook manager to easily discover, install, and manage hooks across projects.

## Features

- 🔔 **Notification Hook**: Plays sound when Claude needs user attention
- ✅ **Stop Hook**: Plays sound when Claude completes a task
- 🤖 **SubagentStop Hook**: Plays sound when a subagent completes
- 📝 **Event Logging**: All events are logged to JSON files for review
- 💬 **Chat Transcript Processing**: Optionally logs full chat transcripts
- 🌍 **Cross-Platform**: Works on macOS, Windows, and Linux using native commands

## Quick Start

### Local Installation (Project-Specific)

1. Clone this repository or copy the `.claude` directory to your project
2. **For Windows/Linux**: Ensure the sound files are in your project root:
   - `on-agent-need-attention.wav`
   - `on-agent-complete.wav`
3. **For macOS**: No sound files needed - uses built-in system sounds!
4. The hooks will automatically work for this project

### Global Installation (All Projects)

To use these hooks in all your Claude Code projects:

```bash
# Install globally
./install-global.sh

# To uninstall
./uninstall-global.sh
```

The global installer will:

- Copy hooks to `~/.claude/hooks/`
- Copy sound files to `~/.claude/` (Windows/Linux only)
- Update `~/.claude/settings.json` with hook configurations (preserves existing permissions)
- Create a logs directory at `~/.claude/logs/`
- **macOS**: Automatically uses system sounds - no file copying needed!

## How It Works

### Sound Playback

The hooks use native system commands for audio playback:

- **macOS**: `afplay` with built-in system sounds
  - Notification: `/System/Library/Sounds/Funk.aiff`
  - Completion: `/System/Library/Sounds/Glass.aiff`
- **Windows**: PowerShell `Media.SoundPlayer` (built-in) with custom WAV files
- **Linux**: `aplay`, `paplay`, or `play` (usually pre-installed) with custom WAV files

### TypeScript Execution

Hooks are written in TypeScript and executed directly using `npx tsx` - no build step required!

### Event Processing

1. Claude Code sends JSON event data to the hook via stdin
2. Hook processes the event and plays appropriate sound
3. Event details are logged to JSON files
4. Exit code indicates success/failure

## Configuration

### Hook Settings

The `.claude/settings.json` configures three hooks:

> **Note**: The installer only updates the `hooks` configuration and preserves any existing `permissions` you may have configured.

```json
{
  "hooks": {
    "PreToolUse": [],
    "PostToolUse": [],
    "Notification": [
      {
        "matcher": "",
        "hooks": [
          {
            "type": "command",
            "command": "npx tsx .claude/hooks/notification.ts --notify"
          }
        ]
      }
    ],
    "Stop": [
      {
        "matcher": "",
        "hooks": [
          {
            "type": "command",
            "command": "npx tsx .claude/hooks/stop.ts --chat"
          }
        ]
      }
    ],
    "SubagentStop": [
      {
        "matcher": "",
        "hooks": [
          {
            "type": "command",
            "command": "npx tsx .claude/hooks/subagent_stop.ts"
          }
        ]
      }
    ]
  }
}
```

### Flags

- `--notify`: Play sound for notification events
- `--chat`: Process and log chat transcripts

## Logs

Logs are stored in the `logs/` directory (or `~/.claude/logs/` for global installation):

- `notifications.json` - All notification events
- `stop.json` - All stop events
- `subagent_stop.json` - All subagent stop events
- `chat.json` - Chat transcripts (when using `--chat` flag)

## Testing

Test hooks locally:

```bash
# Test notification hook
npx tsx .claude/hooks/notification.ts --notify

# Test with sample input
echo '{"type":"Notification","data":{}}' | npx tsx .claude/hooks/notification.ts --notify
```

## Requirements

### Core Dependencies

- **Node.js** (for `npx`) - Required for running TypeScript hooks - must be available in your $PATH
- **TypeScript execution via `tsx`** - Installed automatically via npx
- **Sound files** (Windows/Linux only): `on-agent-need-attention.wav` and `on-agent-complete.wav`
- **macOS**: No sound files required - uses built-in system sounds

### Dependencies

All dependencies are already covered by the core requirements above - no additional dependencies needed for global installation.

### Installation Commands

**macOS** (using Homebrew):

```bash
brew install node
```

**Ubuntu/Debian**:

```bash
sudo apt-get update
sudo apt-get install nodejs npm
```

**Windows** (using Chocolatey):

```bash
choco install nodejs
```

**Manual installation**:

- Node.js: https://nodejs.org/

**Make sure to have Claude installed globally.**

## Platform Notes

### Linux

Most Linux distributions include at least one of these audio players:

- `aplay` (ALSA)
- `paplay` (PulseAudio)
- `play` (SoX)

If none are available, install one:

```bash
# Debian/Ubuntu
sudo apt-get install alsa-utils  # for aplay
# or
sudo apt-get install pulseaudio-utils  # for paplay
# or
sudo apt-get install sox  # for play
```

### Windows

Uses built-in PowerShell, no additional software needed.

### macOS

Uses built-in `afplay` with system sounds, no additional software or sound files needed.

Available system sounds in `/System/Library/Sounds/`:
- Basso, Blow, Bottle, Frog, Funk, Glass, Hero, Morse, Ping, Pop, Purr, Sosumi, Submarine, Tink

Currently configured:
- Notifications: `Funk.aiff` (distinctive alert sound)
- Completions: `Glass.aiff` (pleasant completion chime)

## Troubleshooting

1. **No sound playing**: 
   - Windows/Linux: Check that sound files exist in the project root
   - macOS: Ensure system volume is not muted
2. **Permission errors**: Ensure hooks have execute permissions
3. **Linux audio issues**: Try installing one of the supported audio players
4. **Logs not appearing**: Check file permissions on the logs directory
5. **Installation fails with Node.js errors**: Ensure Node.js is installed and available in your PATH
6. **Installation fails with "npx not found"**: Install Node.js first
7. **Hooks not triggering**: Restart Claude Code after global installation
8. **Permission denied errors**: Ensure you have proper permissions configured in your `~/.claude/settings.json`

## Attribution & Credits

### Inspiration

This project was inspired by [claude-code-hooks-mastery](https://github.com/disler/claude-code-hooks-mastery) by [@disler](https://github.com/disler),
which provided excellent examples and patterns for Claude Code hooks implementation.

### Audio Sources

Sound effects are provided by [Mixkit](https://mixkit.co/free-sound-effects/notification/)
under their free license:

- `on-agent-need-attention.wav` - Notification sound for attention events
- `on-agent-complete.wav` - Completion sound for task finished events

### Special Thanks

- The Claude Code team at Anthropic for creating such an extensible platform
- The open-source community for TypeScript and Node.js ecosystem
- All future contributors who will help build the awesome Claude hooks collection
