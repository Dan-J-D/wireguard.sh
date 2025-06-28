# 🛡️ WireGuard Docker Setup Script
Easily deploy and manage a WireGuard VPN server inside Docker 🐳 with dynamic public IP detection and random port assignment — all automated by a simple Bash script.

## ✨ Features
- 🌐 Automatically detects your public IP
- 🎲 Generates & persists a random WireGuard port (1024–65535)
- ▶️ Start, 🛑 stop, and 🗑️ delete the WireGuard Docker container with ease
- 📁 Stores all configs and port info in a dedicated folder (`./wireguard-config`)
- 🧰 Simple CLI interface for common operations

## 📋 Requirements
- 🐳 [Docker](https://docs.docker.com/engine/install/)
- 🌐 `curl` (`apt install curl`)

## ⚡ Installation
Get started in seconds by downloading the script with curl:

```bash
curl -o wireguard.sh https://raw.githubusercontent.com/Dan-J-D/wireguard.sh/main/wireguard.sh
chmod +x wireguard.sh
```

## 🛠 Usage
| Command             | Description                                               |
|---------------------|-----------------------------------------------------------|
| `wireguard.sh up`     | ▶️ Start the WireGuard server container                    |
| `wireguard.sh down`   | 🛑 Stop and remove the WireGuard container                 |
| `wireguard.sh delete` | 🗑️ Stop container and delete all configs (w/ confirmation) |

## ⚙️ Configuration
Customize these variables at the top of the script to tailor your setup:

| Variable   | Default                    | Description                         |
|------------|----------------------------|-------------------------------------|
| `CONFIG_DIR` | ./wireguard-config         | 📂 Directory to store configs & port |
| `PEERS`      | 1                          | 👥 Number of peers created on start  |
| `PEERDNS`    | 1.1.1.1 (Cloudflare's DNS) | 🌐 DNS server IP assigned to peers   |
