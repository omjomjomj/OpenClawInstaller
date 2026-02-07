#!/bin/bash
# ============================================================
# OpenClaw Termux 自動安裝腳本
#
# 使用方法:
#   在 Termux 中執行:
#   curl -fsSL https://raw.githubusercontent.com/miaoxworld/OpenClawInstaller/main/install-android.sh | bash
#
# 或本地執行:
#   chmod +x install-android.sh
#   ./install-android.sh
# ============================================================

set -e

# 顏色定義
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;36m'
NC='\033[0m' # No Color

# 日誌函數
log_info() {
    echo -e "${BLUE}ℹ️  $1${NC}"
}

log_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

log_error() {
    echo -e "${RED}❌ $1${NC}"
}

log_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

# 標題
show_header() {
    echo ""
    echo -e "${GREEN}╔═══════════════════════════════════════════════════╗${NC}"
    echo -e "${GREEN}║  🦞 OpenClaw Termux 自動安裝程式                  ║${NC}"
    echo -e "${GREEN}║  Version 1.0.0                                   ║${NC}"
    echo -e "${GREEN}╚═══════════════════════════════════════════════════╝${NC}"
    echo ""
}

# 檢查是否在 Termux 中執行
check_termux() {
    if [ ! -d "$HOME/.termux" ]; then
        log_warning "看起來您不在 Termux 中執行此腳本"
        log_info "請在 Termux 應用中執行此命令"
        read -p "繼續？(y/n) " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            exit 1
        fi
    else
        log_success "已檢測到 Termux 環境"
    fi
}

# 檢查儲存空間
check_storage() {
    log_info "檢查儲存空間..."

    available=$(df ~ | awk 'NR==2 {print $4}')
    required=$((2048 * 1024))  # 2GB in KB

    if [ "$available" -lt "$required" ]; then
        log_error "儲存空間不足！需要至少 2GB，目前可用：$(($available / 1024 / 1024))MB"
        exit 1
    fi

    log_success "儲存空間充足：$(($available / 1024 / 1024))MB"
}

# 更新系統
update_system() {
    log_info "更新系統包..."

    pkg update -y || {
        log_error "更新失敗，請檢查網路連接"
        exit 1
    }

    pkg upgrade -y || {
        log_warning "升級部分包失敗，繼續安裝..."
    }

    log_success "系統更新完成"
}

# 安裝依賴
install_dependencies() {
    log_info "安裝依賴包..."

    dependencies="curl wget git build-essential pkg-config"

    for pkg in $dependencies; do
        log_info "安裝 $pkg..."
        pkg install -y "$pkg" || {
            log_error "無法安裝 $pkg"
            exit 1
        }
    done

    log_success "依賴包安裝完成"
}

# 安裝 Node.js
install_nodejs() {
    log_info "安裝 Node.js..."

    # 檢查是否已安裝
    if command -v node &> /dev/null; then
        node_version=$(node --version)
        major_version=$(echo $node_version | cut -d'v' -f2 | cut -d'.' -f1)

        if [ "$major_version" -ge 22 ]; then
            log_success "Node.js 已安裝：$node_version"
            return
        else
            log_warning "Node.js 版本過舊（$node_version），將升級..."
            pkg upgrade -y nodejs-lts || true
        fi
    fi

    pkg install -y nodejs-lts || {
        log_error "無法安裝 Node.js"
        exit 1
    }

    # 驗證安裝
    if ! command -v node &> /dev/null; then
        log_error "Node.js 安裝驗證失敗"
        exit 1
    fi

    log_success "Node.js 安裝完成：$(node --version)"
}

# 驗證 npm
verify_npm() {
    log_info "驗證 npm..."

    if ! command -v npm &> /dev/null; then
        log_error "npm 未安裝"
        exit 1
    fi

    log_success "npm 已準備就緒：$(npm --version)"
}

# 建立工作目錄
setup_directories() {
    log_info "建立工作目錄..."

    mkdir -p ~/openclaw
    mkdir -p ~/.openclaw/logs
    mkdir -p ~/.openclaw/data
    mkdir -p ~/.openclaw/skills
    mkdir -p ~/.openclaw/credentials

    log_success "目錄建立完成"
}

# 克隆或下載專案
clone_project() {
    log_info "下載 OpenClaw 專案..."

    if [ -d "$HOME/openclaw/OpenClawInstaller" ]; then
        log_warning "專案目錄已存在，跳過克隆"
        cd "$HOME/openclaw/OpenClawInstaller"
    else
        cd $HOME/openclaw

        if command -v git &> /dev/null; then
            git clone https://github.com/miaoxworld/OpenClawInstaller.git || {
                log_error "克隆失敗"
                exit 1
            }
        else
            log_warning "Git 未安裝，嘗試使用 curl 下載..."
            curl -fsSL https://github.com/miaoxworld/OpenClawInstaller/archive/refs/heads/main.zip -o openclaw.zip || {
                log_error "下載失敗"
                exit 1
            }

            unzip -q openclaw.zip
            mv OpenClawInstaller-main OpenClawInstaller
            rm openclaw.zip
        fi

        cd OpenClawInstaller
    fi

    log_success "專案下載完成"
}

