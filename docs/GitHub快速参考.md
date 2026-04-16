# GitHub 快速参考

> 常用命令和配置，快速查找

## ⚡ 最常用命令

```bash
# 提交代码（完整流程）
cd ~/macos-backuprestore
git add .
git commit -m "更新说明"
git push origin main

# 拉取最新代码
git pull origin main

# 查看状态
git status

# 查看提交历史
git log --oneline -10
```

## 👤 身份信息

```
用户名: alanlyu914-tech
显示名: 大东
邮箱: alanlyu914@gmail.com
```

## 🔧 一键配置

```bash
# 配置 Git 用户
git config --global user.name "大东"
git config --global user.email "alanlyu914@gmail.com"

# 验证 SSH 连接
ssh -T git@github.com
```

## 📦 主仓库

```
SSH: git@github.com:alanlyu914-tech/macos-backuprestore.git
HTTPS: https://github.com/alanlyu914-tech/macos-backuprestore.git
本地: ~/macos-backuprestore
```

## 🗝️ SSH 密钥

```bash
# 生成密钥
ssh-keygen -t ed25519 -C "alanlyu914@gmail.com" -f ~/.ssh/id_ed25519 -N ""

# 查看公钥
cat ~/.ssh/id_ed25519.pub

# 测试连接
ssh -T git@github.com
```

## 🔗 重要链接

| 用途 | 链接 |
|------|------|
| GitHub 主页 | https://github.com/alanlyu914-tech |
| 主仓库 | https://github.com/alanlyu914-tech/macos-backuprestore |
| Settings | https://github.com/settings |
| SSH Keys | https://github.com/settings/keys |
| 新建仓库 | https://github.com/new |

---

**快速访问：**
- 配置文件: `~/macos-backuprestore/docs/GitHub配置说明.md`
- 仓库信息: `~/macos-backuprestore/docs/GitHub仓库信息.md`
