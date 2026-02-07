# Windows 10 Pro - OpenClaw 完整設置指南

## 🎯 三個部署方案對比

| 特性 | Docker | WSL2 + Ubuntu | 原生 Windows |
|------|--------|--------------|-------------|
| **難度** | ⭐ 最簡單 | ⭐⭐ 簡單 | ⭐⭐⭐ 中等 |
| **安裝時間** | 10-15分鐘 | 15-20分鐘 | 10-15分鐘 |
| **性能** | 良好 | 優秀 | 最快 |
| **服務管理** | ✅ 自動 | ✅ systemd | ❌ 手動 |
| **IDE集成** | 一般 | ⭐ 優秀(VS Code) | 一般 |
| **穩定性** | ⭐ 推薦 | ⭐ 推薦 | ⚠️ 實驗性 |
| **適用場景** | 生產環境 | 開發環境 | 快速測試 |

---

## 📋 快速選擇

### 💡 我應該選哪一個？

**選擇 Docker，如果您：**
- ✅ 需要穩定的生產環境
- ✅ 不想安裝過多工具
- ✅ 希望簡單的容器管理
- ✅ 需要將應用遠程部署

**選擇 WSL2，如果您：**
- ✅ 需要完整的 Linux 開發環境
- ✅ 習慣使用 VS Code 開發
- ✅ 需要原生 bash 和 systemd
- ✅ 想要最佳的開發體驗

**選擇原生 Windows，如果您：**
- ⚠️ 只想快速測試
- ⚠️ 不想安裝額外的虛擬化層
- ⚠️ 願意手動管理服務
- ⚠️ 注意：此方案不完全支持

---

## 🚀 一鍵快速部署

### 方案 1：Docker（推薦）

```powershell
# 1. 安裝 Docker Desktop
# 訪問: https://www.docker.com/products/docker-desktop
# 下載並安裝，重啟電腦

# 2. 克隆專案
git clone https://github.com/miaoxworld/OpenClawInstaller.git
cd OpenClawInstaller

# 3. 啟動容器
docker-compose up -d

# 4. 等待啟動完成（1-2分鐘）
docker-compose logs -f

# 5. 訪問應用
# http://localhost:18789
```

⏱️ **總耗時：** 15 分鐘

📖 **詳細指南：** [windows-docker-guide.md](./windows-docker-guide.md)

---

### 方案 2：WSL2 + Ubuntu（推薦開發）

```powershell
# PowerShell (管理員)

# 1. 啟用 WSL
dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart
dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart
Restart-Computer

# 2. 安裝 Ubuntu
wsl --install -d Ubuntu-22.04

# 3. 在 Ubuntu 中執行
cd ~
git clone https://github.com/miaoxworld/OpenClawInstaller.git
cd OpenClawInstaller
chmod +x install.sh
./install.sh

# 4. 啟動服務
openclaw gateway start

# 5. 訪問應用
# http://localhost:18789
```

⏱️ **總耗時：** 20 分鐘

📖 **詳細指南：** [windows-wsl2-guide.md](./windows-wsl2-guide.md)

---

### 方案 3：原生 Windows（實驗性）

```powershell
# PowerShell (管理員)

# 1. 允許執行腳本
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser

# 2. 執行安裝腳本
.\install-openclaw.ps1

# 3. 編輯配置文件
notepad "$env:USERPROFILE\.openclaw\config.yaml"

# 4. 啟動服務
openclaw gateway start

# 5. 訪問應用
# http://localhost:18789
```

⏱️ **總耗時：** 10-15 分鐘

📖 **詳細指南：** [windows-native-guide.md](./windows-native-guide.md)

⚠️ **警告：** 此方案不完全支持，請查看已知限制

---

## 📚 完整指南文檔

### 1. [Windows Docker 部署指南](./windows-docker-guide.md)
適合想要快速、穩定部署的用戶

**內容包括：**
- Docker Desktop 安裝步驟
- docker-compose 配置
- API 密鑰配置
- 進階配置（Ollama、自訂技能）
- 常見問題排查

### 2. [Windows WSL2 + Ubuntu 指南](./windows-wsl2-guide.md)
適合開發者和需要完整 Linux 環境的用戶

**內容包括：**
- WSL2 安裝和初始化
- Ubuntu 22.04 設置
- 原生 install.sh 執行
- VS Code 整合
- 性能優化建議

### 3. [Windows 原生部署指南](./windows-native-guide.md)
適合想要在 Windows 上直接運行的用戶

**內容包括：**
- 手動安裝步驟
- PowerShell 自動化腳本
- Git Bash 支持
- 服務管理方案
- 已知限制說明

---

## 🔧 系統要求

所有方案都需要：
- **Windows 10 Pro** 版本 20H2+
- **4GB RAM** 最小（8GB 推薦）
- **10-20GB 磁碟空間**
- **管理員權限**

### 特定要求

| 方案 | 特定要求 |
|------|---------|
| Docker | Docker Desktop（~600MB） |
| WSL2 | WSL2 Linux 內核更新 |
| 原生 | Node.js v22 + Git（可選） |

---

## 📖 配置 API 密鑰

無論選擇哪個方案，都需要配置 API 密鑰。

### 配置文件位置

```
C:\Users\[用戶名]\.openclaw\config.yaml
```

### 支援的 AI 模型

