# Windows 10 Pro - 原生支援方案（實驗性）

## ⚠️ 重要警告

此方案處於**實驗性階段**，不如 Docker 或 WSL2 穩定。以下問題可能出現：
- 部分 OpenClaw 功能在 Windows 上可能不完全支援
- 文件路徑和權限管理需要手動配置
- 服務管理無法使用標準 systemd
- Git Bash 環境可能存在兼容性問題

**強烈推薦使用 Docker 或 WSL2 方案**。

---

## 📋 目錄
1. [系統要求](#系統要求)
2. [手動安裝步驟](#手動安裝步驟)
3. [PowerShell 安裝腳本](#powershell-安裝腳本)
4. [Git Bash 支援](#git-bash-支援)
5. [服務管理](#服務管理)
6. [已知限制](#已知限制)

---

## 系統要求

### 必需軟體
- **Windows 10 Pro** 版本 20H2 或更新
- **Node.js v22 或更新**（從官方安裝）
- **Git for Windows**（含 Git Bash）
- **npm**（隨 Node.js 自動安裝）

### 硬體要求
- RAM: 4GB 最小，8GB 推薦
- 磁碟: 5GB 可用空間
- 管理員權限

---

## 手動安裝步驟

### 步驟 1：安裝 Node.js

1. 訪問 [Node.js 官方網站](https://nodejs.org/)
2. 下載 **v22 LTS** 64-bit MSI 安裝程式
3. 執行安裝程式，勾選：
   - ✅ Node.js runtime
   - ✅ npm package manager
   - ✅ Add to PATH
4. 重啟電腦

驗證安裝：
```powershell
node --version
npm --version
```

### 步驟 2：安裝 Git for Windows

1. 訪問 [Git 官方網站](https://git-scm.com/download/win)
2. 下載並執行安裝程式
3. 安裝時選擇：
   - ✅ Git Bash
   - ✅ Add Git to PATH

驗證安裝：
```powershell
git --version
```

### 步驟 3：建立工作目錄

```powershell
# 建立工作目錄
$ClawDir = "C:\OpenClaw"
mkdir $ClawDir -Force
cd $ClawDir
```

### 步驟 4：克隆或下載專案

**方法 A：使用 Git（推薦）**
```powershell
git clone https://github.com/miaoxworld/OpenClawInstaller.git
cd OpenClawInstaller
```

**方法 B：手動下載**
1. 訪問 GitHub 儲存庫
2. 點擊 Code → Download ZIP
3. 解壓到 `C:\OpenClaw\`

### 步驟 5：建立配置目錄

```powershell
# 建立 .openclaw 目錄
$OpenClawHome = "$env:USERPROFILE\.openclaw"
mkdir $OpenClawHome -Force
mkdir "$OpenClawHome\logs" -Force
mkdir "$OpenClawHome\data" -Force
mkdir "$OpenClawHome\skills" -Force
mkdir "$OpenClawHome\credentials" -Force

# 複製配置範例
Copy-Item "examples\config.example.yaml" -Destination "$OpenClawHome\config.yaml"
```

### 步驟 6：安裝 OpenClaw CLI

```powershell
# 全域安裝 OpenClaw
npm install -g openclaw

# 驗證安裝
openclaw --version
```

### 步驟 7：配置 API 密鑰

編輯配置文件：
```powershell
# 使用 Notepad 或喜歡的編輯器
notepad "$env:USERPROFILE\.openclaw\config.yaml"
```

或使用 PowerShell：
```powershell
# 添加環境變數（可選，優先級高於配置文件）
[Environment]::SetEnvironmentVariable("ANTHROPIC_API_KEY", "sk-ant-...", "User")
[Environment]::SetEnvironmentVariable("OPENAI_API_KEY", "sk-...", "User")
```

重啟 PowerShell 以使環境變數生效。

---

## PowerShell 安裝腳本

### 建立腳本

在 PowerShell 中以**管理員身份**執行以下命令建立腳本：

```powershell
# 允許執行遠端腳本
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser

# 建立腳本目錄
mkdir C:\Scripts -Force
cd C:\Scripts
```

複製以下內容到 `install-openclaw.ps1`：

```powershell
# ============================================================
# OpenClaw Windows 安裝腳本 (PowerShell)
# ============================================================

param(
    [string]$InstallDir = "C:\OpenClaw",
    [string]$NodeVersion = "22"
)

# 顏色定義
$Green = @{ ForegroundColor = 'Green' }
$Red = @{ ForegroundColor = 'Red' }
$Yellow = @{ ForegroundColor = 'Yellow' }

function Write-Success { Write-Host @Green @args }
function Write-Error { Write-Host @Red @args }
function Write-Warning { Write-Host @Yellow @args }

function Check-Admin {
    $identity = [System.Security.Principal.WindowsIdentity]::GetCurrent()
    $principal = New-Object System.Security.Principal.WindowsPrincipal($identity)
    if (-not $principal.IsInRole([System.Security.Principal.WindowsBuiltInRole]::Administrator)) {
        Write-Error "❌ 此腳本需要管理員權限。請以管理員身份執行。"
        exit 1
    }
    Write-Success "✅ 已確認管理員權限"
}

function Check-Node {
    try {
        $version = node --version
        Write-Success "✅ Node.js 已安裝: $version"

        # 檢查版本
        $major = [int]($version -replace 'v(\d+).*', '$1')
        if ($major -lt 22) {
            Write-Error "❌ Node.js 版本過舊。需要 v22 或更新，目前為 $version"
            Write-Warning "⚠️  請從 https://nodejs.org 下載 v22 LTS"
            exit 1
        }
    }
    catch {
        Write-Error "❌ Node.js 未安裝或未在 PATH 中"
        Write-Warning "⚠️  請從 https://nodejs.org 下載並安裝 v$NodeVersion LTS"
        exit 1
    }
}

function Check-Git {
    try {
        $version = git --version
        Write-Success "✅ Git 已安裝: $version"
    }
    catch {
        Write-Warning "⚠️  Git 未安裝。若需要版本控制，請安裝 Git for Windows"
    }
}

function Create-Directories {
    $OpenClawHome = "$env:USERPROFILE\.openclaw"

    $dirs = @(
        $InstallDir,
        "$OpenClawHome\logs",
        "$OpenClawHome\data",
        "$OpenClawHome\skills",
        "$OpenClawHome\credentials"
    )

    foreach ($dir in $dirs) {
        if (-not (Test-Path $dir)) {
            New-Item -ItemType Directory -Path $dir -Force | Out-Null
            Write-Success "✅ 建立目錄: $dir"
        }
    }
}

function Clone-Repository {
    if (-not (Test-Path "$InstallDir\OpenClawInstaller")) {
        Write-Warning "⏳ 正在克隆 OpenClaw 儲存庫..."

        try {
            git clone https://github.com/miaoxworld/OpenClawInstaller.git "$InstallDir\OpenClawInstaller"
            Write-Success "✅ 克隆完成"
        }
        catch {
            Write-Error "❌ 克隆失敗。請手動下載或確保 Git 已安裝"
            exit 1
        }
    }
    else {
        Write-Success "✅ 專案目錄已存在"
    }
}

function Copy-Config {
    $OpenClawHome = "$env:USERPROFILE\.openclaw"
    $configSource = "$InstallDir\OpenClawInstaller\examples\config.example.yaml"
    $configDest = "$OpenClawHome\config.yaml"

    if (-not (Test-Path $configDest) -and (Test-Path $configSource)) {
        Copy-Item $configSource -Destination $configDest
        Write-Success "✅ 配置文件已建立: $configDest"
    }
    else {
        Write-Warning "⚠️  配置文件已存在或源文件不存在"
    }
}

function Install-OpenClaw {
    Write-Warning "⏳ 正在安裝 OpenClaw CLI..."

    try {
        npm install -g openclaw
        Write-Success "✅ OpenClaw CLI 安裝完成"
    }
    catch {
        Write-Error "❌ 安裝失敗: $_"
        exit 1
    }
}

function Show-NextSteps {
    Write-Host ""
    Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" @Green
    Write-Host "🦞 OpenClaw 安裝完成！" @Green
    Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" @Green
    Write-Host ""
    Write-Host "📝 後續步驟:"
    Write-Host ""
    Write-Host "1️⃣  編輯配置文件:"
    Write-Host "   notepad `"$env:USERPROFILE\.openclaw\config.yaml`""
    Write-Host ""
    Write-Host "2️⃣  添加 API 密鑰 (Anthropic, OpenAI, Gemini 等)"
    Write-Host ""
    Write-Host "3️⃣  啟動 OpenClaw (在 PowerShell 或 Git Bash 中):"
    Write-Host "   openclaw gateway start"
    Write-Host ""
    Write-Host "4️⃣  查看狀態:"
    Write-Host "   openclaw gateway status"
    Write-Host ""
    Write-Host "5️⃣  查看日誌:"
    Write-Host "   Get-Content `"$env:USERPROFILE\.openclaw\logs\openclaw.log`" -Tail 50 -Wait"
    Write-Host ""
    Write-Host "📚 更多命令:"
    Write-Host "   openclaw --help"
    Write-Host ""
    Write-Host "💡 若需要其他功能，可在配置文件中啟用:"
    Write-Host "   - Telegram/Discord 機器人"
    Write-Host "   - 自訂技能和工作流程"
    Write-Host "   - 本地模型 (Ollama)"
    Write-Host ""
}

# 主安裝流程
Write-Host ""
Write-Host "🦞 OpenClaw Windows 安裝程式" @Green
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" @Green
Write-Host ""

Check-Admin
Check-Node
Check-Git
Create-Directories
Clone-Repository
Copy-Config
Install-OpenClaw

Show-NextSteps
Write-Host "✨ 安裝成功！" @Green
```

### 執行腳本

```powershell
# 允許執行腳本
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser -Force

# 執行安裝
C:\Scripts\install-openclaw.ps1

# 若要自訂安裝路徑
C:\Scripts\install-openclaw.ps1 -InstallDir "D:\Applications\OpenClaw"
```

---

## Git Bash 支援

### 在 Git Bash 中運行

1. 右鍵點擊資料夾，選擇 "Open Git Bash here"
2. 執行以下命令：

```bash
# 進入 OpenClaw 目錄
cd /c/OpenClaw/OpenClawInstaller

# 安裝 OpenClaw
npm install -g openclaw

# 啟動
openclaw gateway start

# 查看狀態
openclaw gateway status
```

### Git Bash 的注意事項

- 路徑使用 `/c/` 而非 `C:\`
- 某些命令可能不相容
- 建議使用 PowerShell 或 WSL2 進行開發

---

## 服務管理

### ⚠️ Windows 限制

Windows **不支援 systemd**。OpenClaw 在 Windows 上無法作為系統服務自動啟動。

### 替代方案 1：PowerShell 計劃工作

```powershell
# 建立計劃工作在系統啟動時啟動 OpenClaw
$action = New-ScheduledTaskAction -Execute "openclaw" -Argument "gateway start"
$trigger = New-ScheduledTaskTrigger -AtStartup
Register-ScheduledTask -Action $action -Trigger $trigger -TaskName "OpenClaw" -Description "Start OpenClaw Gateway"

# 查看任務
Get-ScheduledTask -TaskName "OpenClaw"

# 刪除任務
Unregister-ScheduledTask -TaskName "OpenClaw" -Confirm:$false
```

### 替代方案 2：NSSM（Non-Sucking Service Manager）

1. 下載 [NSSM](https://nssm.cc/download)
2. 解壓到 `C:\nssm\`
3. 在 PowerShell 中執行：

```powershell
# 建立服務
C:\nssm\win64\nssm.exe install OpenClaw openclaw gateway start

# 啟動服務
nssm start OpenClaw

# 停止服務
nssm stop OpenClaw

# 查看日誌
Get-Content "C:\nssm\OpenClaw.log" -Tail 50
```

### 替代方案 3：簡單批處理文件

建立 `start-openclaw.bat`：

```batch
@echo off
cd %USERPROFILE%
openclaw gateway start
pause
```

雙擊執行即可啟動。

---

## 配置和日誌

### 配置文件位置

```
C:\Users\[用戶名]\.openclaw\config.yaml
```

### 編輯配置

```powershell
# 使用記事本
notepad "$env:USERPROFILE\.openclaw\config.yaml"

# 或使用 VS Code
code "$env:USERPROFILE\.openclaw\config.yaml"
```

### 查看日誌

```powershell
# 即時查看日誌
Get-Content "$env:USERPROFILE\.openclaw\logs\openclaw.log" -Wait

# 最後 50 行
Get-Content "$env:USERPROFILE\.openclaw\logs\openclaw.log" -Tail 50

# 搜尋錯誤
Select-String -Path "$env:USERPROFILE\.openclaw\logs\*.log" -Pattern "ERROR"
```

---

## 已知限制

### 1. 服務管理
❌ 無法使用 `systemctl`
✅ 必須手動啟動或使用計劃工作

### 2. 文件權限
❌ Windows NTFS 的權限模式不同
✅ OpenClaw 會自動處理，但某些功能可能受限

### 3. 路徑分隔符
⚠️ Windows 使用 `\`，Unix 使用 `/`
✅ Node.js 通常自動處理轉換

### 4. 端口佔用
如果 18789 端口被佔用：

```powershell
# 檢查佔用端口的進程
netstat -ano | findstr :18789

# 殺死進程（假設 PID 為 1234）
taskkill /PID 1234 /F

# 或在配置中改用其他端口
```

### 5. 字元編碼
⚠️ 確保配置文件使用 UTF-8 編碼
❌ Windows 記事本默認可能使用 ANSI
✅ 使用 VS Code 或 Notepad++ 編輯

---

## 故障排除

### 問題 1：npm: 無法找到命令

**原因**：Node.js 未正確添加到 PATH

**解決**：
```powershell
# 重新安裝 Node.js，並勾選 "Add to PATH"
# 或手動添加：
[Environment]::SetEnvironmentVariable("PATH", "$env:PATH;C:\Program Files\nodejs", "User")

# 重啟 PowerShell
```

### 問題 2：OpenClaw 無法啟動

```powershell
# 檢查日誌
Get-Content "$env:USERPROFILE\.openclaw\logs\*.log" -Tail 100

# 驗證 Node.js
node --version

# 重新安裝 OpenClaw
npm uninstall -g openclaw
npm install -g openclaw
```

### 問題 3：API 連接失敗

```powershell
# 檢查網路連接
Test-NetConnection google.com -Port 443

# 檢查配置文件格式
python -m json.tool "$env:USERPROFILE\.openclaw\config.yaml"
```

---

## 與其他方案的比較

| 特性 | 原生 Windows | Docker | WSL2 |
|------|-------------|--------|------|
| **複雜度** | 中等 | 簡單 | 簡單 |
| **性能** | 最快 | 中等 | 快 |
| **服務管理** | ❌ 手動 | ✅ 自動 | ✅ systemd |
| **穩定性** | ⚠️ 實驗 | ✅ 穩定 | ✅ 穩定 |
| **開發體驗** | 一般 | 隔離 | 優秀 |

**推薦順序：**
1️⃣ **Docker**（最簡單）
2️⃣ **WSL2**（最靈活）
3️⃣ **原生 Windows**（最快但最複雜）

---

## 下一步

- ✅ 安裝完成
- 📝 編輯配置文件，添加 API 密鑰
- 🚀 啟動 OpenClaw
- 📱 連接 Telegram/Discord 機器人
- 🎯 編寫自訂技能

詳見 [主 README](../README.md)。
