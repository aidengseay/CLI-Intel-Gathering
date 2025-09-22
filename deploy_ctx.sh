#!/bin/bash
set -euo pipefail

USERS_FILE="${USERS_FILE:-/etc/ctx/users.txt}"
SEED_DIR="${SEED_DIR:-/seed/ctx}"
TARGET_BASENAME="${TARGET_BASENAME:-ctx}"

if [ ! -f "$USERS_FILE" ]; then
  echo "No users file at $USERS_FILE"; exit 1
fi

while IFS= read -r username || [[ -n "${username:-}" ]]; do
  [ -z "${username}" ] && continue

  if ! id "$username" &>/dev/null; then
    useradd -m -s /bin/bash "$username"
  fi

  echo "${username}:${CTX_PASSWORD}" | chpasswd

  HOME_DIR="/home/$username"
  chmod 700 "$HOME_DIR"
  chown "$username:$username" "$HOME_DIR"

  if [ -d "$SEED_DIR" ]; then
    rm -rf "$HOME_DIR/$TARGET_BASENAME"
    cp -a "$SEED_DIR" "$HOME_DIR/$TARGET_BASENAME"

    # Give user ownership of everything by default
    chown -R "$username:$username" "$HOME_DIR/$TARGET_BASENAME"
  fi

  echo "Deployed $TARGET_BASENAME for $username"
done < "$USERS_FILE"

echo "Deployment complete."
