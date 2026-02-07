# Windows 10 Pro - Docker 部署指南

## 📋 目錄
1. [前置要求](#前置要求)
2. [Docker Desktop 安裝](#docker-desktop-安裝)
3. [OpenClaw 部署步驟](#openclaw-部署步驟)
4. [配置 API 密鑰](#配置-api-密鑰)
5. [常見問題](#常見問題)
6. [進階配置](#進階配置)

---

## 前置要求

### 系統要求
- **作業系統**: Windows 10 Pro（版本 20H2 或更新）
- **CPU**: 支援虛擬化（Intel VT-x 或 AMD-V）
- **RAM**: 4GB 最小，8GB 或以上推薦
- **磁碟**: 10GB 可用空間

### 檢查虛擬化支援

**在 Windows 上檢查虛擬化：**

1. 按 `Win + R`，輸入 `taskmgr`
2. 打開「效能」→「CPU」
3. 確認「虛擬化」為「已啟用」

如果未啟用，需要在 BIOS 中啟用（主機重啟時進入 BIOS 設置）

---

## Docker Desktop 安裝

### 步驟 1：下載 Docker Desktop

1. 訪問 [Docker 官方網站](https://www.docker.com/products/docker-desktop)
2. 點擊「Download for Windows」
3. 下載 `Docker Desktop Installer.exe`（~600MB）

### 步驟 2：安裝 Docker Desktop

1. 執行安裝程式
2. 勾選「Install required Windows components for WSL 2」
3. 完成安裝後，重啟電腦

### 步驟 3：驗證安裝

打開 PowerShell（以管理員身份），執行：

```powershell
docker --version
docker run hello-world
```

如果看到歡迎訊息，表示 Docker 安裝成功。

---

## OpenClaw 部署步驟

### 步驟 1：準備工作目錄

在合適的位置建立目錄，例如 `C:\OpenClaw`：

```powershell
mkdir C:\OpenClaw
cd C:\OpenClaw
```

### 步驟 2：取得專案文件

**方案 A：使用 Git Clone（推薦）**

```powershell
git clone https://github.com/miaoxworld/OpenClawInstaller.git
cd OpenClawInstaller
```

**方案 B：手動下載**

1. 訪問 [GitHub 儲存庫](https://github.com/miaoxworld/OpenClawInstaller)
2. 點擊 `Code` → `Download ZIP`
3. 解壓到 `C:\OpenClaw\`

### 步驟 3：複製配置文件

```powershell
# 複製配置範例
Copy-Item examples\config.example.yaml -Destination C:\OpenClaw\.openclaw\config.yaml
```

或手動：
1. 複製 `examples/config.example.yaml`
2. 放到 `C:\Users\[你的用戶名]\.openclaw\` 目錄（不存在則建立）
3. 重命名為 `config.yaml`

### 步驟 4：啟動 Docker 容器

在 `OpenClawInstaller` 目錄中執行：

```powershell
docker-compose up -d
```

### 步驟 5：驗證部署

```powershell
# 檢查容器狀態
docker-compose ps

# 查看日誌
docker-compose logs -f openclaw

# 等待應用啟動（約 1-2 分鐘）
# 看到 "Server is running" 訊息即表示成功
```

---

## 配置 API 密鑰

### 編輯配置文件

配置文件位置：
- **Windows**: `C:\Users\[用戶名]\.openclaw\config.yaml`
- **Docker 容器內**: `/root/.openclaw/config.yaml`

### 支援的 AI 模型

編輯 `config.yaml`，在 `models` 區段中配置：

```yaml
models:
  # Anthropic Claude
  anthropic:
    api_key: "sk-ant-..."
    model: "claude-3-5-sonnet-20241022"
    base_url: ""  # 保留空白使用官方 API

  # OpenAI GPT
  openai:
    api_key: "sk-..."
    model: "gpt-4o"
    base_url: ""

  # Google Gemini
  google:
    api_key: "AIzaSy..."
    model: "gemini-2.0-flash"

  # 其他模型（可選）
  groq:
    api_key: "gsk_..."
    model: "mixtral-8x7b-32768"

  # 本地模型（Ollama）
  ollama:
    base_url: "http://ollama:11434"
    model: "llama2"
```

### 取得 API 密鑰

| 服務 | 取得方式 |
|------|--------|
| **Claude** | https://console.anthropic.com/keys |
| **OpenAI** | https://platform.openai.com/api-keys |
| **Gemini** | https://aistudio.google.com/apikey |
| **Groq** | https://console.groq.com/keys |

### 套用配置

配置文件修改後，需要重啟容器：

```powershell
docker-compose restart openclaw

# 等待啟動完成
docker-compose logs -f openclaw
```

---

## 常見問題

### Q1：Docker 容器無法啟動

**檢查日誌：**
```powershell
docker-compose logs openclaw
```

**常見原因：**
- 虛擬化未啟用 → 重啟並在 BIOS 中啟用
- 埠口佔用 → 修改 `docker-compose.yml` 中的埠口映射
- Docker Desktop 未執行 → 重啟 Docker Desktop

### Q2：無法連接到容器

```powershell
# 測試連接
curl http://localhost:18789/health

# 重啟容器
docker-compose restart
```

### Q3：配置文件未被讀取

```powershell
# 檢查配置卷掛載
docker-compose ps

# 進入容器檢查
docker exec openclaw cat /root/.openclaw/config.yaml
```

### Q4：API 密鑰驗證失敗

1. 確認密鑰正確無誤
2. 確認 API 配額未用盡
3. 檢查網路連接
4. 查看詳細日誌：
   ```powershell
   docker-compose logs -f openclaw | Select-String "error"
   ```

### Q5：提升記憶體或 CPU 分配

編輯 `docker-compose.yml` 中的資源限制：

```yaml
services:
  openclaw:
    deploy:
      resources:
        limits:
          cpus: '2'
          memory: 4G
        reservations:
          cpus: '1'
          memory: 2G
```

---

## 進階配置

### 啟用本地模型（Ollama）

在 `docker-compose.yml` 中取消註釋 Ollama 服務：

```yaml
  ollama:
    image: ollama/ollama:latest
    container_name: ollama
    ports:
      - "11434:11434"
    volumes:
      - ollama-data:/root/.ollama
    networks:
      - openclaw-network
```

執行：
```powershell
docker-compose up -d
docker exec ollama ollama pull llama2
```

### 掛載自訂技能目錄

在 `docker-compose.yml` 中添加：

```yaml
volumes:
  - ~/.openclaw:/root/.openclaw
  - C:\MySkills:/root/.openclaw/custom-skills  # 自訂路徑
```

### 配置時區

編輯 `docker-compose.yml`：

```yaml
environment:
  - TZ=Asia/Taipei  # 改為你的時區
```

### 持久化數據

數據自動儲存在：
- `~/.openclaw/config.yaml` - 配置文件
- `~/.openclaw/data/` - 數據文件
- `~/.openclaw/logs/` - 日誌文件

### 備份配置

```powershell
# 備份配置和數據
docker-compose exec openclaw tar czf /root/.openclaw/backup-$(Get-Date -Format "yyyyMMdd").tar.gz /root/.openclaw/
```

---

## 日常操作命令

```powershell
# 啟動服務
docker-compose up -d

# 停止服務
docker-compose down

# 查看日誌
docker-compose logs -f openclaw

# 重啟服務
docker-compose restart

# 進入容器終端
docker exec -it openclaw bash

# 查看容器狀態
docker-compose ps

# 檢查健康狀態
docker exec openclaw openclaw health

# 更新鏡像
docker-compose pull
docker-compose up -d --build
```

---

## 網路存取

### 本地存取

在 Windows 上存取應用：
```
http://localhost:18789
```

### 遠端存取（同區域網路）

獲取 Windows IP：
```powershell
ipconfig
```

在其他設備上存取：
```
http://<Windows-IP>:18789
```

---

## 故障排除

### 收集診斷信息

```powershell
# 收集容器日誌和系統信息
docker-compose logs > logs.txt
docker ps -a >> logs.txt
docker stats --no-stream >> logs.txt
```

### 清除快取並重新啟動

```powershell
docker-compose down
docker system prune -a
docker-compose pull
docker-compose up -d --build
```

---

## 下一步

1. ✅ 部署完成後，配置你的 AI 模型
2. 📱 設置 Telegram/Discord 機器人連接
3. 🎯 編寫自訂技能和工作流程
4. 📊 監控日誌和性能

查看 [主 README](../README.md) 了解更多功能。
