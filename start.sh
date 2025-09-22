#!/bin/bash
set -euo pipefail

# Default password and users file; can be overridden via docker -e
CTX_PASSWORD="${CTX_PASSWORD:-cyberctx}"
USERS_FILE="${USERS_FILE:-/etc/ctx/users.txt}"
SEED_DIR="${SEED_DIR:-/seed/ctx}"
FILE_PERMS="${FILE_PERMS:-600}"

# Ensure seed dir exists (mounted from host)
mkdir -p "$SEED_DIR" || true

# Put users file in place if container not started with one (already copied by Dockerfile)
[ -f "$USERS_FILE" ] || printf "user1\nuser2\nuser3\nuser4\nuser5\nuser6\nuser7\nuser8\nuser9\nuser10\n" > "$USERS_FILE"

# Allow password auth
sed -i 's/^#\?PasswordAuthentication.*/PasswordAuthentication yes/' /etc/ssh/sshd_config
sed -i 's/^#\?PermitRootLogin.*/PermitRootLogin no/' /etc/ssh/sshd_config

export CTX_PASSWORD USERS_FILE SEED_DIR FILE_PERMS

# Deploy the ctx content into each user's home (sets ownership and perms)
echo "[ctx] deploying challenges..."
/usr/local/bin/deploy_ctx.sh

# Create a fake ps aux process that contains a FLAG. You can change the flag text.
# We use exec -a to change the argv[0] shown by ps.
FLAG_PS="flag{5c269c3e-fe60-47be-9d22-e9e65a010d46}"
bash -c "exec -a \"flag_process [${FLAG_PS}]\" sleep infinity" &

# Optional: create a simple MOTD
echo "Welcome to the CLI CTX. SSH with your username and password." >/etc/motd

# Start sshd (foreground)
exec /usr/sbin/sshd -D -e
