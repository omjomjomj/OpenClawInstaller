# ============================================================
# OpenClaw Windows 安装脚本 (PowerShell)
#
# 使用方法:
#   1. 以管理员身份打开 PowerShell
#   2. 运行: Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
#   3. 运行: .\install-openclaw.ps1
#
# 可选参数:
#   -InstallDir "C:\MyPath"  # 自定义安装路径
#   -NodeVersion "22"        # Node.js 版本
# ============================================================

param(
    [string]$InstallDir = "C:\OpenClaw",
    [string]$NodeVersion = "22"
)

# 颜色定义
$Green = @{ ForegroundColor = 'Green' }
$Red = @{ ForegroundColor = 'Red' }
$Yellow = @{ ForegroundColor = 'Yellow' }
$Blue = @{ ForegroundColor = 'Cyan' }

function Write-Success { Write-Host @Green @args }
function Write-Error { Write-Host @Red @args }
function Write-Warning { Write-Host @Yellow @args }
function Write-Info { Write-Host @Blue @args }

function Check-Admin {
    $identity = [System.Security.Principal.WindowsIdentity]::GetCurrent()
    $principal = New-Object System.Security.Principal.WindowsPrincipal($identity)
    if (-not $principal.IsInRole([System.Security.Principal.WindowsBuiltInRole]::Administrator)) {
        Write-Error "❌ 此脚本需要管理员权限。请以管理员身份运行。"
        exit 1
    }
    Write-Success "✅ 已确认管理员权限"
}

function Check-Node {
    try {
        $version = node --version 2>$null
        if ($version) {
            Write-Success "✅ Node.js 已安装: $version"

            # 检查版本
            $major = [int]($version -replace 'v(\d+).*', '$1')
            if ($major -lt 22) {
                Write-Error "❌ Node.js 版本过旧。需要 v22 或更新，目前为 $version"
                Write-Warning "⚠️  请从 https://nodejs.org 下载 v22 LTS"
                exit 1
            }
        } else {
            throw
        }
    }
    catch {
        Write-Error "❌ Node.js 未安装或未在 PATH 中"
        Write-Warning "⚠️  请从 https://nodejs.org 下载并安装 v$NodeVersion LTS"
        exit 1
    }
}

function Check-NPM {
    try {
        $version = npm --version 2>$null
        if ($version) {
            Write-Success "✅ npm 已安装: v$version"
        } else {
            throw
        }
    }
    catch {
        Write-Error "❌ npm 未安装"
        exit 1
    }
}

function Check-Git {
    try {
        $version = git --version 2>$null
        if ($version) {
            Write-Success "✅ Git 已安装: $version"
        } else {
            throw
        }
    }
    catch {
        Write-Warning "⚠️  Git 未安装。若需要版本控制，请安装 Git for Windows"
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
            Write-Success "✅ 创建目录: $dir"
        } else {
            Write-Info "ℹ️  目录已存在: $dir"
        }
    }
}

function Clone-Repository {
    $repoPath = "$InstallDir\OpenClawInstaller"

    if (-not (Test-Path $repoPath)) {
        Write-Warning "⏳ 正在克隆 OpenClaw 仓库..."

        try {
            # 检查 Git 是否可用
            $gitExists = Get-Command git -ErrorAction SilentlyContinue

            if ($gitExists) {
                git clone https://github.com/miaoxworld/OpenClawInstaller.git "$repoPath"
                Write-Success "✅ 克隆完成"
            } else {
                Write-Warning "⚠️  Git 不可用，请手动下载 https://github.com/miaoxworld/OpenClawInstaller"
                Write-Warning "⏳ 等待用户确认..."
                Read-Host "按 Enter 继续（假设您已手动下载）"
            }
        }
        catch {
            Write-Error "❌ 克隆失败: $_"
            Write-Warning "⚠️  请手动下载: https://github.com/miaoxworld/OpenClawInstaller/archive/refs/heads/main.zip"
            exit 1
        }
    }
    else {
        Write-Success "✅ 项目目录已存在: $repoPath"
    }
}

