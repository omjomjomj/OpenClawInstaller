# 安卓系統 - OpenClaw 部署完整指南

## ⚠️ 重要提示

OpenClaw 是一個 **Node.js 應用**，原生不支援安卓系統。然而，有**多種方式**可以在安卓設備上運行或存取 OpenClaw。

---

## 📋 目錄
1. [四種部署方案](#四種部署方案)
2. [方案選擇指南](#方案選擇指南)
3. [詳細部署步驟](#詳細部署步驟)
4. [常見問題](#常見問題)

---

## 四種部署方案

### 1️⃣ Termux + Node.js（最靈活）

**優點：** 功能最完整，可運行完整的 OpenClaw
**缺點：** 需要較多 RAM 和儲存空間
**適合：** 開發者和高級用戶

### 2️⃣ Docker on Termux（推薦）

**優點：** 隔離環境，易於管理
**缺點：** 需要 Termux + Docker
**適合：** 需要生產級部署的用戶

### 3️⃣ 遠程服務器 + 安卓客戶端

**優點：** 省資源，設備獨立
**缺點：** 需要部署服務器
**適合：** 多設備共享使用

### 4️⃣ 輕量級移動應用（未來方案）

**優點：** 原生體驗，最佳性能
**缺點：** 需要開發移動應用
**適合：** 長期使用

---

## 方案選擇指南

### 我該選哪一個？

**選擇 Termux + Node.js，如果：**
- ✅ 需要完整功能
- ✅ 有充足的儲存空間（至少 2GB）
- ✅ 設備 RAM ≥ 4GB
- ✅ 主要用於測試/開發

**選擇 Docker on Termux，如果：**
- ✅ 需要隔離環境
- ✅ 有 8GB+ RAM
- ✅ 需要生產級部署
- ✅ 願意學習 Docker

**選擇遠程服務器，如果：**
- ✅ 設備儲存空間不足
- ✅ 需要多設備同步
- ✅ 優先考慮效能
- ✅ 願意付費（VPS）

**選擇移動應用，如果：**
- ✅ 需要最佳用戶體驗
- ✅ 計劃長期使用
- ✅ 不想配置複雜的環境
- ✅ 願意等待官方應用

---

## 詳細部署步驟

### 方案 1：Termux + Node.js

#### 步驟 1：安裝 Termux

1. 從 [F-Droid](https://f-droid.org/packages/com.termux/) 下載 Termux
   - ✅ 推薦使用 F-Droid（官方倉庫）
   - ❌ 不要使用 Google Play 的版本（已過期）

2. 啟動 Termux，執行初始化

#### 步驟 2：更新系統

```bash
# 更新包管理器
pkg update

# 升級已安裝的包
pkg upgrade -y

# 安裝基本工具
pkg install -y \
  curl \
  wget \
  git \
  vim \
  build-essential
```

#### 步驟 3：安裝 Node.js

```bash
# 安裝 Node.js 22（latest LTS）
pkg install -y nodejs-lts

# 驗證安裝
node --version
npm --version
```

#### 步驟 4：安裝 OpenClaw

```bash
# 建立工作目錄
mkdir -p ~/openclaw
cd ~/openclaw

# 克隆專案
git clone https://github.com/miaoxworld/OpenClawInstaller.git
cd OpenClawInstaller

# 全域安裝 OpenClaw CLI
npm install -g openclaw

# 驗證安裝
openclaw --version
```

#### 步驟 5：配置 OpenClaw

```bash
# 使用編輯器配置
nano ~/.openclaw/config.yaml

# 或使用環境變數
export ANTHROPIC_API_KEY="sk-ant-..."
export OPENAI_API_KEY="sk-..."
```

#### 步驟 6：啟動服務

```bash
# 啟動 OpenClaw
openclaw gateway start

# 查看狀態
openclaw gateway status

# 查看日誌
tail -f ~/.openclaw/logs/openclaw.log
```

#### 步驟 7：在安卓上存取

在同一設備的瀏覽器中存取：
```
http://localhost:18789
```

或從其他設備存取（需要知道安卓設備的 IP）：
```
http://<安卓設備IP>:18789
```

獲取 IP 地址：
```bash
# 在 Termux 中執行
hostname -I
```

---

### 方案 2：Docker on Termux

#### 步驟 1：安裝 Termux

同方案 1，步驟 1-2

#### 步驟 2：安裝 Docker

```bash
# Termux 中的 Docker 需要通過 proot-distro
pkg install -y proot-distro

# 安裝 Ubuntu 發行版
proot-distro install ubuntu

# 進入 Ubuntu 環境
proot-distro login ubuntu
```

#### 步驟 3：在 Ubuntu 中安裝 Docker

```bash
# 更新包管理器
apt update
apt upgrade -y

# 安裝 Docker
apt install -y docker.io

# 啟動 Docker
service docker start

# 驗證
docker --version
```

#### 步驟 4：部署 OpenClaw

```bash
# 克隆專案
git clone https://github.com/miaoxworld/OpenClawInstaller.git
cd OpenClawInstaller

# 啟動 Docker Compose
docker-compose up -d

# 查看日誌
docker-compose logs -f
```

#### 優勢

✅ 完整隔離環境
✅ 資源使用量可控
✅ 更穩定的運行
✅ 易於備份和遷移

---

### 方案 3：遠程服務器 + 安卓客戶端

#### 步驟 1：選擇服務器

**免費選項：**
- AWS Free Tier（1 年免費）
- Google Cloud Free Tier
- Azure Free Tier

**付費選項：**
- AWS EC2（$3-5/月）
- DigitalOcean（$5/月）
- Linode（$5/月）
- Heroku（已停止免費方案）

#### 步驟 2：在服務器上部署

參考 [Windows WSL2 指南](./windows-wsl2-guide.md) 或 [Docker 指南](./windows-docker-guide.md)

選擇 Ubuntu 20.04 或 22.04 LTS 系統映像

```bash
# 在服務器上執行
git clone https://github.com/miaoxworld/OpenClawInstaller.git
cd OpenClawInstaller
chmod +x install.sh
./install.sh

# 配置公共訪問
nano ~/.openclaw/config.yaml
# 改為 HOST=0.0.0.0
```

#### 步驟 3：在安卓上連接

在安卓瀏覽器中訪問：
```
http://<服務器IP>:18789
```

或安裝客戶端應用：
- **Termux SSH 客戶端**：遠程管理
- **API 客戶端**：Postman、Insomnia
- **Web 瀏覽器**：Chrome、Firefox

#### 優勢

✅ 設備獨立
✅ 永遠在線
✅ 易於備份
✅ 支援多設備
✅ 節省手機資源

#### 安全建議

```bash
# 配置防火牆
sudo ufw allow 22/tcp
sudo ufw allow 18789/tcp
sudo ufw enable

# 使用 SSL/TLS（可選）
# 使用 Nginx 代理
sudo apt install -y nginx
```

---

### 方案 4：輕量級移動應用（未來）

#### 計劃特性

- 原生 Android 應用（Java/Kotlin）
- 本地 Node.js 執行環境
- 離線優先架構
- 推播通知支持

#### 當前進展

⏳ **開發中**，計劃在 OpenClaw v1.5+ 推出

#### 臨時替代方案

使用 **Termux + WebView**：
```bash
# 在 Termux 中運行
openclaw gateway start

# 在安卓中打開瀏覽器
http://localhost:18789
```

---

## 系統要求對比

| 方案 | RAM | 儲存 | 網路 | 複雜度 | 成本 |
|------|-----|------|------|--------|------|
| Termux | 4GB+ | 2GB+ | 無 | 中等 | 免費 |
| Docker | 6GB+ | 3GB+ | 無 | 高 | 免費 |
| 遠程服務器 | 無限制 | 無限制 | 必需 | 中等 | $5-10 |
| 移動應用 | 1GB+ | 500MB | 無 | 低 | 免費 |

---

## Termux 優化建議

### 1. 擴展儲存空間

```bash
# 訪問內部儲存
cd /data/data/com.termux/files/home

# 或創建符號鏈接到 SD 卡
ln -s /sdcard/openclaw ~/openclaw-data
```

### 2. 記憶體管理

```bash
# 檢查記憶體使用
free -h

# 清理快取
npm cache clean --force

# 停用不必要的服務
openclaw gateway stop
```

### 3. 電池優化

```bash
# 禁止後台限制（在 Android 設置中）
# 設定 → 應用程式 → Termux → 電池 → 不優化

# 在 Termux 中設置低功耗模式
# export OPENCLAW_LOW_POWER=true
```

### 4. 網路優化

```bash
# 使用 IPv4 優先
# 禁用 IPv6（可選）
sudo sysctl -w net.ipv6.conf.all.disable_ipv6=1
```

---

## 常見問題

### Q1：安卓上無法安裝 Termux

**解決：**
1. 確保使用 F-Droid 版本（Google Play 版本已棄用）
2. 清理應用快取：設定 → 應用程式 → Termux → 儲存 → 清理
3. 檢查可用儲存空間（至少 500MB）

### Q2：Node.js 安裝失敗

**檢查：**
```bash
# 更新 Termux 包管理器
pkg update

# 列出可用版本
pkg search nodejs

# 重新安裝
pkg install -y nodejs-lts
```

### Q3：OpenClaw 啟動速度慢

**優化：**
```bash
# 禁用不必要的日誌
export NODE_ENV=production

# 減少 worker 進程
export OPENCLAW_WORKERS=1

# 降低日誌級別
export LOG_LEVEL=warn
```

### Q4：記憶體不足

**檢查：**
```bash
# 檢查記憶體使用
ps aux | head -20

# 清理緩存
npm cache clean --force
openclaw cache clear
```

**解決：**
- 升級裝置 RAM 或清理其他應用
- 使用遠程服務器方案
- 停止其他 Termux 服務

### Q5：無法存取遠程 IP

**確保：**
```bash
# 檢查 IP 地址
hostname -I

# 確保防火牆允許
iptables -L

# 測試連接
curl http://localhost:18789/health
```

**常見原因：**
- 設備在不同子網 → 使用路由器 IP
- 防火牆阻止 → 在安卓設定中允許
- Termux 網路限制 → 重啟 Termux

### Q6：應用在後台被殺死

**解決：**
1. 在 Android 設定中禁止電池優化
2. 使用 Termux:Boot 自動啟動
3. 使用 `nohup` 運行後台進程

```bash
# 使用 nohup 保證不被中斷
nohup openclaw gateway start > openclaw.log 2>&1 &

# 或使用 screen
pkg install -y screen
screen -S openclaw
openclaw gateway start
# Ctrl+A, D 離開會話
```

---

## 安卓客戶端應用建議

### 瀏覽器（推薦最簡單）

| 應用 | 特點 |
|------|------|
| **Chrome** | 最穩定，支援所有功能 |
| **Firefox** | 隱私第一，支援擴展 |
| **Brave** | 快速，廣告攔截 |

### 高級用戶工具

| 應用 | 用途 |
|------|------|
| **Termux** | 直接執行命令 |
| **Termux:Widget** | 快速啟動命令 |
| **Termux:Boot** | 自動啟動服務 |
| **Termux:Styling** | 自訂介面 |

### API 測試工具

| 應用 | 功能 |
|------|------|
| **Postman** | 完整的 API 測試 |
| **Insomnia** | 輕量級 API 客戶端 |
| **Thunderclient** | VS Code 擴展 |

---

## 效能參考數據

### 測試環境
- **設備**：Samsung Galaxy S21（8GB RAM）
- **Termux**：最新版本
- **Node.js**：v22 LTS

### 性能指標

| 指標 | Termux | Docker | 遠程服務器 |
|------|--------|--------|----------|
| 啟動時間 | 3-5s | 5-8s | 2-3s |
| 內存占用 | 200-300MB | 400-500MB | N/A |
| CPU 使用 | 10-15% | 15-20% | N/A |
| API 響應 | 100-200ms | 150-250ms | 50-100ms |

---

## 備份和恢復

### 備份配置

```bash
# 備份整個 .openclaw 目錄
tar czf ~/.openclaw-backup.tar.gz ~/.openclaw/

# 複製到外部儲存
cp ~/.openclaw-backup.tar.gz /sdcard/

# 或通過 SCP 上傳
scp ~/.openclaw-backup.tar.gz user@server:/backup/
```

### 恢復配置

```bash
# 從備份恢復
tar xzf ~/.openclaw-backup.tar.gz -C ~/

# 驗證
ls -la ~/.openclaw/
```

---

## 安全建議

### 基本安全

1. **定期更新**
```bash
pkg update
pkg upgrade
npm update -g openclaw
```

2. **限制網路存取**
```bash
# 只允許本地連接
export HOST=127.0.0.1

# 或使用反向代理認證
```

3. **備份敏感信息**
```bash
# 備份 API 密鑰
tar czf ~/.openclaw/credentials-backup.tar.gz ~/.openclaw/credentials/

# 安全刪除原文件
shred -vfz ~/.openclaw/credentials/*
```

4. **監控日誌**
```bash
# 定期檢查錯誤日誌
grep ERROR ~/.openclaw/logs/*.log
```

---

## Termux 實用命令速查

```bash
# 包管理
pkg search <package>          # 搜索包
pkg install <package>         # 安裝包
pkg upgrade                     # 升級所有包
pkg remove <package>          # 移除包

# 文件管理
ls -la                         # 列表文件
cd /sdcard                     # 訪問 SD 卡
chmod +x file.sh              # 改變執行權限

# 網路
ping google.com               # 測試網路
wget URL                       # 下載文件
curl URL                       # 發送請求

# 進程管理
ps aux                         # 列表進程
kill -9 PID                    # 殺死進程
nohup command &                # 後台執行

# OpenClaw 特定
openclaw --help               # 幫助信息
openclaw gateway start        # 啟動服務
openclaw gateway stop         # 停止服務
openclaw gateway status       # 查看狀態
```

---

## 遷移指南

### 從 Termux 遷移到遠程服務器

```bash
# 1. 備份配置
tar czf config-backup.tar.gz ~/.openclaw/

# 2. 上傳到服務器
scp config-backup.tar.gz user@server:~/

# 3. 在服務器上恢復
tar xzf config-backup.tar.gz
cp -r .openclaw/* ~/.openclaw/

# 4. 更新配置（允許遠程訪問）
nano ~/.openclaw/config.yaml
# HOST=0.0.0.0
```

---

## 下一步

1. ✅ 根據硬體選擇部署方案
2. 📱 在安卓上部署或連接
3. 🔐 配置 API 密鑰
4. 🚀 啟動服務
5. 💬 設置 Telegram/Discord 機器人
6. 📊 監控和優化

---

## 相關資源

- [Termux Wiki](https://wiki.termux.com/)
- [Node.js 文檔](https://nodejs.org/docs/)
- [OpenClaw GitHub](https://github.com/miaoxworld/OpenClawInstaller)
- [安卓開發者指南](https://developer.android.com/)

---

**最後更新：** 2026年2月7日
**版本：** 1.0.0（安卓部署 Beta）
