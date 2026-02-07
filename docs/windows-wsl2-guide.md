# Windows 10 Pro - WSL2 + Ubuntu 完整指南

## 📋 目錄
1. [前置要求](#前置要求)
2. [WSL2 安裝](#wsl2-安裝)
3. [Ubuntu 設置](#ubuntu-設置)
4. [OpenClaw 部署](#openclaw-部署)
5. [VS Code 整合](#vs-code-整合)
6. [常見問題](#常見問題)
7. [效能優化](#效能優化)

---

## 前置要求

### 系統要求
- **作業系統**: Windows 10 版本 20H2 或更新（Home/Pro/Enterprise 都支援）
- **CPU**: 支援虛擬化（Intel VT-x 或 AMD-V）
- **RAM**: 4GB 最小，8GB 或以上推薦
- **磁碟**: 20GB 可用空間（Ubuntu + 應用）

### 檢查 Windows 版本

按 `Win + R`，輸入 `winver` 查看版本號。需要 20H2 或更新。

---

## WSL2 安裝

### 步驟 1：啟用 Windows 功能

以**管理員身份**打開 PowerShell：

```powershell
# 啟用 WSL 功能
dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart

# 啟用虛擬機平台
dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart

# 重啟電腦
Restart-Computer
```

### 步驟 2：設置 WSL 預設版本

重啟後，以管理員身份打開 PowerShell：

```powershell
# 設定 WSL 2 為預設版本
wsl --set-default-version 2

# 驗證
wsl --list --verbose
```

### 步驟 3：安裝 Linux 內核更新

1. 下載 [WSL 2 Linux 內核](https://wslstorestorage.blob.core.windows.net/wslblob/wsl_update_x64.msi)
2. 執行安裝程式

---

## Ubuntu 設置

### 步驟 1：安裝 Ubuntu 22.04 LTS

在 PowerShell 中執行：

```powershell
# 列出可用的 Linux 發行版
wsl --list --online

# 安裝 Ubuntu 22.04
wsl --install -d Ubuntu-22.04

# 首次啟動會要求設置用戶名和密碼
```

### 步驟 2：初始化 Ubuntu 環境

在 Ubuntu 終端中執行（首次啟動會自動打開）：

```bash
# 更新系統
sudo apt update
sudo apt upgrade -y

# 安裝必要工具
sudo apt install -y \
  curl \
  wget \
  git \
  build-essential \
  python3-pip \
  apt-transport-https \
  ca-certificates \
  software-properties-common

# 設置時區
sudo timedatectl set-timezone Asia/Taipei
```

### 步驟 3：設置 WSL 配置（可選）

編輯 Windows 上的 `.wslconfig` 文件：

1. 按 `Win + R`，輸入 `%USERPROFILE%` 進入用戶主目錄
2. 在此目錄下新建 `.wslconfig` 文件
3. 編輯以下內容：

```ini
[interop]
enabled=true
appendWindowsPath=true

[wsl2]
# 分配內存（調整為你的 RAM）
memory=4GB
# 分配 CPU 核心數
processors=4
# 虛擬磁碟大小
localhostForwarding=true

[boot]
systemd=true
```

重啟 WSL：
```powershell
wsl --shutdown
wsl
```

---

## OpenClaw 部署

### 步驟 1：在 Ubuntu 中克隆專案

在 Ubuntu 終端中執行：

```bash
# 導航到主目錄
cd ~

# 克隆 OpenClaw 專案
git clone https://github.com/miaoxworld/OpenClawInstaller.git
cd OpenClawInstaller

# 列出文件
ls -la
```

### 步驟 2：執行安裝腳本

```bash
# 確保腳本有執行權限
chmod +x install.sh config-menu.sh

# 執行安裝
./install.sh
```

安裝腳本會執行以下操作：
- ✅ 檢查系統要求
- ✅ 安裝 Node.js v22+
- ✅ 安裝必要的系統依賴
- ✅ 安裝 OpenClaw CLI
- ✅ 設置配置目錄 `~/.openclaw/`
- ✅ 配置服務啟動

### 步驟 3：配置 API 密鑰

編輯配置文件：

```bash
nano ~/.openclaw/env
```

配置以下 API 密鑰：

```bash
# Anthropic Claude
ANTHROPIC_API_KEY="sk-ant-..."

# OpenAI GPT
OPENAI_API_KEY="sk-..."

# Google Gemini
GOOGLE_API_KEY="AIzaSy..."

# Telegram（可選）
TELEGRAM_BOT_TOKEN="123456789:ABCdefGHIjklmnoPQRstUvwxyz..."

# 其他配置
PORT=18789
HOST=0.0.0.0
LOG_LEVEL=info
```

### 步驟 4：啟動服務

```bash
# 啟動 OpenClaw 守護程序
openclaw gateway start

# 查看狀態
openclaw gateway status

# 查看日誌
tail -f ~/.openclaw/logs/openclaw.log
```

### 步驟 5：驗證部署

```bash
# 測試 API 端點
curl http://localhost:18789/health

# 在 Windows 上也可以訪問（如果已配置）
# http://localhost:18789
```

---

## VS Code 整合

### 步驟 1：安裝 Remote - WSL 擴展

1. 在 VS Code 中打開擴展市場
2. 搜索 "Remote - WSL"
3. 安裝 Microsoft 提供的官方擴展

### 步驟 2：連接到 WSL

1. 按 `Ctrl + Shift + P`
2. 搜索 "Remote-WSL: New Window"
3. VS Code 會在 WSL 環境中打開新窗口

### 步驟 3：在 WSL 中編輯專案

```bash
# 在 VS Code 中打開 OpenClaw 目錄
code ~/OpenClawInstaller
```

### 進階設置

編輯 `.wsl.config`（VS Code 用戶設置）：

```json
{
  "remote.WSL.debug": true,
  "files.watcherExclude": {
    "**/node_modules": true,
    "**/.openclaw": true
  }
}
```

---

## 常見問題

### Q1：無法啟用 WSL

**解決：**
1. 確認 Windows 版本 ≥ 20H2
2. 檢查 Hyper-V 是否被禁用
3. 某些防毒軟體可能干擾：暫時停用或添加例外

### Q2：Ubuntu 安裝很慢

**解決：**
1. 更換 APT 源到更快的鏡像
2. 編輯 `/etc/apt/sources.list`
3. 將 `archive.ubuntu.com` 改為本地鏡像

```bash
sudo sed -i 's/archive.ubuntu.com/tw.archive.ubuntu.com/g' /etc/apt/sources.list
sudo apt update
```

### Q3：無法使用 sudo 而不輸入密碼

```bash
# 編輯 sudoers 文件
sudo visudo

# 在末尾添加（將 username 替換為你的用戶名）
username ALL=(ALL) NOPASSWD:ALL
```

### Q4：OpenClaw 無法啟動

**檢查日誌：**
```bash
tail -f ~/.openclaw/logs/openclaw.log

# 檢查服務狀態
openclaw gateway status

# 重新安裝
./install.sh --reinstall
```

### Q5：無法從 Windows 訪問 Ubuntu 中的端口

確保 `.wslconfig` 中設置了：
```ini
[interop]
enabled=true
```

並重啟 WSL。

### Q6：WSL 佔用磁碟空間過大

```bash
# 檢查磁碟使用
df -h

# 清理 APT 快取
sudo apt clean
sudo apt autoclean

# Windows 上壓縮虛擬磁碟
diskpart
# 輸入：
# list vdisk
# select vdisk file="C:\Users\<username>\AppData\Local\Packages\CanonicalGroupLimited.Ubuntu22.04LTS_79rhkp1fndgsc\LocalState\ext4.vhdx"
# compact vdisk
```

---

## 效能優化

### 1. 提升記憶體分配

編輯 `.wslconfig`：
```ini
[wsl2]
memory=8GB
processors=8
```

### 2. 使用原生 Linux 工具鏈

在 WSL 中而非 Windows PowerShell 中開發：
- 更快的文件系統操作
- 原生 Git/Node.js 性能

### 3. 將項目存放在 WSL 文件系統

```bash
# ✅ 推薦：在 WSL 中操作
cd ~
git clone https://github.com/miaoxworld/OpenClawInstaller.git

# ❌ 不推薦：從 Windows 路徑操作
# /mnt/c/... 速度較慢
```

### 4. 啟用 systemd（可選）

在 `.wslconfig` 中添加：
```ini
[boot]
systemd=true
```

這樣可以使用 `systemctl` 管理服務：
```bash
sudo systemctl start openclaw
sudo systemctl status openclaw
sudo systemctl stop openclaw
```

### 5. 優化虛擬磁碟

```bash
# 定期清理未使用的包
sudo apt autoremove -y
sudo apt clean

# 清空日誌
sudo journalctl --vacuum=7d
```

---

## Windows 和 WSL 之間的檔案共享

### 從 Windows 訪問 Ubuntu 文件

```powershell
# 打開文件管理器並導航到
\\wsl$\Ubuntu-22.04\home\<username>
```

### 從 Ubuntu 訪問 Windows 文件

```bash
# Windows C: 盤掛載在 /mnt/c
cd /mnt/c/Users/<username>/Documents

# 或簡單地
ls /mnt/c/
```

### 設置符號鏈接

```bash
# 創建快速訪問鏈接
ln -s /mnt/c/Users/$(whoami)/Documents ~/Windows-Docs
```

---

## 備份和恢復

### 備份 Ubuntu 環境

```powershell
# 導出 WSL 發行版為備份
wsl --export Ubuntu-22.04 C:\Backups\Ubuntu-22.04-backup.tar
```

### 恢復 Ubuntu 環境

```powershell
# 如果需要恢復
wsl --import Ubuntu-22.04 C:\WSL\Ubuntu C:\Backups\Ubuntu-22.04-backup.tar --version 2
```

---

## 日常命令參考

```powershell
# PowerShell 命令

# 列出已安裝的發行版
wsl --list --verbose

# 啟動 Ubuntu
wsl -d Ubuntu-22.04

# 從 Windows 執行 Ubuntu 命令
wsl -d Ubuntu-22.04 -e bash -ic "openclaw gateway status"

# 關閉 WSL
wsl --shutdown

# 卸載發行版
wsl --unregister Ubuntu-22.04
```

```bash
# Ubuntu 命令

# 啟動 OpenClaw
openclaw gateway start

# 停止 OpenClaw
openclaw gateway stop

# 查看狀態
openclaw gateway status

# 查看日誌
tail -f ~/.openclaw/logs/openclaw.log

# 進入配置菜單
bash ~/.openclaw/config-menu.sh

# 系統信息
neofetch
```

---

## 與 Docker 的比較

| 特性 | WSL2 | Docker |
|------|------|--------|
| **啟動速度** | 快 | 稍慢 |
| **資源使用** | 低 | 中等 |
| **開發體驗** | 原生 Linux | 隔離環境 |
| **IDE 整合** | 優秀（VS Code） | 良好 |
| **部署** | 簡單 | 標準化 |
| **適合場景** | 開發 + 部署 | 多環境部署 |

---

## 下一步

1. ✅ 在 WSL2 中部署 OpenClaw
2. 📱 設置 Telegram/Discord 機器人
3. 🎯 編寫自訂技能和工作流程
4. 🔧 整合 VS Code 進行開發
5. 📊 配置日誌和監控

查看 [主 README](../README.md) 了解更多功能。
