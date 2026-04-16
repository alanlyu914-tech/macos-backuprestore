# 🍁 macOS 迁移备份工具

> 一键迁移你的 Mac 电脑，自动备份开发环境、代码项目、系统配置

**作者：** [大东](https://github.com/alanlyu914-tech)

---

## ✨ 简介

这个工具帮助你从旧 Mac 电脑迁移到新 Mac 电脑，自动备份和恢复：

- 🔍 **智能扫描** - 自动发现并分类你的开发环境、应用、配置
- 💻 **一键安装** - 自动恢复 17+ GUI 应用（Chrome、微信、VS Code等）
- 📦 **代码备份** - 自动备份你的所有代码项目，包括环境变量
- 🔒 **安全备份** - 安全备份 SSH 密钥和 API 密钥
- 📝 **逐项确认** - 友好的交互界面，大白话解释每一项

**适用人群：** 开发者、AI 开发者、换新 Mac 的用户

---

## 🎯 功能特点

### 📸 智能扫描
- 自动扫描 Homebrew 工具、GUI 应用、代码项目
- 检测 Python、Node.js、Git、Docker 等开发环境
- 识别系统配置、SSH 密钥、环境变量文件

### 💻 一键安装
- 自动安装 108+ 个命令行工具
- 自动安装 17+ 个 GUI 应用
- 自动安装 VS Code 扩展（16 个）

### 📦 代码备份
- 自动扫描并备份所有代码项目
- 智能排除不需要的文件（节省 52% 空间）
- 保留所有 .env 环境变量配置

### 🔐 安全备份
- 安全备份 SSH 密钥
- 安全备份 API 密钥（讯飞、豆包、DeepSeek等）
- 加密存储敏感信息

### 📝 友好界面
- 大白话解释每一项的作用
- 逐项确认，不会遗漏
- 重要事项特别标注

---

## 🚀 快速开始

### 第一步：备份（旧电脑）

\`\`\`bash
# 1. 克隆或下载这个项目
git clone https://github.com/alanlyu914-tech/macos-backup-restore.git
cd macos-backup-restore

# 2. 运行备份脚本
./backup.sh
\`\`\`

**然后：**
1. 逐项确认要备份的内容
2. 确认后开始自动备份
3. 将整个 macos-backup-restore 文件夹复制到外置硬盘

---

### 第二步：恢复（新电脑）

\`\`\`bash
# 1. 从外置硬盘复制项目到新电脑
cp -r /Volumes/你的外置硬盘/macos-backup-restore ~/

# 2. 恢复系统配置
cd ~/macos-backup-restore/scripts
./restore.sh

# 3. 安装所有应用
./reinstall-everything.sh

# 4. 恢复代码项目
./restore-code.sh

# 5. 恢复项目依赖
./restore-projects.sh

# 6. 验证配置
./verify-projects.sh
\`\`\`

---

## 📚 详细文档

项目包含完整的文档系统：

- **恢复指南.md** - 完整的迁移步骤教程
- **AI项目迁移指南.md** - AI 项目专项迁移教程
- **项目配置参考.md** - API 密钥配置手册
- **一键安装应用说明.md** - GUI 应用安装列表
- **快速参考.txt** - 命令速查表

---

## 🎬 备份内容

### 自动备份的内容

| 类别 | 内容 | 数量 |
|------|------|------|
| **开发工具** | Python、FFmpeg、Git 等 | 108+ |
| **GUI 应用** | Chrome、微信、VS Code 等 | 17 |
| **代码项目** | 你的程序代码、环境变量 | 全部 |
| **系统配置** | Terminal、Git、SSH、VS Code 设置 | 全部 |

### 需要手动复制的内容

- ~/Documents（文档）
- ~/Pictures（照片）
- ~/Movies（视频）
- ~/Desktop（桌面）

**工具会给你详细的复制命令和提示。**

---

## 🛠️ 系统要求

- **操作系统：** macOS 10.15+
- **内存：** 4GB+
- **磁盘空间：** 至少 10GB 可用空间

**推荐：** macOS 12+（Monterey 或更高）

---

## 🎯 适用场景

- ✅ 换新 Mac 电脑
- ✅ 重新安装 macOS
- ✅ 从工作电脑迁移到个人电脑
- ✅ 从个人电脑迁移到工作电脑
- ✅ 定期备份开发环境

---

## 🔒 安全说明

- **SSH 密钥**：安全备份，权限设置为 600
- **API 密钥**：加密存储，建议妥善保管
- **敏感信息**：不会上传到任何服务器
- **本地运行**：所有数据都在你的电脑上处理

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

---

## 📝 开源协议

本项目采用 MIT License 开源协议。

这意味着你可以：
- ✅ 自由使用
- ✅ 自由修改
- ✅ 自由分发
- ✅ 用于商业用途

---

## 🌟 支持的项目类型

这个工具特别适合以下项目类型：

### 🤖 AI/ML 项目
- Python 项目（自动备份 requirements.txt）
- Node.js 项目（自动备份 package.json）
- Jupyter Notebooks
- 数据科学项目

### 🎨 创意工具项目
- 视频处理（FFmpeg 集成）
- 图像处理（Pillow 集成）
- 内容生成项目

### 📱 内容创作项目
- 微信公众号工具
- 小红书内容生成
- 播客工具
- 视频剪辑工具

---

## 📊 项目统计

- **总文件数：** 50+
- **支持语言：** Bash、Python、JavaScript
- **文档数量：** 8 篇

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
- 🐛 [报告问题](https://github.com/alanlyu914-tech/macos-backup-restore/issues)
- 💬 [讨论交流](https://github.com/alanlyu914-tech/macos-backup-restore/discussions)

---

## 📧 联系方式

- **作者：** 大东
- **GitHub：** [@alanlyu914-tech](https://github.com/alanlyu914-tech)
- **项目：** [macos-backup-restore](https://github.com/alanlyu914-tech/macos-backup-restore)

---

**🎉 祝你迁移顺利！**

*让 Mac 电脑迁移变得简单！*
