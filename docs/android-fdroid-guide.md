# F-Droid 完整安裝與使用指南

## 🎯 什麼是 F-Droid？

**F-Droid** 是一個**自由開源軟體（FOSS）應用商店**，專門為 Android 設備提供開源應用。

### 為什麼選擇 F-Droid？

| 特性 | F-Droid | Google Play | 其他應用商店 |
|------|---------|------------|----------|
| **開源應用** | ✅ 優先 | ❌ 混合 | ❌ 通常專有 |
| **隱私保護** | ✅ 無追蹤 | ⚠️ Google 追蹤 | ⚠️ 不明 |
| **費用** | ✅ 完全免費 | ⚠️ 付費應用 | ⚠️ 可能付費 |
| **Termux 支援** | ✅ 官方版本 | ❌ 已棄用 | ❌ 不支援 |
| **安全性** | ✅ 社區審核 | ⚠️ 官方審核 | ❌ 不明 |
| **更新速度** | ✅ 快速 | ⚠️ 可能延遲 | ⚠️ 不定期 |

---

## ⚠️ 為什麼不要用 Google Play 的 Termux？

**Google Play 上的 Termux 已經停止更新和支援**。

### 已知問題

❌ **無法正常運行**
- 頻繁崩潰
- 包管理器無法工作
- 無法安裝 Node.js 和其他工具

❌ **安全問題**
- 不再接收安全更新
- 已知漏洞未修復
- 官方已明確不推薦

❌ **功能限制**
- 無法使用最新特性
- 與最新 Termux 插件不相容
- 社群不再提供支援

### Google Play 提示

> "此應用已由開發者停止支援"

這意味著 **Google Play 版本已經被棄用**。

---

## 📥 安裝 F-Droid

### 方法 1：官方網站安裝（推薦）

#### 步驟 1：訪問官方網站

在 Android 設備的瀏覽器中訪問：
```
https://f-droid.org/
```

#### 步驟 2：下載安裝程式

1. 點擊頁面上的**「Download F-Droid」**按鈕
2. 會下載 `F-Droid.apk` 文件（約 2-3MB）
3. 下載完成後，點擊「打開」

#### 步驟 3：允許安裝

Android 會提示：**「允許應用安裝此應用」**

1. 點擊「設定」
2. 找到瀏覽器應用（如 Chrome）
3. 勾選「允許此來源的應用」
4. 返回並繼續安裝

#### 步驟 4：完成安裝

1. 在安裝提示中點擊「安裝」
2. 等待安裝完成（通常 5-10 秒）
3. 點擊「打開」啟動 F-Droid

---

### 方法 2：通過 QR 碼安裝

#### 步驟

1. 在另一台設備上訪問 https://f-droid.org/
2. 掃描頁面上的 **QR 碼**
3. 點擊下載並安裝

**優點**：快速、無需手動輸入

---

### 方法 3：通過電腦傳輸（離線安裝）

#### 如果無網路連接

1. **在電腦上**：訪問 https://f-droid.org/
2. **下載 APK**：右鍵保存 `F-Droid.apk`
3. **傳輸到 Android**：
   - 通過 USB 傳輸
   - 或通過 QQ、WeChat 等傳輸
4. **在 Android 上**：打開文件管理器，雙擊 APK 安裝

---

## 🚀 首次使用 F-Droid

### 步驟 1：啟動 F-Droid

安裝完成後，應用會自動打開。或從應用抽屜中點擊 **「F-Droid」**。

### 步驟 2：初始化和更新

首次啟動時，F-Droid 會：
1. **檢查環境** - 掃描系統配置
2. **更新倉庫列表** - 下載應用清單（1-2MB）
3. **同步元數據** - 此過程需要 **1-2 分鐘**

**顯示畫面**：
```
檢查環境...
更新倉庫...
同步索引...
```

**耐心等待**，不要關閉應用。

### 步驟 3：首頁介紹

完成更新後，會看到：

| 區域 | 說明 |
|------|------|
| **Latest** | 最新發佈的應用 |
| **Categories** | 應用分類 |
| **Updates** | 已安裝應用的更新 |
| **Search** | 搜索應用 |

---

## 🔍 搜索和安裝 Termux

### 搜索 Termux

1. 點擊 **搜索圖標**（放大鏡）
2. 輸入 **「Termux」**
3. 會看到 **「Termux」** 應用（官方版本）

### 識別官方版本

✅ **正確的 Termux**：
- **名稱**：「Termux」
- **開發者**：「The Termux Project」
- **描述**：「Android terminal emulator and Linux environment」
- **許可證**：「GPLv3」

