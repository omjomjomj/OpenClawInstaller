# 安卓部署 - 常見問題解答

## 🤔 基本問題

### Q1：OpenClaw 可以在安卓上運行嗎？

**回答**：OpenClaw 本身是 Node.js 應用，安卓不原生支援。但有以下方式可以使用：

1. ✅ **Termux + Node.js** - 在安卓上運行完整應用
2. ✅ **Docker on Termux** - 容器化部署
3. ✅ **遠程服務器** - 在云服務器上運行，安卓設備連接
4. ⏳ **原生應用**（開發中）- 計劃推出

**推薦**：Termux 方案最簡單，遠程服務器最穩定。

---

### Q2：我需要什麼硬體要求？

**最低要求**（Termux）：
- Android 10+
- 2GB+ RAM
- 2GB+ 儲存空間
- 穩定網路

**推薦配置**：
- Android 11+
- 4GB+ RAM（8GB 更佳）
- 5GB+ 儲存空間
- WiFi 連接

**遠程方案**：
- 任何 Android 設備都可以，甚至 1GB RAM

---

### Q3：Termux 是什麼？

**Termux** 是 Android 上的終端模擬器和 Linux 環境，允許您：
- 運行 Linux 命令
- 安裝開發工具（Node.js、Git 等）
- 執行服務器應用

**特點**：
- ✅ 開源、免費
- ✅ 無需 root 權限
- ✅ F-Droid 版本最穩定
- ✅ 支援完整的包管理器

---

### Q4：為什麼推薦從 F-Droid 下載而不是 Google Play？

Google Play 上的 Termux 已停止更新，且可能無法正常運行。

