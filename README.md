# ssh-image-paste

**Paste clipboard images to remote SSH servers from macOS.**

One keystroke: grab the screenshot from your clipboard, upload it to the remote machine you're SSH'd into, and get the file path ready to paste.

[中文文档](README.zh-CN.md)

## Why?

When working remotely via SSH — especially with AI coding tools like **Claude Code**, **Cursor**, or **VS Code** — there's no built-in way to share a screenshot with the remote environment. You'd have to manually save the file, SCP it over, then type the path.

`ssh-image-paste` does all of that in one step.

> **Note:** This script runs on your **local macOS** and uploads images to the remote server via SCP. You trigger it from a macOS terminal app (iTerm2, Warp, etc.) using a keyboard shortcut — not from within VS Code or Cursor's built-in terminal. The uploaded image path is then ready to paste anywhere on the remote machine.

## How It Works

```
┌──────────┐    pngpaste    ┌───────────┐    SCP    ┌──────────────┐
│  macOS   │ ──────────────>│ temp file │ ────────> │ remote:      │
│ clipboard│                └───────────┘           │ /tmp/clipboard│
└──────────┘                                        │ /clip_xxx.png │
                                                    └───────┬──────┘
                                                            │
                                              path copied to clipboard
                                              (/tmp/clipboard/clip_xxx.png)
```

1. Captures the image from macOS clipboard using `pngpaste`
2. Detects the active SSH session from your frontmost terminal
3. Uploads the image via `scp`
4. Copies the remote file path to your clipboard
5. Shows a macOS notification

## Install

### Quick install (recommended)

```bash
curl -fsSL https://raw.githubusercontent.com/weworkto/ssh-image-paste/main/install.sh | bash
```

### Manual install

```bash
# Install dependency
brew install pngpaste

# Download and install
curl -fsSL https://raw.githubusercontent.com/weworkto/ssh-image-paste/main/ssh-image-paste -o ~/.local/bin/ssh-image-paste
chmod +x ~/.local/bin/ssh-image-paste
```

## Usage

```bash
# Auto-detect SSH target from current terminal
ssh-image-paste

# Specify target manually
ssh-image-paste user@host

# Show help
ssh-image-paste --help
```

### Typical workflow

1. Take a screenshot on macOS (`Cmd+Shift+4` or `Cmd+Shift+5`)
2. Press your custom shortcut to run `ssh-image-paste`
3. The remote path is now in your clipboard — just `Cmd+V` to paste it wherever you need

### Set up a keyboard shortcut

The script itself doesn't bind any shortcut — **you choose your own**. Here are some popular choices:

| Shortcut | Notes |
|----------|-------|
| `Shift+Option+Cmd+I` | Mnemonic: **I**mage |
| `Cmd+Shift+V` | Mnemonic: paste **V**ariant |
| `Ctrl+Shift+U` | Mnemonic: **U**pload |

Pick whatever feels natural to you, then set it up:

#### iTerm2 (recommended)

1. Open **Settings** > **Keys** > **Key Bindings**
2. Click **+** to add a new binding
3. Set your preferred shortcut (e.g. `Shift+Option+Cmd+I`)
4. Action: **Run Coprocess**
5. Command: `~/.local/bin/ssh-image-paste >/dev/null 2>&1`

> The `>/dev/null 2>&1` redirect is required — coprocess output would otherwise be sent to the terminal as input.

#### Other terminals (Warp, Ghostty, Terminal.app, etc.)

Use macOS Automator to create a global shortcut:

1. Open **Automator** > **Quick Action**
2. Set "Workflow receives" to **no input**
3. Add **Run Shell Script** action
4. Set command: `~/.local/bin/ssh-image-paste`
5. Save as "Paste Image to SSH"
6. Go to **System Settings** > **Keyboard** > **Keyboard Shortcuts** > **Services**
7. Find "Paste Image to SSH" and assign your preferred shortcut

## Supported Terminals

| Terminal | Detection Method |
|----------|-----------------|
| **iTerm2** | AppleScript (TTY of current session) |
| **Terminal.app** | AppleScript (TTY of selected tab) |
| **Warp** | Process scan (all SSH sessions) |
| **Ghostty** | Process scan |
| **Alacritty** | Process scan |
| **Kitty** | Process scan |

For terminals using process scan: if multiple SSH sessions are active, a dialog will let you pick the target.

## Configuration

| Environment Variable | Default | Description |
|---------------------|---------|-------------|
| `SSH_IMAGE_PASTE_DIR` | `/tmp/clipboard` | Remote directory for uploaded images |
| `SSH_IMAGE_PASTE_KEEP` | `20` | Number of recent images to keep on remote |

Example:

```bash
export SSH_IMAGE_PASTE_DIR="~/screenshots"
export SSH_IMAGE_PASTE_KEEP=50
```

## Requirements

- **macOS** (uses `pbcopy`, `osascript`, `pngpaste`)
- **pngpaste** — `brew install pngpaste`
- An active SSH connection (or specify target with `ssh-image-paste user@host`)

## Use Cases

- **Claude Code** — SSH into a remote dev machine, trigger the shortcut from your macOS terminal, paste the image path into the Claude Code conversation
- **Cursor / VS Code Remote SSH** — Upload screenshots to the remote server, then reference the image path in your editor or terminal
- **Remote pair programming** — Quickly share visual context with colleagues on the same server
- **Bug reports** — Capture and attach screenshots to remote issue trackers

## FAQ

**Q: Does it work inside VS Code Remote or Cursor's built-in terminal?**
A: No. The script runs on **local macOS** (it needs `pngpaste`, `osascript`, `pbcopy`). It cannot run inside a remote terminal. The workflow is: keep an iTerm2 session SSH'd into the same server, press your shortcut in iTerm2 to upload, then switch back to VS Code/Cursor and paste the path (`Cmd+V`).

**Q: Does it work with SSH jump hosts / ProxyJump?**
A: Yes. It detects the final SSH process and resolves the target. SSH config aliases are also supported via `ssh -G`.

**Q: What if I have multiple SSH sessions?**
A: For iTerm2 and Terminal.app, it detects the session in your active tab. For other terminals, it shows a picker dialog.

**Q: Can I use it without an active SSH session?**
A: Yes — specify the target manually: `ssh-image-paste user@host`

## Contributing

Issues and pull requests are welcome! This project is in its early stages — feedback on terminal compatibility, edge cases, and feature ideas is especially appreciated.

## License

TBD