function Copy-Config {
    $OpenClawHome = "$env:USERPROFILE\.openclaw"
    $repoPath = "$InstallDir\OpenClawInstaller"

    $configSource = "$repoPath\examples\config.example.yaml"
    $configDest = "$OpenClawHome\config.yaml"

    if (Test-Path $configSource) {
        if (-not (Test-Path $configDest)) {
            Copy-Item $configSource -Destination $configDest
            Write-Success "✅ 配置文件已创建: $configDest"
        } else {
            Write-Warning "⚠️  配置文件已存在，跳过复制"
        }
    }
    else {
        Write-Warning "⚠️  未找到配置源文件: $configSource"
    }
}

function Install-OpenClaw {
    Write-Warning "⏳ 正在安装 OpenClaw CLI..."

    try {
        npm install -g openclaw --verbose
        Write-Success "✅ OpenClaw CLI 安装完成"
    }
    catch {
        Write-Error "❌ 安装失败: $_"
        Write-Warning "⚠️  您可以手动执行: npm install -g openclaw"
        exit 1
    }
}

function Verify-Installation {
    try {
        $version = openclaw --version 2>$null
        if ($version) {
            Write-Success "✅ OpenClaw 已成功安装: $version"
            return $true
        } else {
            throw
        }
    }
    catch {
        Write-Error "❌ 无法验证 OpenClaw 安装"
        Write-Warning "⚠️  请尝试手动运行: openclaw --version"
        return $false
    }
}

function Show-NextSteps {
    Write-Host ""
    Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" @Green
    Write-Host "🦞 OpenClaw 安装完成！" @Green
    Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" @Green
    Write-Host ""
    Write-Host "📝 后续步骤:" @Yellow
    Write-Host ""
    Write-Host "1️⃣  编辑配置文件:" @Blue
    Write-Host "   notepad `"$env:USERPROFILE\.openclaw\config.yaml`""
    Write-Host ""
    Write-Host "2️⃣  添加 API 密钥 (Anthropic, OpenAI, Gemini 等)" @Blue
    Write-Host ""
    Write-Host "3️⃣  启动 OpenClaw (在 PowerShell 中):" @Blue
    Write-Host "   openclaw gateway start"
    Write-Host ""
    Write-Host "4️⃣  查看状态:" @Blue
    Write-Host "   openclaw gateway status"
    Write-Host ""
    Write-Host "5️⃣  查看日志:" @Blue
    Write-Host "   Get-Content `"$env:USERPROFILE\.openclaw\logs\openclaw.log`" -Tail 50 -Wait"
    Write-Host ""
    Write-Host "📚 更多命令:" @Blue
    Write-Host "   openclaw --help"
    Write-Host ""
    Write-Host "💡 配置文件位置:" @Blue
    Write-Host "   $env:USERPROFILE\.openclaw\config.yaml"
    Write-Host ""
    Write-Host "📍 安装目录:" @Blue
    Write-Host "   $InstallDir"
    Write-Host ""
    Write-Host "⚠️  注意事项:" @Yellow
    Write-Host "   • Windows 上无法使用 systemctl 管理服务"
    Write-Host "   • 建议使用 Docker 或 WSL2 以获得更好的体验"
    Write-Host "   • 详见文档: docs/windows-native-guide.md"
    Write-Host ""
}

function Show-Header {
    Write-Host ""
    Write-Host "╔════════════════════════════════════════════════════╗" @Green
    Write-Host "║     🦞 OpenClaw Windows 安装程序                   ║" @Green
    Write-Host "║     Version 1.0.0                                 ║" @Green
    Write-Host "╚════════════════════════════════════════════════════╝" @Green
    Write-Host ""
    Write-Host "📋 检查系统要求..." @Yellow
}

# ============================================================
# 主安装流程
# ============================================================

Show-Header
Check-Admin
Check-Node
Check-NPM
Check-Git
Create-Directories
Clone-Repository
Copy-Config
Install-OpenClaw

if (Verify-Installation) {
    Show-NextSteps
    Write-Host "✨ 安装成功！" @Green
    Write-Host ""
} else {
    Write-Error "❌ 安装过程中出现问题"
    exit 1
}
