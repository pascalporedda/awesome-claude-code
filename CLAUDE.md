# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a Claude Code hooks project that implements sound notifications for various Claude Code events. The hooks are written in TypeScript and use native system commands to play sounds, requiring no external dependencies.

## Development Commands

Since this project uses TypeScript hooks with no build step required:

1. Test hooks locally: `npx tsx .claude/hooks/notification.ts --notify`
2. No installation needed - hooks run directly via `npx tsx`
3. Alternative runners: `pnpm dlx tsx`, `bunx tsx`, or `bun`

## Architecture & Key Components

### Implemented Hooks

The project contains three TypeScript hooks in `.claude/hooks/`:

1. **notification.ts** - Plays `on-agent-need-attention.wav` when Claude needs user attention
   - Triggered on Notification events
   - Only plays sound with `--notify` flag
   - **NEW**: Use `--speak` flag on macOS to use voice synthesis instead (says "Your agent needs attention")
   - Logs events to `logs/notifications.json`

2. **stop.ts** - Plays `on-agent-complete.wav` when Claude completes a task
   - Triggered on Stop events
   - Processes chat transcripts with `--chat` flag
   - **NEW**: Use `--speak` flag on macOS to use voice synthesis instead (says "Your agent has finished")
   - Logs events to `logs/stop.json` and transcripts to `logs/chat.json`

3. **subagent_stop.ts** - Plays `on-agent-complete.wav` when a subagent completes
   - Triggered on SubagentStop events
   - **NEW**: Use `--speak` flag on macOS to use voice synthesis instead (says "Your subagent has finished")
   - Logs events to `logs/subagent_stop.json`

### Sound Playback

The hooks use native system commands for cross-platform audio:
- **macOS**: `afplay` (built-in)
- **Windows**: PowerShell `Media.SoundPlayer` (built-in)
- **Linux**: `aplay`, `paplay`, or `play` (usually pre-installed)

### Configuration

The `.claude/settings.json` configures:
- Hook mappings for Notification, Stop, and SubagentStop events
- Permissions for necessary operations
- Commands using `npx tsx` for direct TypeScript execution

**Speech Alternative**: A `.claude/settings-speech.json` file is also provided that includes the `--speak` flag for all hooks. To use voice synthesis instead of sound files on macOS:
1. Copy `settings-speech.json` to `settings.json`
2. Or manually add the `--speak` flag to your existing settings.json commands

### Required Files

- `on-agent-need-attention.wav` - Sound for notifications
- `on-agent-complete.wav` - Sound for completion events
- Both files must be in the repository root

## Future Features

Based on README.md, planned features include:

1. **Git Integration**:
   - Git commits for checkpoints with restore functionality
   - Git worktrees for subagent isolation

## Hook Development

When adding new hooks:
1. Create TypeScript file in `.claude/hooks/`
2. Read JSON from stdin
3. Process the event data
4. Log to `logs/` directory
5. Exit with appropriate code (0 for success)
6. Add configuration to `.claude/settings.json`

## Security Considerations

- Hooks validate file existence before operations
- Error handling prevents script crashes
- All file paths are properly escaped for shell commands
- Logs are written to isolated `logs/` directory

## Project Origin and Inspiration

- Conceived during a collaborative coding session with Claude AI
- Goal: Create a lightweight, dependency-free sound notification system for AI interactions
- Inspired by the need for audible feedback during complex coding tasks
- Developed to enhance the developer experience with Claude Code hooks

## Memories

- Added a memory update using the CLAUDE.md file guidance system