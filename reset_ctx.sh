#!/usr/bin/env bash
set -euo pipefail

# Settings
CONTAINER_NAME="cmd-line-ctx"
IMAGE_NAME="cmd-line-ctx:latest"
HOST_PORT=2222
CTX_PASSWORD="cyberctx"
FILE_PERMS=600

# Paths (assume running from project root where user_list.txt and ctx/ exist)
USER_LIST="$PWD/user_list.txt"
SEED_DIR="$PWD/ctx"

echo "[*] Stopping and removing old container (if exists)..."
docker rm -f "$CONTAINER_NAME" >/dev/null 2>&1 || true

echo "[*] Rebuilding image..."
docker build -t "$IMAGE_NAME" .

echo "[*] Starting new container..."
docker run -d \
  --name "$CONTAINER_NAME" \
  -p ${HOST_PORT}:22 \
  -e CTX_PASSWORD="$CTX_PASSWORD" \
  -e FILE_PERMS="$FILE_PERMS" \
  -v "$USER_LIST":/etc/ctx/users.txt:ro \
  -v "$SEED_DIR":/seed/ctx:ro \
  "$IMAGE_NAME"

echo "[*] Container '$CONTAINER_NAME' is up."
echo "    SSH to: ssh -p ${HOST_PORT} user1@<your-ip>"
echo "    Password for all users: $CTX_PASSWORD"