❌ **錯誤的版本**（避免）：
- 「Termux」（舊版本，已停更）
- 「Termux X」（第三方修改版）
- 其他類似名稱的應用

### 安裝 Termux

1. 點擊 **「Termux」** 應用
2. 點擊**藍色「Install」按鈕**
3. 等待下載和安裝（2-5 分鐘，取決於網速）
4. 完成後點擊 **「Open」**

---

## ⚙️ F-Droid 設置

### 訪問設置

點擊左上角的**三條橫線**（菜單）→ **「Settings」**

### 重要設置選項

#### 1. **Auto-Updates**（自動更新）

```
Settings → Auto-updates

✅ 啟用 "Update apps" 保持應用最新
選擇: "Over WiFi" 或 "Over any network"
```

#### 2. **Repositories**（倉庫）

默認包含：
- ✅ **F-Droid** - 官方倉庫（必需）
- ✅ **F-Droid Archive** - 舊版本存檔（可選）

**不需要添加其他倉庫**（除非有特殊需求）

#### 3. **Notify about updates**（更新通知）

```
Settings → Notifications

✅ 啟用，這樣有更新時會收到通知
```

#### 4. **Language**（語言）

選擇 **「Traditional Chinese」（繁體中文）** 或 **「Simplified Chinese」（簡體中文）**

---

## 📱 安裝 Termux 相關應用

除了 Termux 本身，還推薦安裝：

### 核心應用

| 應用名 | 用途 | 是否必需 |
|--------|------|--------|
| **Termux** | 主應用 | ✅ 必須 |
| **Termux:Boot** | 自動啟動 | ✅ 強烈推薦 |
| **Termux:Widget** | 快捷方式 | ⭐ 推薦 |
| **Termux:Styling** | 主題/字體 | ⭐ 推薦 |

### 安裝步驟

1. 在 F-Droid 中搜索 **「Termux:Boot」**
2. 點擊應用
3. 點擊 **「Install」**
4. 等待安裝完成
5. 重複以上步驟安裝其他應用

### 各應用說明

#### Termux:Boot
**用途**：自動啟動 Termux 服務

**安裝後設置**：
```bash
# 在 Termux 中執行
mkdir -p ~/.termux/boot

# 創建自動啟動腳本
nano ~/.termux/boot/openclaw.sh

# 輸入：
#!/bin/bash
openclaw gateway start

# 保存：Ctrl+O → Enter → Ctrl+X

# 改變執行權限
chmod +x ~/.termux/boot/openclaw.sh
```

#### Termux:Widget
**用途**：在主屏幕建立快捷方式

**使用方法**：
1. 長按主屏幕空白處
2. 選擇「小部件」
3. 搜索「Termux:Widget」
4. 添加到主屏幕
5. 點擊編輯，選擇要執行的命令

#### Termux:Styling
**用途**：自訂主題和字體

**功能**：
- 🎨 50+ 配色主題
- 🔤 多種字體選擇
- ⚙️ 自訂背景和邊距

---

## 🔄 F-Droid 日常使用

### 更新應用

#### 自動更新
- 如果啟用了「Auto-updates」，應用會自動更新
- 默認在 WiFi 連接時更新

#### 手動更新

1. 點擊 **「Updates」** 標籤
2. 查看可更新的應用
3. 點擊 **「Update」** 按鈕

### 查看應用詳情

1. 搜索並打開應用
2. 查看：
   - **Description** - 應用說明
   - **What's new** - 更新日誌
   - **Screenshots** - 截圖
   - **Permissions** - 所需權限
   - **Anti-Features** - 可能的問題

### 應用權限檢查

每個應用都會顯示所需權限，如：
- 📍 **位置** - 需要訪問位置信息
- 📱 **聯絡人** - 需要訪問聯絡人
- 📷 **攝像頭** - 需要訪問攝像頭
- 💾 **存儲** - 需要訪問存儲空間

**Termux 通常只需要存儲空間權限**

---

## 🛡️ F-Droid 安全建議

### 驗證 APK 簽名

F-Droid 的所有應用都經過簽名驗證：

1. **安全校驗**：每個 APK 都有數字簽名
2. **來源驗證**：確保應用來自官方開發者
3. **完整性檢查**：防止應用被篡改

**您可以放心安裝** ✅

### 防止釣魚

❌ **不要使用**：
- 偽造的「F-Droid」應用
- 來自第三方網站的 APK
- 聲稱提供 Google Play 替代品的應用

✅ **只使用**：
- 官方 https://f-droid.org/
- F-Droid 應用本身

---

## 🆘 常見問題