**正確做法**：
1. 安裝 [F-Droid](https://f-droid.org/)
2. 在 F-Droid 中搜索 "Termux"
3. 下載官方版本

**警告**：❌ 不要使用 Google Play 版本

---

## 📱 安裝相關

### Q5：安裝 Termux 後為什麼無法安裝 Node.js？

**常見原因**：

1. **Termux 未更新**
```bash
pkg update
pkg install -y nodejs-lts
```

2. **網路連接問題**
   - 確保 WiFi 已連接
   - 更換網路試試

3. **儲存空間不足**
```bash
df -h  # 檢查可用空間
```

4. **使用了錯誤的包名**
```bash
pkg search nodejs  # 列出所有 Node.js 版本
```

---

### Q6：一鍵安裝腳本無法執行？

**解決方法**：

```bash
# 手動執行每一步
pkg update
pkg upgrade -y
pkg install -y nodejs-lts git

mkdir -p ~/openclaw
cd ~/openclaw
git clone https://github.com/miaoxworld/OpenClawInstaller.git
cd OpenClawInstaller

npm install -g openclaw
```

**若仍失敗**，提供日誌：
```bash
npm install -g openclaw 2>&1 | tee install.log
```

---

### Q7：npm 安裝很慢？

**優化**：

1. **更換 npm 源**
```bash
npm config set registry https://registry.npmmirror.com
npm install -g openclaw
```

2. **清理快取**
```bash
npm cache clean --force
```

3. **使用 --no-optional 標誌**
```bash
npm install -g openclaw --no-optional
```

---

## 🚀 運行相關

### Q8：如何在後台運行 OpenClaw？

**方案 1：使用 nohup**
```bash
nohup openclaw gateway start > ~/.openclaw/logs/openclaw.log 2>&1 &
```

**方案 2：使用 screen**
```bash
pkg install -y screen
screen -S openclaw
openclaw gateway start
# 按 Ctrl+A，D 離開會話

# 恢復會話
screen -r openclaw
```

**方案 3：使用 Termux:Boot**（推薦）

見安裝指南的 Termux:Boot 部分

---

### Q9：啟動時出現「Address already in use」？

**問題**：埠口 18789 被佔用

**解決**：

```bash
# 檢查佔用進程
netstat -tuln | grep 18789

# 殺死進程
kill -9 [PID]

# 或更改埠口（編輯配置）
nano ~/.openclaw/config.yaml
# 改為 PORT=18790
```

---

### Q10：怎樣檢查 OpenClaw 是否正常運行？

**檢查列表**：

```bash
# 1. 檢查進程
ps aux | grep openclaw

# 2. 檢查埠口
netstat -tuln | grep 18789

# 3. 測試 API
curl http://localhost:18789/health

# 4. 查看日誌
tail -f ~/.openclaw/logs/openclaw.log

# 5. 查看狀態
openclaw gateway status
```

---

## 🌐 網路與訪問

### Q11：如何從其他設備訪問安卓上的 OpenClaw？

**獲取 IP 地址**：
```bash
hostname -I
```

**在其他設備上訪問**：
```
http://<安卓設備IP>:18789
```

**例如**：`http://192.168.1.100:18789`

---

### Q12：為什麼無法從其他設備訪問？

**檢查列表**：

1. **確保設備在同一網路**
   - 兩個設備連接同一 WiFi

2. **檢查防火牆**
```bash
# 查看防火牆狀態
iptables -L
```

3. **檢查 Termux 設置**
   - 設定 → 應用程式 → Termux → 權限 → 允許「附近裝置網路連接」

4. **測試連接**
```bash
# 在安卓上
curl http://localhost:18789/health

# 在其他設備上
ping <安卓IP>
```

---

### Q13：可以使用域名訪問嗎？

**是的**，但需要設置：

1. **配置 DNS**
   - 使用動態 DNS（如 DDNS）
   - 將域名指向安卓設備的 IP

2. **使用 Cloudflare Tunnel**
```bash
# 安裝 cloudflared
pkg install -y cloudflared

# 運行隧道
cloudflared tunnel run
```

3. **使用反向代理**
   - 配置 Nginx 或 Apache

---

## 💾 配置與數據

### Q14：配置文件在哪裡？

**位置**：
```
/data/data/com.termux/files/home/.openclaw/config.yaml
```

**快速訪問**：
```bash
nano ~/.openclaw/config.yaml
```

---

### Q15：如何備份配置？

**備份**：
```bash
# 打包整個配置目錄
tar czf ~/.openclaw-backup.tar.gz ~/.openclaw/

# 複製到 SD 卡
cp ~/.openclaw-backup.tar.gz /sdcard/

# 或通過 SCP 上傳
scp ~/.openclaw-backup.tar.gz user@server:/backup/
```

**恢復**：
```bash
# 從備份恢復
tar xzf ~/.openclaw-backup.tar.gz -C ~/
```

---

### Q16：如何遷移到新設備？

1. **備份舊設備**
```bash
tar czf config-backup.tar.gz ~/.openclaw/
```

2. **在新設備上安裝 Termux 和 OpenClaw**

3. **恢復配置**
```bash
tar xzf config-backup.tar.gz -C ~/
```

4. **驗證**
```bash
openclaw gateway start
```

---

## 🔧 故障排除

### Q17：OpenClaw 進程一直退出？

**檢查日誌**：
```bash
tail -200 ~/.openclaw/logs/openclaw.log
```

**常見原因**：

1. **配置文件錯誤**
   - 檢查 YAML 格式
   - 使用線上 YAML 驗證器

2. **API 密鑰無效**
   - 驗證密鑰正確性
   - 檢查 API 額度

3. **記憶體不足**
   - 檢查可用記憶體
   - 關閉其他應用

4. **埠口衝突**
   - 更改埠口設置

---

### Q18：應用在後台被殺死怎麼辦？

**Android 限制後台進程**，解決方案：

1. **禁止電池優化**
   - 設定 → 應用程式 → Termux
   - 電池 → 不優化

2. **固定應用**
   - 最近應用 → Termux → 固定

3. **使用 Termux:Boot**
   - 自動啟動服務

4. **使用服務器方案**
   - 部署在云服務器更穩定

---

### Q19：記憶體使用過高？

**檢查使用**：
```bash
free -h
ps aux | sort -k3 -r | head -10
```

**優化**：

1. **禁用不必要的功能**
```bash
export NODE_ENV=production
export OPENCLAW_WORKERS=1
```

2. **清理快取**
```bash
npm cache clean --force
```

3. **限制日誌級別**
```bash
export LOG_LEVEL=warn
```

4. **升級裝置或使用遠程方案**

---

### Q20：如何查看詳細日誌？

**查看日誌**：
```bash
# 最後 100 行
tail -100 ~/.openclaw/logs/openclaw.log

# 實時日誌
tail -f ~/.openclaw/logs/openclaw.log

# 搜索錯誤
grep ERROR ~/.openclaw/logs/openclaw.log

# 查看最近的日誌
ls -lt ~/.openclaw/logs/
```

---

## 🔐 安全相關

### Q21：如何保護 OpenClaw？

**建議**：

1. **限制網路訪問**
```bash
# 只允許本地連接
export HOST=127.0.0.1
```

2. **使用認證**
   - 配置 API Key
   - 在反向代理上添加密碼

3. **定期更新**
```bash
npm update -g openclaw
pkg upgrade
```

4. **備份敏感信息**
```bash
tar czf credentials-backup.tar.gz ~/.openclaw/credentials/
```

---

### Q22：API 密鑰會被暴露嗎？

**安全措施**：

1. **密鑰存儲**
   - 只存在本地配置文件
   - 不會上傳到云端

2. **限制權限**
   - 僅在設定的 API 級別使用
   - 定期輪換密鑰

3. **備份保護**
   - 備份時加密
   - 使用安全的傳輸方式

---

## 💡 優化與進階

### Q23：如何提升性能？

1. **系統優化**
```bash
# 禁用不必要的包
pkg uninstall -y [package]

# 清理系統
pkg clean
```

2. **Node.js 優化**
```bash
# 設置優化標誌
export NODE_OPTIONS='--max-old-space-size=512'
```

3. **應用優化**
```bash
# 禁用日誌
export LOG_LEVEL=error

# 使用 1 個 worker
export OPENCLAW_WORKERS=1
```

---

### Q24：如何自動啟動 OpenClaw？

**方案 1：Termux:Boot**（推薦）
```bash
mkdir -p ~/.termux/boot
echo "openclaw gateway start" > ~/.termux/boot/openclaw.sh
chmod +x ~/.termux/boot/openclaw.sh
```

**方案 2：Cron（如果支援）**
```bash
# 編輯 crontab（如果可用）
crontab -e
@reboot openclaw gateway start
```

**方案 3：Termux:Widget**
1. 添加主屏幕小部件
2. 配置運行 `openclaw gateway start`

---

### Q25：可以在多個設備上同步嗎？

**方案 1：遠程服務器**
- 所有設備連接同一個服務器
- 數據和配置自動同步

**方案 2：手動備份同步**
```bash
# 設備 A：備份
tar czf backup.tar.gz ~/.openclaw/

# 通過 SCP、Cloud 或其他方式傳輸

# 設備 B：恢復
tar xzf backup.tar.gz -C ~/
```

**方案 3：使用 Git**
```bash
# 將配置提交到 Git
git init ~/.openclaw
git add -A
git commit -m "Initial config"
git remote add origin [repo]
git push -u origin main
```

---

## 📖 相關資源

### 文檔
- [完整安卓指南](./android-deployment-guide.md)
- [快速開始](./android-quick-start.md)
- [Termux Wiki](https://wiki.termux.com/)
- [OpenClaw 文檔](../README.md)

### 工具
- [Termux](https://termux.com/)
- [F-Droid](https://f-droid.org/)
- [Termux:Boot](https://wiki.termux.com/wiki/Termux:Boot)
- [Termux:Widget](https://wiki.termux.com/wiki/Termux:Widget)

### 社群
- [GitHub Issues](https://github.com/miaoxworld/OpenClawInstaller/issues)
- [Termux Discord](https://discord.gg/HXpF69X)
- [Stack Overflow](https://stackoverflow.com/questions/tagged/termux)

---

## 🆘 未解決的問題？

1. **查看完整指南**：[android-deployment-guide.md](./android-deployment-guide.md)
2. **提交 Issue**：[GitHub Issues](https://github.com/miaoxworld/OpenClawInstaller/issues)
3. **查看日誌**：`tail -f ~/.openclaw/logs/openclaw.log`
4. **獲取系統信息**：`uname -a && free -h && df -h`

---

**最後更新**：2026年2月7日
**版本**：1.0.0
