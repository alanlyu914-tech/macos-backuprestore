# GitHub 仓库信息

> 快速查找你的 GitHub 仓库和配置信息

## 👤 个人信息

```
GitHub 用户名: alanlyu914-tech
显示名称: 大东
邮箱: alanlyu914@gmail.com
微信: dadongalan
```

## 📦 主仓库

### macos-backuprestore
```
用途: macOS迁移备份工具
仓库: git@github.com:alanlyu914-tech/macos-backuprestore.git
HTTPS: https://github.com/alanlyu914-tech/macos-backuprestore
本地路径: ~/macos-backuprestore
分支: main
```

## 🔧 常用命令

### 克隆仓库
```bash
# SSH 方式（推荐）
git clone git@github.com:alanlyu914-tech/macos-backuprestore.git

# HTTPS 方式
git clone https://github.com/alanlyu914-tech/macos-backuprestore.git
```

### 提交流程
```bash
cd ~/macos-backuprestore

# 查看修改
git status

# 添加文件
git add .

# 提交
git commit -m "描述你的修改"

# 推送
git push origin main
```

### 拉取最新代码
```bash
git pull origin main
```

### 查看远程仓库
```bash
git remote -v
```

## 🗝️ SSH 密钥配置

### 生成新密钥（如果需要）
```bash
ssh-keygen -t ed25519 -C "alanlyu914@gmail.com" -f ~/.ssh/id_ed25519 -N ""
```

### 查看公钥
```bash
cat ~/.ssh/id_ed25519.pub
```

### 添加到 GitHub
1. 访问: https://github.com/settings/ssh/new
2. 标题填写: macOS备份电脑
3. 粘贴公钥内容
4. 点击 Add SSH key

### 测试连接
```bash
ssh -T git@github.com
```

## 📝 Git 配置

### 全局配置
```bash
git config --global user.name "大东"
git config --global user.email "alanlyu914@gmail.com"
```

### 查看配置
```bash
git config --global user.name
git config --global user.email
```

## 🌟 GitHub Pages（如果需要）

### 启用 GitHub Pages
1. 访问仓库设置: https://github.com/alanlyu914-tech/macos-backuprestore/settings/pages
2. Source 选择: main branch
3. 保存后访问: https://alanlyu914-tech.github.io/macos-backuprestore/

## 📊 仓库统计

### 查看仓库信息
```bash
# 查看提交历史
git log --oneline

# 查看分支
git branch -a

# 查看远程
git remote -v

# 查看最近提交
git log -1 --stat
```

## 🔗 有用的链接

- GitHub 主页: https://github.com/alanlyu914-tech
- 主仓库: https://github.com/alanlyu914-tech/macos-backuprestore
- Settings: https://github.com/settings
- 仓库 Settings: https://github.com/alanlyu914-tech/macos-backuprestore/settings
- SSH Keys: https://github.com/settings/keys
- 个人资料: https://github.com/alanlyu914-tech

## 📋 检查清单

迁移后检查这些项目：

- [ ] Git 全局配置已设置
- [ ] SSH 密钥已恢复
- [ ] SSH 连接测试成功
- [ ] 主仓库已克隆
- [ ] 远程仓库地址正确
- [ ] 可以拉取和推送代码

## 🆘 常见问题

### Q: 推送时提示权限错误？
A: 检查 SSH 密钥是否正确配置，运行 `ssh -T git@github.com` 测试

### Q: 提交者信息不对？
A: 运行 `git config --global user.name "大东"` 和 `git config --global user.email "alanlyu914@gmail.com"`

### Q: 忘记仓库地址？
A: 查看本文档顶部的主仓库信息

### Q: 如何创建新仓库？
A: 访问 https://github.com/new，按照提示创建，然后使用本文档的命令添加远程仓库

---

**最后更新：** 2026-04-16
**版本：** 1.0
