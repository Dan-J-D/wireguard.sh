#!/bin/bash

# Configuration
CONTAINER_NAME="wireguard"
PEERS=1
PEERDNS="1.1.1.1"
CONFIG_DIR="./wireguard-config"
PORT_FILE="$CONFIG_DIR/.wg_port"

# Get public IP
get_public_ip() {
  curl -s https://api.ipify.org
}

# Generate or load a random port
get_random_port() {
  mkdir -p "$CONFIG_DIR"  # Ensure config directory exists

  if [ -f "$PORT_FILE" ]; then
    PORT=$(cat "$PORT_FILE")
  else
    PORT=$(( ( RANDOM % 64511 ) + 1024 )) # range 1024–65535
    echo "$PORT" > "$PORT_FILE"
  fi
  echo "$PORT"
}

# Start the container
start_wireguard() {
  SERVER_IP=$(get_public_ip)
  SERVER_PORT=$(get_random_port)

  echo "Starting WireGuard on public IP: $SERVER_IP, port: $SERVER_PORT"

  docker run -d \
    --cap-add=NET_ADMIN \
    --cap-add=SYS_MODULE \
    -v /lib/modules:/lib/modules \
    -v "$CONFIG_DIR":/config \
    -e PEERS=$PEERS \
    -e PEERDNS=$PEERDNS \
    -e SERVERURL="$SERVER_IP" \
    -e SERVERPORT=$SERVER_PORT \
    -e LOG_CONFS=true \
    -p "$SERVER_PORT":51820/udp \
    --name "$CONTAINER_NAME" \
    linuxserver/wireguard
}

# Stop and remove the container
stop_wireguard() {
  echo "Stopping WireGuard container..."
  docker stop "$CONTAINER_NAME" 2>/dev/null
  docker rm "$CONTAINER_NAME" 2>/dev/null
}

# Stop container and delete config directory
delete_wireguard() {
  echo "⚠️ This will stop the container and delete all configuration files in $CONFIG_DIR."
  read -p "Are you sure you want to proceed? (y/N): " confirm
  if [ "$confirm" = "y" ] || [ "$confirm" = "Y" ]; then
    stop_wireguard
    rm -rf "$CONFIG_DIR"
    echo "✅ WireGuard deleted."
  else
    echo "❌ Cancelled."
  fi
}

# Main script logic
case "$1" in
  up)
    start_wireguard
    ;;
  down)
    stop_wireguard
    ;;
  delete)
    delete_wireguard
    ;;
  *)
    echo "Usage: $0 {up|down|delete}"
    exit 1
    ;;
esac
