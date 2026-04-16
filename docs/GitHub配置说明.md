# GitHub 配置说明

> 迁移后快速恢复 GitHub 开发环境

## 📋 基本信息

- **GitHub用户名：** alanlyu914-tech
- **作者显示名：** 大东
- **邮箱：** alanlyu914@gmail.com
- **主仓库：** https://github.com/alanlyu914-tech/macos-backuprestore

## 🔑 Git 配置

### 全局配置
```bash
git config --global user.name "大东"
git config --global user.email "alanlyu914@gmail.com"
```

### 仓库配置（如果需要不同的配置）
```bash
cd ~/macos-backuprestore
git config user.name "大东"
git config user.email "alanlyu914@gmail.com"
```

## 🗝️ SSH 密钥

### SSH 密钥信息
- **类型：** ED25519
- **密钥文件：** ~/.ssh/id_ed25519
- **公钥已添加到 GitHub：** 是
- **密钥标题（GitHub上）：** macOS备份电脑

### 验证 SSH 连接
```bash
ssh -T git@github.com
```

如果看到：
```
Hi alanlyu914-tech! You've successfully authenticated...
```
说明 SSH 配置正确。

## 📦 常用仓库

### 主仓库
```bash
# 克隆
git clone git@github.com:alanlyu914-tech/macos-backuprestore.git

# 或使用 HTTPS
git clone https://github.com/alanlyu914-tech/macos-backuprestore.git
```

### 添加远程仓库
```bash
# SSH 方式（推荐，已配置密钥）
git remote add origin git@github.com:alanlyu914-tech/仓库名.git

# HTTPS 方式
git remote add origin https://github.com/alanlyu914-tech/仓库名.git
```

## 🚀 常用操作

### 提交代码
```bash
# 1. 查看状态
git status

# 2. 添加文件
git add .
# 或添加特定文件
git add README.md

# 3. 提交
git commit -m "提交说明"

# 4. 推送
git push origin main
```

### 创建新仓库并推送
```bash
# 1. 在 GitHub 创建新仓库（名为 new-repo）

# 2. 初始化本地仓库
cd ~/path/to/project
git init
git add .
git commit -m "Initial commit"

# 3. 添加远程仓库
git remote add origin git@github.com:alanlyu914-tech/new-repo.git

# 4. 推送
git branch -M main
git push -u origin main
```

## 🔧 故障排除

### 问题：SSH 连接失败
```bash
# 检查 SSH 密钥是否存在
ls -la ~/.ssh/id_ed25519*

# 如果不存在，需要重新生成
ssh-keygen -t ed25519 -C "alanlyu914@gmail.com"
```

### 问题：推送被拒绝
```bash
# 如果远程有新的提交
git pull origin main --rebase

# 然后再推送
git push origin main
```

### 问题：提交者信息不对
```bash
# 检查配置
git config user.name
git config user.email

# 修改配置
git config user.name "大东"
git config user.email "alanlyu914@gmail.com"
```

## 📝 GitHub 个人信息

### GitHub 个人资料
- **显示名：** 大东
- **用户名：** alanlyu914-tech
- **邮箱：** alanlyu914@gmail.com
- **微信：** dadongalan

### 联系方式设置（GitHub Settings）
1. 访问：https://github.com/settings/profile
2. 设置显示名：大东
3. 设置公开邮箱：alanlyu914@gmail.com
4. 设置简介：（可选）

## 🎯 快速恢复步骤

迁移后按以下步骤恢复 GitHub 环境：

1. **恢复 Git 配置**
   ```bash
   git config --global user.name "大东"
   git config --global user.email "alanlyu914@gmail.com"
   ```

2. **验证 SSH 密钥**
   ```bash
   ssh -T git@github.com
   ```

3. **克隆主仓库**
   ```bash
   git clone git@github.com:alanlyu914-tech/macos-backuprestore.git
   cd macos-backuprestore
   ```

4. **开始工作**
   ```bash
   # 创建新分支
   git checkout -b feature/new-feature

   # 进行修改...
   # 提交并推送
   git add .
   git commit -m "Add new feature"
   git push origin feature/new-feature
   ```

## 📚 相关链接

- GitHub 主页：https://github.com/alanlyu914-tech
- 主仓库：https://github.com/alanlyu914-tech/macos-backuprestore
- GitHub Settings：https://github.com/settings
- SSH Keys 设置：https://github.com/settings/keys
