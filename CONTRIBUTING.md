# Contributing to Awesome Claude Code

Thank you for your interest in contributing to the Awesome Claude Code project! This document provides guidelines for contributing to this repository.

## Vision

This project aims to become the central hub for Claude Code hooks, featuring:
- A curated collection of community-contributed hooks
- A hook manager for easy discovery and installation
- High-quality, well-documented hooks

## How to Contribute

### 1. Reporting Issues

- Use the GitHub issue tracker to report bugs
- Provide detailed information about your environment
- Include steps to reproduce the problem
- Check existing issues to avoid duplicates

### 2. Suggesting Features

- Use GitHub issues to suggest new features
- Clearly describe the use case and expected behavior
- Consider if the feature aligns with the project's vision

### 3. Contributing Code

#### For Hook Contributions

When contributing new hooks:

1. **Fork the repository** and create a feature branch
2. **Create your hook** following these guidelines:
   - Use TypeScript for type safety
   - Include comprehensive error handling
   - Follow the existing code style
   - Add clear documentation
   - Include usage examples

3. **Hook Structure**:
   ```typescript
   // hooks/your-hook-name.ts
   import { promises as fs } from 'fs';
   import { join } from 'path';
   
   // Read JSON from stdin
   const input = await fs.readFile('/dev/stdin', 'utf8');
   const event = JSON.parse(input);
   
   // Process event
   // ... your hook logic
   
   // Exit with appropriate code
   process.exit(0);
   ```

4. **Testing**:
   - Test your hook locally with sample data
   - Verify it works across different platforms
   - Include test cases if applicable

5. **Documentation**:
   - Update README.md with hook description
   - Document configuration options
   - Include troubleshooting tips

#### For Core Improvements

For improvements to installation scripts, documentation, or core functionality:

1. **Fork and branch** as above
2. **Make your changes** following existing patterns
3. **Test thoroughly** on different platforms
4. **Update documentation** as needed

### 4. Code Style

- Use TypeScript for all hook code
- Follow existing formatting and naming conventions
- Include JSDoc comments for functions
- Use meaningful variable names
- Handle errors gracefully

### 5. Commit Messages

Use clear, descriptive commit messages:
- `feat: add git commit hook for checkpoints`
- `fix: resolve audio playback issue on Linux`
- `docs: update installation instructions`

### 6. Pull Request Process

1. **Create a pull request** with a clear title and description
2. **Reference related issues** using GitHub keywords
3. **Include testing information** - what you tested and how
4. **Be responsive** to feedback and requested changes
5. **Ensure CI passes** (once implemented)

## Hook Categories

We organize hooks into these categories:

- **🔔 Notifications**: Sound, visual, or system notifications
- **📝 Logging**: Event logging and transcript processing
- **🔧 Git Integration**: Version control and branching
- **📊 Analytics**: Usage tracking and metrics
- **🔒 Security**: Security scanning and validation
- **🚀 Productivity**: Workflow automation and tools
- **🎨 UI/UX**: Interface enhancements and theming

## Quality Standards

All contributions should meet these standards:

- **Cross-platform compatibility**: Works on macOS, Windows, and Linux
- **Error handling**: Graceful failure with helpful messages
- **Performance**: Minimal impact on Claude Code performance
- **Security**: No execution of untrusted code or network requests
- **Documentation**: Clear usage instructions and examples

## Getting Help

- Check the existing documentation first
- Search existing issues for similar problems
- Create a new issue with detailed information
- Be respectful and patient with maintainers

## Code of Conduct

- Be respectful and inclusive
- Focus on constructive feedback
- Help create a welcoming environment for all contributors
- Follow GitHub's community guidelines

## License

By contributing, you agree that your contributions will be licensed under the MIT License.

## Future Plans

As this project grows, we plan to add:
- Automated testing for all hooks
- Hook validation and security scanning
- Community rating and review system
- CLI hook manager tool
- Integration with package managers

Thank you for helping make Claude Code hooks awesome! 🎉