```yaml
models:
  anthropic:
    api_key: "sk-ant-..."
    model: "claude-3-5-sonnet-20241022"

  openai:
    api_key: "sk-..."
    model: "gpt-4o"

  google:
    api_key: "AIzaSy..."
    model: "gemini-2.0-flash"

  groq:
    api_key: "gsk_..."
    model: "mixtral-8x7b-32768"

  ollama:  # 本地模型
    base_url: "http://ollama:11434"
    model: "llama2"
```

### 取得 API 密鑰

| 服務 | 網址 |
|------|------|
| Anthropic Claude | https://console.anthropic.com/keys |
| OpenAI | https://platform.openai.com/api-keys |
| Google Gemini | https://aistudio.google.com/apikey |
| Groq | https://console.groq.com/keys |

---

## ✅ 驗證安裝

### 檢查服務狀態

```powershell
# Docker
docker-compose ps

# WSL2
openclaw gateway status

# 原生 Windows
openclaw gateway status
```

### 測試 API 連接

```powershell
# 本地請求
curl http://localhost:18789/health

# 查看響應
# {"status": "ok", "uptime": 123}
```

### 查看日誌

```powershell
# Docker
docker-compose logs -f openclaw

# WSL2 / 原生 Windows
Get-Content "$env:USERPROFILE\.openclaw\logs\openclaw.log" -Wait
```

---

## 🐛 常見問題

### Q1：Docker 容器無法啟動

詳見 [Docker 指南 - 常見問題](./windows-docker-guide.md#常見問題)

### Q2：找不到 OpenClaw 配置文件

```powershell
# 檢查目錄是否存在
Test-Path "$env:USERPROFILE\.openclaw"

# 手動建立
mkdir "$env:USERPROFILE\.openclaw" -Force
```

### Q3：API 密鑰未被識別

確保配置文件格式正確（YAML）：
```powershell
# 使用 VS Code 編輯
code "$env:USERPROFILE\.openclaw\config.yaml"
```

### Q4：埠口 18789 已被佔用

```powershell
# 檢查佔用的進程
netstat -ano | findstr :18789

# 殺死進程
taskkill /PID [PID] /F

# 或更改埠口（在配置文件中）
```

### Q5：網路連接失敗

```powershell
# 檢查 DNS 和網路
Test-NetConnection google.com -Port 443

# 檢查防火牆
Test-NetConnection localhost -Port 18789
```

---

## 🔄 遷移方案

如果您已選擇一個方案，想切換到另一個：

### 備份配置
```powershell
# 備份配置文件
Copy-Item "$env:USERPROFILE\.openclaw" -Destination "$env:USERPROFILE\.openclaw.backup" -Recurse
```

### 清理舊安裝

**Docker 用戶：**
```powershell
docker-compose down
```

**WSL2 用戶：**
```bash
openclaw gateway stop
```

**原生 Windows 用戶：**
```powershell
npm uninstall -g openclaw
```

### 安裝新方案

按照相應的指南重新安裝。

---

## 📊 性能對比實際數據

| 項目 | Docker | WSL2 | 原生 |
|------|--------|------|------|
| 啟動時間 | 2-3s | 1-2s | 1s |
| 內存占用 | 300-400MB | 200-300MB | 150-200MB |
| 磁碟占用 | 1-2GB | 3-5GB | 500MB |
| CPU 使用率 | 5-10% | 2-5% | 1-3% |

*注：實際數據取決於硬體配置*

---

## 🆘 獲得幫助

### 查看日誌
所有方案都在此位置保存日誌：
```
C:\Users\[用戶名]\.openclaw\logs\openclaw.log
```

### 官方資源
- 📖 [GitHub Repository](https://github.com/miaoxworld/OpenClawInstaller)
- 📝 [主 README](../README.md)
- 🎯 [技能示例](../examples/skills/)

### 常見錯誤信息

| 錯誤 | 原因 | 解決 |
|------|------|------|
| `node: command not found` | Node.js 未安裝 | 安裝 Node.js v22+ |
| `docker: command not found` | Docker 未安裝或不在 PATH | 安裝 Docker Desktop |
| `Permission denied` | 缺少管理員權限 | 以管理員身份執行 |
| `Port 18789 in use` | 埠口被佔用 | 更改埠口或殺死佔用進程 |
| `YAML parsing error` | 配置文件格式錯誤 | 檢查 YAML 語法 |

---

## 🎓 學習資源

- [Node.js 官方文檔](https://nodejs.org/)
- [Docker 官方教程](https://docs.docker.com/)
- [WSL2 官方指南](https://learn.microsoft.com/en-us/windows/wsl/)
- [OpenClaw GitHub](https://github.com/miaoxworld/OpenClawInstaller)

---

## 📞 支援

若遇到問題，請：

1. 查看相應指南的**常見問題**部分
2. 檢查[GitHub Issues](https://github.com/miaoxworld/OpenClawInstaller/issues)
3. 查看詳細的日誌輸出
4. 提供以下信息提交反饋：
   - Windows 版本（`winver`）
   - 選擇的部署方案
   - 完整的錯誤信息
   - 日誌輸出

---

## 📝 下一步

部署完成後：

1. ✅ 部署完成
2. 📝 配置 API 密鑰
3. 🤖 設置 AI 模型
4. 📱 連接 Telegram/Discord 機器人
5. 🎯 編寫自訂技能
6. 📊 配置日誌和監控

詳見 [主 README](../README.md) 了解如何使用 OpenClaw 的各項功能。

---

**最後更新：** 2026年2月7日
**版本：** 1.0.0