# 安裝 OpenClaw CLI
install_openclaw_cli() {
    log_info "安裝 OpenClaw CLI..."

    npm install -g openclaw || {
        log_error "OpenClaw CLI 安裝失敗"
        exit 1
    }

    # 驗證安裝
    if ! command -v openclaw &> /dev/null; then
        log_error "OpenClaw CLI 驗證失敗"
        exit 1
    fi

    log_success "OpenClaw CLI 安裝完成：$(openclaw --version)"
}

# 複製配置文件
setup_config() {
    log_info "設置配置文件..."

    if [ ! -f "$HOME/.openclaw/config.yaml" ]; then
        if [ -f "$HOME/openclaw/OpenClawInstaller/examples/config.example.yaml" ]; then
            cp "$HOME/openclaw/OpenClawInstaller/examples/config.example.yaml" "$HOME/.openclaw/config.yaml"
            log_success "配置文件已建立"
        else
            log_warning "找不到配置範例文件"
        fi
    else
        log_info "配置文件已存在，跳過"
    fi
}

# 設置 Termux:Boot（可選）
setup_termux_boot() {
    log_info "設置 Termux:Boot 自動啟動（可選）..."

    read -p "是否安裝 Termux:Boot 自動啟動？(y/n) " -n 1 -r
    echo

    if [[ $REPLY =~ ^[Yy]$ ]]; then
        mkdir -p ~/.termux/boot

        cat > ~/.termux/boot/openclaw.sh << 'EOF'
#!/bin/bash
# OpenClaw 自動啟動腳本
nohup openclaw gateway start > $HOME/.openclaw/logs/boot.log 2>&1 &
EOF

        chmod +x ~/.termux/boot/openclaw.sh
        log_success "Termux:Boot 已設置"
    fi
}

# 顯示後續步驟
show_next_steps() {
    echo ""
    echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${GREEN}🎉 安裝完成！${NC}"
    echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo ""

    echo -e "${YELLOW}📝 後續步驟:${NC}"
    echo ""

    echo "1️⃣  配置 API 密鑰:"
    echo -e "   ${BLUE}nano ~/.openclaw/config.yaml${NC}"
    echo ""

    echo "2️⃣  添加你的密鑰:"
    echo -e "   ${BLUE}models:"
    echo "     anthropic:"
    echo "       api_key: \"sk-ant-...\"${NC}"
    echo ""

    echo "3️⃣  啟動 OpenClaw:"
    echo -e "   ${BLUE}openclaw gateway start${NC}"
    echo ""

    echo "4️⃣  在瀏覽器中訪問:"
    echo -e "   ${BLUE}http://localhost:18789${NC}"
    echo ""

    echo -e "${YELLOW}📚 有用的命令:${NC}"
    echo ""
    echo -e "查看狀態:     ${BLUE}openclaw gateway status${NC}"
    echo -e "查看日誌:     ${BLUE}tail -f ~/.openclaw/logs/openclaw.log${NC}"
    echo -e "停止服務:     ${BLUE}openclaw gateway stop${NC}"
    echo -e "檢查記憶體:   ${BLUE}free -h${NC}"
    echo -e "檢查磁碟:     ${BLUE}df -h${NC}"
    echo ""

    echo -e "${YELLOW}💡 提示:${NC}"
    echo "• 在 Android 設定中禁止 Termux 電池優化，防止後台被殺死"
    echo "• 使用 Termux:Widget 建立快捷方式方便啟動"
    echo "• 定期備份 ~/.openclaw/ 目錄"
    echo ""

    echo -e "${YELLOW}📖 文檔:${NC}"
    echo "• 完整指南:    https://github.com/miaoxworld/OpenClawInstaller/blob/main/docs/android-deployment-guide.md"
    echo "• 快速開始:    https://github.com/miaoxworld/OpenClawInstaller/blob/main/docs/android-quick-start.md"
    echo ""
}

# 主安裝流程
main() {
    show_header

    check_termux
    check_storage
    update_system
    install_dependencies
    install_nodejs
    verify_npm
    setup_directories
    clone_project
    install_openclaw_cli
    setup_config
    setup_termux_boot

    show_next_steps

    log_success "🦞 OpenClaw 在 Termux 上已成功安裝！"
    echo ""
}

# 執行主程式
main "$@"
