# 安卓 - 從這裡開始 🚀

## 👋 歡迎！

您想在安卓設備上使用 OpenClaw？很好！按照下面的步驟操作，您可以在 **5-20 分鐘內** 完成安裝。

---

## 🎯 選擇您的路徑

### 路徑 1️⃣：我想快速開始（推薦）

**耗時**：5-10 分鐘

1. 首先閱讀：**[F-Droid 快速安裝](./android-fdroid-guide.md#安裝-f-droid)** （2-3 分鐘）
2. 然後按照：**[Android 快速開始](./android-quick-start.md)** （3-5 分鐘）
3. 完成！🎉

👉 **開始吧**：[F-Droid 指南](./android-fdroid-guide.md)

---

### 路徑 2️⃣：我想了解所有細節（推薦專業用戶）

**耗時**：20-30 分鐘

1. **[F-Droid 完整指南](./android-fdroid-guide.md)** - 理解 F-Droid 和 Termux
2. **[安卓完整部署指南](./android-deployment-guide.md)** - 4 種部署方案詳解
3. **[常見問題解答](./android-faq.md)** - 25+ Q&A

👉 **開始吧**：[F-Droid 指南](./android-fdroid-guide.md)

---

### 路徑 3️⃣：我已經有 Termux（來自 F-Droid）

**耗時**：5 分鐘

直接跳到：**[安卓快速開始](./android-quick-start.md)**

或使用自動腳本：
```bash
curl -fsSL https://raw.githubusercontent.com/miaoxworld/OpenClawInstaller/main/install-android.sh | bash
```

👉 **開始吧**：[快速開始](./android-quick-start.md)

---

## 🚨 最重要的提示

### ⚠️ Google Play vs F-Droid

| 來源 | Termux | 可以用嗎？ |
|------|--------|---------|
| **Google Play** | 舊版本（已棄用） | ❌ **不行** |
| **F-Droid** | 官方最新版本 | ✅ **必須用** |

**如果您從 Google Play 安裝了 Termux，請刪除並從 F-Droid 重新安裝。**

---

## 📚 完整文檔結構

```
安卓部署指南
├── 🟢 START HERE - 從這裡開始（本文件）
├── 📱 F-Droid 指南
│   ├── 什麼是 F-Droid？
│   ├── 為什麼選擇 F-Droid？
│   ├── 安裝步驟
│   ├── 首次使用
│   └── 常見問題
├── ⚡ 快速開始（5 分鐘）
│   ├── 安裝 Termux
│   ├── 一鍵安裝腳本
│   ├── 配置和啟動
│   └── 常用命令
├── 📖 完整部署指南
│   ├── 4 種部署方案
│   ├── 詳細步驟
│   ├── 系統要求
│   └── 進階配置
├── ❓ 常見問題解答
│   ├── 基本問題
│   ├── 安裝問題
│   ├── 運行問題
│   ├── 網路訪問
│   ├── 故障排除
│   └── 安全建議
└── 🔧 自動安裝腳本（install-android.sh）
```

---

## ⏱️ 預計耗時

| 步驟 | 耗時 |
|------|------|
| 1. 下載 F-Droid | 3-5 分鐘 |
| 2. F-Droid 初始化 | 1-2 分鐘 |
| 3. 安裝 Termux | 2-5 分鐘 |
| 4. 配置 OpenClaw | 3-5 分鐘 |
| **總計** | **9-17 分鐘** |

---

## 🛠️ 系統要求

### 最低要求
- **Android 10+**
- **2GB 儲存空間**
- **4GB RAM**（推薦 8GB）
- **穩定網路**（WiFi 或 4G）

### 檢查您的設備

```
設定 → 系統 → 關於手機
查看 Android 版本和可用存儲空間
```

---

## 🎯 四種部署方案一覽

### 1. Termux + Node.js（最簡單）
- ⏱️ **安裝時間**：5-10 分鐘
- 💾 **儲存空間**：2GB
- 📱 **RAM 需求**：4GB+
- ✅ **推薦用於**：測試、開發、個人使用
- 📖 **文檔**：[快速開始](./android-quick-start.md)

### 2. Docker on Termux（最穩定）
- ⏱️ **安裝時間**：15-20 分鐘
- 💾 **儲存空間**：3GB
- 📱 **RAM 需求**：8GB+
- ✅ **推薦用於**：生產部署、長期運行
- 📖 **文檔**：[完整指南](./android-deployment-guide.md#方案-2docker-on-termux)

### 3. 遠程服務器（最資源節省）
- ⏱️ **安裝時間**：10-15 分鐘
- 💾 **設備儲存空間**：500MB
- 📱 **設備 RAM 需求**：1GB+
- ✅ **推薦用於**：多設備共享、低功耗設備
- 💰 **成本**：$5-10/月（VPS）
- 📖 **文檔**：[完整指南](./android-deployment-guide.md#方案-3遠程服務器--安卓客戶端)

### 4. 原生應用（未來）
- ⏱️ **可用性**：計劃中（v1.5+）
- ✅ **推薦用於**：長期用戶、最佳體驗

---

## ✅ 檢查清單

使用此清單確保一切正常：

### 前置安裝
- [ ] 我有 Android 10+ 設備
- [ ] 我有至少 2GB 可用儲存空間
- [ ] 我有穩定的網路連接
- [ ] 我準備好花 10-20 分鐘

### 安裝步驟
- [ ] 我已閱讀 [F-Droid 指南](./android-fdroid-guide.md)
- [ ] 我已安裝 F-Droid
- [ ] 我已安裝 Termux（來自 F-Droid，不是 Google Play）
- [ ] 我已安裝 Termux:Boot（可選但推薦）
- [ ] 我已運行 OpenClaw 安裝腳本或手動步驟

### 驗證
- [ ] OpenClaw 已成功啟動
- [ ] 我可以在瀏覽器訪問 `http://localhost:18789`
- [ ] 我已配置了至少一個 AI API 密鑰
- [ ] 服務在後台正常運行

✅ **全部完成？恭喜！** 🎉

---

## 🆘 遇到問題？

### 我看到「無法從 Google Play 安裝」

這是**正常的**！Google Play 版本已棄用。

**解決**：改用 [F-Droid](./android-fdroid-guide.md)

### 我看到「Termux 已停止支援」

**不要驚慌**！只有 Google Play 版本停止了支援。

**解決**：使用 [F-Droid 版本](./android-fdroid-guide.md)

### 我不知道應該使用哪種方案

**建議**：對於大多數用戶，使用 **Termux + Node.js** 方案。

詳見：[方案選擇指南](./android-deployment-guide.md#方案選擇指南)

### 我的 OpenClaw 無法啟動

查看：[常見問題解答](./android-faq.md#运行相关)

### 我無法從其他設備訪問

查看：[網路訪問指南](./android-faq.md#网络与访问)

---

## 📖 詳細文檔

### 快速參考
- ⚡ [5 分鐘快速開始](./android-quick-start.md)
- 📱 [F-Droid 完整指南](./android-fdroid-guide.md)

### 詳細指南
- 📚 [完整安卓部署指南](./android-deployment-guide.md)
- ❓ [25+ 常見問題解答](./android-faq.md)

### 自動化
- 🔧 [自動安裝腳本](../install-android.sh)

---

## 🌐 官方資源

### F-Droid
- 🌐 [官方網站](https://f-droid.org/)
- 📖 [官方文檔](https://f-droid.org/en/docs/)
- ❓ [官方常見問題](https://f-droid.org/en/faq/)

### Termux
- 🌐 [官方網站](https://termux.com/)
- 📚 [Termux Wiki](https://wiki.termux.com/)
- 💬 [Termux 論壇](https://forum.termux.com/)

### OpenClaw
- 🔗 [GitHub 儲存庫](https://github.com/miaoxworld/OpenClawInstaller)
- 📖 [主 README](../README.md)
- 💬 [GitHub Issues](https://github.com/miaoxworld/OpenClawInstaller/issues)

---

## 🚀 現在開始

### 對於首次用戶

1. 👉 **[F-Droid 完整安裝指南](./android-fdroid-guide.md)** （2-3 分鐘）
2. 👉 **[Android 快速開始](./android-quick-start.md)** （3-5 分鐘）
3. ✅ 完成！

### 對於已有 Termux 的用戶

1. 👉 **[快速開始](./android-quick-start.md)** （5 分鐘）

### 對於進階用戶

1. 👉 **[完整部署指南](./android-deployment-guide.md)** （詳細說明）
2. 👉 **[常見問題解答](./android-faq.md)** （深入討論）

---

## 💡 提示

💡 **保存此頁面** - 以便日後參考

💡 **啟用自動啟動** - 使用 Termux:Boot 讓 OpenClaw 在設備啟動時自動運行

💡 **禁止電池優化** - 在 Android 設定中禁用 Termux 的電池優化，防止後台進程被殺死

💡 **定期備份** - 備份 `~/.openclaw/` 目錄以保存配置和數據

---

## 🎊 預備好了嗎？

### 讓我們開始吧！

**→ [F-Droid 安裝指南](./android-fdroid-guide.md)**

或

**→ [快速開始（需要 Termux）](./android-quick-start.md)**

---

**最後更新**：2026年2月7日
**版本**：1.0.0
