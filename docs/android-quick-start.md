# 安卓快速開始指南

## 🚀 5 分鐘快速上手

### 前置準備

✅ **安卓 10+** 設備
✅ **至少 2GB 可用儲存**
✅ **4GB+ RAM**（推薦）

---

## 方案 A：使用 Termux（簡單）

### 步驟 1：安裝 Termux（3 分鐘）

#### ⚠️ 重要提醒

**不要用 Google Play 的 Termux**（已棄用）。必須使用 **F-Droid 版本**。

#### 詳細步驟

##### 1a. 安裝 F-Droid

1. 在瀏覽器中訪問 [https://f-droid.org/](https://f-droid.org/)
2. 點擊 **「Download F-Droid」** 下載 APK
3. 提示「允許應用安裝此應用」時：
   - 點擊「設定」
   - 找到你的瀏覽器（如 Chrome）
   - 勾選「允許此來源的應用」
4. 返回並完成 F-Droid 安裝
5. 等待 F-Droid 初始化（1-2 分鐘）

**詳見**：[F-Droid 完整安裝指南](./android-fdroid-guide.md)

##### 1b. 在 F-Droid 中搜索 Termux

1. 打開 F-Droid 應用
2. 點擊**搜索圖標**（放大鏡）
3. 輸入 **「Termux」**
4. 找到「Termux」（官方版本，開發者：「The Termux Project」）
5. 點擊藍色「Install」按鈕
6. 等待下載和安裝完成
7. 完成後點擊「Open」啟動 Termux

### 步驟 2：一鍵安裝腳本（2 分鐘）

複製以下命令到 Termux 中：

```bash
# 複製整個塊並貼上到 Termux
pkg update && pkg upgrade -y && \
pkg install -y nodejs-lts git && \
mkdir -p ~/openclaw && \
cd ~/openclaw && \
git clone https://github.com/miaoxworld/OpenClawInstaller.git && \
cd OpenClawInstaller && \
npm install -g openclaw && \
echo "✅ 安裝完成！執行: openclaw gateway start"
```

### 步驟 3：配置 API 密鑰（1 分鐘）

```bash
# 編輯配置
nano ~/.openclaw/config.yaml

# 添加以下內容（取代 YOUR_KEY）：
models:
  anthropic:
    api_key: "YOUR_ANTHROPIC_KEY"
    model: "claude-3-5-sonnet-20241022"

# 保存：Ctrl+O → Enter → Ctrl+X
```

### 步驟 4：啟動（立即）

```bash
openclaw gateway start
```

### 步驟 5：訪問應用

在瀏覽器中打開：
```
http://localhost:18789
```

**完成！** ✨

---

## 方案 B：連接遠程服務器（推薦生產環境）

### 前置

需要已部署的 OpenClaw 服務器

### 步驟

1. 在瀏覽器中訪問：
```
http://<服務器IP>:18789
```

2. 書籤此頁面以便快速訪問

**完成！** ✨

---

## 🔧 常用命令

### 基本操作

```bash
# 啟動 OpenClaw
openclaw gateway start

# 停止 OpenClaw
openclaw gateway stop

# 查看狀態
openclaw gateway status

# 查看日誌
tail -f ~/.openclaw/logs/openclaw.log

# 配置文件位置
nano ~/.openclaw/config.yaml
```

### 系統命令

```bash
# 檢查記憶體
free -h

# 檢查磁碟
df -h

# 檢查 IP 地址
hostname -I

# 重啟 Termux
exit  # 再重新打開應用
```

---

## 🐛 快速排查

### 問題：無法安裝 Node.js

```bash
# 執行
pkg update
pkg install -y nodejs-lts

# 驗證
node --version
```

### 問題：OpenClaw 無法啟動

```bash
# 檢查日誌
cat ~/.openclaw/logs/openclaw.log | tail -50

# 檢查埠口佔用
netstat -tuln | grep 18789
```

### 問題：配置文件錯誤

```bash
# 檢查 YAML 格式
cat ~/.openclaw/config.yaml

# 複製範例
cp ~/openclaw/OpenClawInstaller/examples/config.example.yaml ~/.openclaw/config.yaml
```

### 問題：記憶體不足

```bash
# 檢查使用
ps aux | grep openclaw

# 清理快取
npm cache clean --force

# 關閉其他應用
# 在 Android 設定中清理後台應用
```

---

## 📱 推薦應用（全部在 F-Droid 中安裝）

| 應用 | 用途 | 推薦度 | 備註 |
|------|------|--------|------|
| **F-Droid** | 應用商店 | ⭐⭐⭐⭐⭐ | 必需 - [安裝指南](./android-fdroid-guide.md) |
| **Termux** | 運行 OpenClaw | ⭐⭐⭐⭐⭐ | **必需 - 須從 F-Droid 安裝** |
| **Termux:Boot** | 自動啟動 | ⭐⭐⭐⭐ | 推薦 |
| **Termux:Widget** | 快速啟動 | ⭐⭐⭐⭐ | 推薦 |
| **Chrome/Firefox** | 訪問應用 | ⭐⭐⭐⭐⭐ | 任選其一 |
| **Postman** | API 測試 | ⭐⭐⭐ | 可選 |

---

## 💡 提示

### 提示 1：保持 Termux 執行

- 在 Android 設定 → 應用程式 → Termux → 電池
- 改為「不優化」以防止後台被殺死

### 提示 2：固定埠口

在 Termux 中運行後，設備可作為服務器：

```bash
# 檢查 IP
hostname -I

# 其他設備可訪問
# http://<IP>:18789
```

### 提示 3：使用 Termux:Widget

1. 長按主屏幕 → 「小部件」
2. 搜索 "Termux:Widget"
3. 添加並建立快捷方式啟動 OpenClaw

---

## 🎯 下一步

部署完成後：

1. ✅ 配置 API 密鑰
2. 📱 設置 Telegram 機器人
3. 💬 配置 Discord 頻道
4. 🎨 自訂技能和提示
5. 📊 查看使用統計

詳見 [完整指南](./android-deployment-guide.md)

---

## 獲得幫助

### 安裝相關
- 📱 [F-Droid 完整指南](./android-fdroid-guide.md) - **安裝 F-Droid 和 Termux**
- ❓ [F-Droid 常見問題](./android-fdroid-guide.md#常見問題)

### OpenClaw 相關
- 📖 [完整安卓部署指南](./android-deployment-guide.md)
- ❓ [OpenClaw 常見問題](./android-faq.md)
- 🔧 [故障排除](./android-deployment-guide.md#常見問題)

### 官方資源
- 📚 [Termux Wiki](https://wiki.termux.com/)
- 🌐 [F-Droid 官網](https://f-droid.org/)
- 💬 [GitHub Issues](https://github.com/miaoxworld/OpenClawInstaller/issues)

---

## ⚠️ 常見錯誤

❌ **不要用 Google Play 的 Termux** - 已棄用，無法正常使用
✅ **只用 F-Droid 的 Termux** - 官方維護，完整支援

---

**小貼士**：保存此頁面，以便需要時快速參考！
