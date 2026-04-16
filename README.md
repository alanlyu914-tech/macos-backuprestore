# 🍁 macOS 迁移备份工具

> 补齐 macOS 自带迁移工具的不足，自动备份和恢复开发环境、代码项目、系统配置

**作者：** [大东](https://github.com/alanlyu914-tech)

---

## ✨ 为什么要用这个工具？

macOS 的「迁移助理」很好用，但有几个局限性：

1. **代码迁移不完整** - 虚拟环境、依赖包、环境变量经常丢失
2. **开发环境要重搭** - Homebrew 工具、VS Code 插件、npm 包都要手动重装
3. **系统配置要重设** - Terminal 颜色、Git 配置、SSH 密钥都要重新配置

**这个工具就是为了解决这些问题：**

- 🔍 **智能扫描你的电脑** - 自动发现你安装了什么
- 📦 **按需备份** - 你决定要备份什么，逐项确认
- 💻 **自动恢复** - 在新电脑上一键恢复你的开发环境
- 📝 **大白话解释** - 每一项都用通俗语言说明，小白也能看懂

**适用人群：** 开发者、AI 开发者、需要重装 macOS 的用户

---

## 🎯 工作原理

```
┌─────────────────┐
│  旧电脑         │
│                 │
│ 1️⃣ 运行扫描    │ ← 扫描你的开发环境、应用、配置
│                 │
│ 2️⃣ 逐项确认    │ ← 看到每一项，决定是否备份
│                 │
│ 3️⃣ 自动备份    │ ← 备份你选择的内容
└────────┬────────┘
         │
         │ 复制到外置硬盘
         │
┌────────▼────────┐
│  新电脑         │
│                 │
│ 1️⃣ 运行恢复    │ ← 恢复系统配置
│                 │
│ 2️⃣ 自动安装    │ ← 安装你之前备份的应用和工具
│                 │
│ 3️⃣ 恢复代码    │ ← 恢复代码项目和依赖
└─────────────────┘
```

---

## 🚀 快速开始

### 第一步：备份（旧电脑/重装前）

\`\`\`bash
# 1. 下载项目
git clone https://github.com/alanlyu914-tech/macos-backuprestore.git
cd macos-backuprestore

# 2. 运行备份脚本
./backup.sh
\`\`\`

**然后：**
1. 工具会扫描你的电脑，显示发现了什么
2. 逐项确认要备份的内容（都有大白话解释）
3. 确认后开始自动备份
4. 将整个文件夹复制到外置硬盘或云盘

---

### 第二步：恢复（新电脑/重装后）

\`\`\`bash
# 1. 从外置硬盘复制项目到新电脑
cp -r /Volumes/你的外置硬盘/macos-backuprestore ~/

# 2. 恢复系统配置
cd ~/macos-backuprestore/scripts
./restore.sh

# 3. 安装你之前备份的应用和工具
./reinstall-everything.sh

# 4. 恢复代码项目
./restore-code.sh

# 5. 恢复项目依赖
./restore-projects.sh
\`\`\`

---

## 📦 会备份什么？

### 自动扫描并备份

工具会扫描你的电脑，然后你可以选择备份：

| 类别 | 说明 |
|------|------|
| **开发工具** | Homebrew 安装的命令行工具（git、python、ffmpeg 等） |
| **GUI 应用** | Homebrew Cask 安装的应用（vscode、chrome、微信等） |
| **代码项目** | 你的代码，智能排除 node_modules、venv 等大文件 |
| **环境变量** | .env 文件（API 密钥、数据库配置等） |
| **系统配置** | Terminal、Git、SSH、VS Code 等设置 |
| **VS Code 插件** | 你安装的所有扩展 |

> **注意：** 具体会备份什么取决于你的电脑上有什么。工具会先扫描，然后给你看。

### 需要手动复制

以下内容需要你自己复制到外置硬盘：

- ~/Documents（文档）
- ~/Pictures（照片）
- ~/Movies（视频）
- ~/Desktop（桌面）

> **为什么手动复制？** 这些文件通常很大，用 Finder 复制更直观。工具会给你详细的提示。

---

## 💡 使用场景

### ✅ 适合使用

- **换新 Mac** - 自动迁移开发环境，不用重头搭起
- **重装系统** - 磁盘扩容、系统重装后快速恢复
- **代码迁移** - 解决 macOS 自带迁移工具迁移代码不完整的问题
- **定期备份** - 定期备份开发环境，防止意外丢失

### ❌ 不适合使用

- **完整系统迁移** - macOS 自带的「迁移助理」更适合迁移所有文件和应用
- **非开发者** - 如果你不需要开发环境，macOS 自带工具就够了
- **需要 GUI 界面** - 这个工具是命令行界面

---

## 🛠️ 系统要求

- **操作系统：** macOS 10.15+
- **磁盘空间：** 至少 5GB 可用空间（取决于代码量）
- **Homebrew：** 需要先安装（恢复时会提示）

**推荐：** macOS 12+（Monterey 或更高）

---

## 📚 详细文档

项目包含完整的文档：

- **恢复指南.md** - 完整的迁移步骤教程
- **AI项目迁移指南.md** - AI 项目专项迁移教程
- **项目配置参考.md** - 环境变量配置说明
- **快速参考.txt** - 命令速查表

---

## 🌟 支持的项目类型

### 🤖 AI/ML 项目
- Python 项目（requirements.txt）
- Node.js 项目（package.json）
- Jupyter Notebooks
- 数据科学项目

### 💻 通用开发项目
- Web 前端/后端项目
- 移动应用项目
- 桌面应用项目
- 开发工具项目

---

## 🔒 安全说明

- **本地运行** - 所有数据都在你的电脑上处理，不上传服务器
- **SSH 密钥** - 安全备份，权限自动设置为 600
- **环境变量** - 备份 .env 文件，请妥善保管
- **开源透明** - 代码完全开源，你可以审查每一行

---

## 🤝 贡献

欢迎贡献！你可以：

- 🐛 报告 Bug
- 💡 提出新功能建议
- 📝 改进文档
- 🔧 提交代码

**如何贡献：**

1. Fork 本项目
2. 创建你的功能分支 (git checkout -b feature/AmazingFeature)
3. 提交更改 (git commit -m 'Add some AmazingFeature')
4. 推送到分支 (git push origin feature/AmazingFeature)
5. 开启 Pull Request

详见 [贡献指南](CONTRIBUTING.md)

---

## 📝 开源协议

本项目采用 MIT License 开源协议。

这意味着你可以：
- ✅ 自由使用
- ✅ 自由修改
- ✅ 自由分发
- ✅ 用于商业用途

---

## 🔮 未来计划

- [ ] 云备份支持（iCloud、Google Drive）
- [ ] 定时自动备份
- [ ] GUI 图形界面
- [ ] Linux 迁移支持
- [ ] Windows 迁移支持

---

## 📞 获取帮助

- 📖 查看完整文档
- 🐛 [报告问题](https://github.com/alanlyu914-tech/macos-backuprestore/issues)
- 💬 [讨论交流](https://github.com/alanlyu914-tech/macos-backuprestore/discussions)

---

## 📧 联系方式

- **作者：** 大东
- **GitHub：** [@alanlyu914-tech](https://github.com/alanlyu914-tech)
- **项目：** [macos-backuprestore](https://github.com/alanlyu914-tech/macos-backuprestore)

---

**🎉 祝你迁移顺利！**

*补充 macOS 自带迁移工具，让开发环境迁移更简单！*
