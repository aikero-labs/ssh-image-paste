# ssh-image-paste

**macOS 剪贴板截图一键上传到 SSH 远程服务器**

一个按键：从剪贴板抓取截图，上传到你正在 SSH 连接的远程机器，远程路径自动复制到剪贴板。

[English](README.md)

## 为什么需要这个工具？

通过 SSH 远程工作时——尤其是使用 **Claude Code**、**Cursor Remote SSH**、**VS Code Remote** 等 AI 编程工具——没有内置的方式将截图传到远程环境。你得手动保存文件、SCP 上传、再输入路径。

`ssh-image-paste` 一步搞定。

## 工作原理

```
┌──────────┐    pngpaste    ┌───────────┐    SCP    ┌──────────────┐
│  macOS   │ ──────────────>│  临时文件  │ ────────> │ 远程服务器:   │
│   剪贴板  │                └───────────┘           │ /tmp/clipboard│
└──────────┘                                        │ /clip_xxx.png │
                                                    └───────┬──────┘
                                                            │
                                              路径自动复制到剪贴板
                                          (/tmp/clipboard/clip_xxx.png)
```

1. 通过 `pngpaste` 从 macOS 剪贴板获取图片
2. 自动检测当前终端的 SSH 连接目标
3. 通过 `scp` 上传图片
4. 将远程文件路径复制到剪贴板
5. 弹出 macOS 通知提示

## 安装

### 一键安装（推荐）

```bash
curl -fsSL https://raw.githubusercontent.com/weworkto/ssh-image-paste/main/install.sh | bash
```

### 手动安装

```bash
# 安装依赖
brew install pngpaste

# 下载安装
curl -fsSL https://raw.githubusercontent.com/weworkto/ssh-image-paste/main/ssh-image-paste -o ~/.local/bin/ssh-image-paste
chmod +x ~/.local/bin/ssh-image-paste
```

## 使用方法

```bash
# 自动检测当前终端的 SSH 目标
ssh-image-paste

# 手动指定目标
ssh-image-paste user@host

# 查看帮助
ssh-image-paste --help
```

### 典型工作流

1. macOS 截图（`Cmd+Shift+4` 或 `Cmd+Shift+5`）
2. 按快捷键（如 `Cmd+Shift+V`）运行 `ssh-image-paste`
3. 远程路径已在剪贴板中——直接 `Cmd+V` 粘贴到需要的地方

### 设置 iTerm2 快捷键

1. 打开 **Preferences** > **Keys** > **Key Bindings**
2. 点击 **+** 添加新绑定
3. 快捷键设为 `Cmd+Shift+V`
4. Action: **Run Command**
5. Command: `~/.local/bin/ssh-image-paste`

### Warp / 其他终端设置快捷键

使用 macOS 自动操作（Automator）：

1. 打开 **自动操作** > **快速操作**
2. 添加 **运行 Shell 脚本** 操作
3. 命令: `~/.local/bin/ssh-image-paste`
4. 保存为 "Paste Image to SSH"
5. 在 **系统设置** > **键盘** > **键盘快捷键** > **服务** 中绑定快捷键

## 支持的终端

| 终端 | 检测方式 |
|------|---------|
| **iTerm2** | AppleScript（获取当前会话 TTY） |
| **Terminal.app** | AppleScript（获取选中标签页 TTY） |
| **Warp** | 进程扫描（所有 SSH 会话） |
| **Ghostty** | 进程扫描 |
| **Alacritty** | 进程扫描 |
| **Kitty** | 进程扫描 |

使用进程扫描的终端：如果有多个 SSH 会话，会弹出选择框让你选目标。

## 配置

| 环境变量 | 默认值 | 说明 |
|---------|--------|------|
| `SSH_IMAGE_PASTE_DIR` | `/tmp/clipboard` | 远程存放图片的目录 |
| `SSH_IMAGE_PASTE_KEEP` | `20` | 远程保留的最近图片数量 |

示例：

```bash
export SSH_IMAGE_PASTE_DIR="~/screenshots"
export SSH_IMAGE_PASTE_KEEP=50
```

## 系统要求

- **macOS**（使用 `pbcopy`、`osascript`、`pngpaste`）
- **pngpaste** — `brew install pngpaste`
- 活跃的 SSH 连接（或通过 `ssh-image-paste user@host` 手动指定目标）

## 使用场景

- **Claude Code** — 将截图粘贴到 AI 编程助手对话中
- **Cursor Remote SSH** — 分享 UI 设计稿或错误截图
- **VS Code Remote** — 在远程开发中引用图片
- **远程结对编程** — 快速分享视觉上下文
- **Bug 报告** — 截图并附加到远程 issue 系统

## 常见问题

**Q: 支持 SSH 跳板机 / ProxyJump 吗？**
A: 支持。脚本检测最终的 SSH 进程并解析目标。也支持通过 `ssh -G` 解析 SSH config alias。

**Q: 多个 SSH 会话怎么办？**
A: iTerm2 和 Terminal.app 会检测当前标签页的会话。其他终端会弹出选择框。

**Q: 没有 SSH 连接可以用吗？**
A: 可以——手动指定目标：`ssh-image-paste user@host`

## 贡献

欢迎提 Issue 和 Pull Request！项目还在早期阶段，特别欢迎关于终端兼容性、边界情况和功能建议的反馈。

## 许可证

待定