### Q1：F-Droid 無法更新倉庫？

**解決**：

```
Settings → Repositories → F-Droid

禁用然後重新啟用，強制重新同步
```

或連接不同的網路（WiFi/移動數據）。

### Q2：搜索不到 Termux？

**檢查**：

1. 倉庫已完整同步
   - 返回首頁，等待 1-2 分鐘
   - 或手動刷新（向下拖）

2. 輸入正確的名稱
   - 拼寫：「Termux」（區分大小寫）

3. 清除搜索快取
   ```
   Settings → Clear cache
   ```

### Q3：下載速度很慢？

**優化**：

1. **切換網路**
   - 嘗試使用移動數據代替 WiFi
   - 或反過來

2. **更換倉庫鏡像**
   - 某些地區可能有更快的鏡像
   - Settings → Repositories → 編輯 URL

3. **手動下載**
   - 通過電腦下載 APK
   - 傳輸到手機安裝

### Q4：提示「安裝失敗」？

**檢查**：

1. **儲存空間**
   - 設定 → 存儲空間 → 檢查可用空間
   - 至少需要 2GB 可用空間

2. **安卓版本**
   - 某些應用需要 Android 10+
   - 檢查設定 → 系統 → Android 版本

3. **重新啟動 F-Droid**
   - 完全關閉應用
   - 重新打開重試

### Q5：F-Droid 與 Google Play 可以並存嗎？

**可以**。兩個應用商店可以同時安裝和使用。

但對於 Termux：
- ✅ 使用 F-Droid 版本
- ❌ 不要同時安裝 Google Play 版本（會衝突）

---

## 📚 進階使用

### 添加第三方倉庫（高級用戶）

F-Droid 支援添加第三方倉庫，但**通常不需要**。

**如果需要**：

1. Settings → Repositories → 點擊「+」
2. 輸入倉庫 URL
3. 等待掃描和驗證

**常見安全倉庫**：
- Izzy on Deck: https://apt.izzysoft.de/fdroid/
- Guardian Project: https://guardianproject.info/fdroid/

### 離線使用 F-Droid

您可以下載 F-Droid 的完整倉庫離線使用：

1. 在電腦上下載倉庫數據
2. 傳輸到 Android 設備
3. 在 F-Droid 中指向本地倉庫

**詳見**：F-Droid 官方文檔

---

## 🌍 F-Droid 官方資源

### 官方網站
- **主站**：https://f-droid.org/
- **文檔**：https://f-droid.org/en/docs/

### 文檔
- **安裝指南**：https://f-droid.org/en/
- **常見問題**：https://f-droid.org/en/faq/
- **隱私政策**：https://f-droid.org/en/policies/

### 社群
- **GitHub**：https://github.com/f-droid/
- **Forum**：https://forum.f-droid.org/
- **Matrix**：#fdroid:matrix.org

---

## ✅ F-Droid 安裝檢查清單

- [ ] 訪問 https://f-droid.org/
- [ ] 下載 F-Droid.apk
- [ ] 允許安裝未知來源的應用
- [ ] 完成 F-Droid 安裝（約 1 分鐘）
- [ ] 打開 F-Droid
- [ ] 等待倉庫初始化（1-2 分鐘）
- [ ] 搜索 Termux（官方版本）
- [ ] 安裝 Termux（2-5 分鐘）
- [ ] 安裝 Termux:Boot（推薦）
- [ ] 安裝 Termux:Widget（推薦）
- [ ] 打開 Termux 驗證安裝成功
- [ ] 配置自動更新設置

✅ **全部完成後，準備安裝 OpenClaw！**

---

## 🔗 下一步

完成 F-Droid 和 Termux 安裝後：

1. ✅ F-Droid 安裝完成
2. ✅ Termux 安裝完成
3. 👉 [Android 快速開始](./android-quick-start.md) - 5 分鐘安裝 OpenClaw
4. 📖 [完整 Android 指南](./android-deployment-guide.md) - 詳細說明

---

## 📞 遇到問題？

### 檢查清單

- 使用的是 F-Droid 版本的 Termux？（不是 Google Play）
- F-Droid 已完整同步倉庫？
- 設備有充足的儲存空間？
- Android 版本 ≥ 10？

### 獲得幫助

1. **F-Droid 問題**：[F-Droid Forum](https://forum.f-droid.org/)
2. **Termux 問題**：[Termux Wiki](https://wiki.termux.com/)
3. **OpenClaw 問題**：[GitHub Issues](https://github.com/miaoxworld/OpenClawInstaller/issues)

---

**最後更新**：2026年2月7日
**版本**：1.0.0
