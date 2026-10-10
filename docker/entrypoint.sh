#!/usr/bin/env sh
set -eu

cd /app

# Allow the public hostname to be set from the environment on first start.
if [ -n "${PUBLIC_HOST:-}" ]; then
    echo "Configuring PUBLIC_HOST=${PUBLIC_HOST}"
    python3 nfs_online.py configure --public-host "$PUBLIC_HOST"
fi

GAMES="${GAMES:-}"

# The launcher runs an interactive console that reads commands from stdin. Use a
# named pipe so the console stays alive in a container (no terminal) and we can
# trigger a graceful shutdown by writing "quit".
FIFO=/tmp/nfs-console
rm -f "$FIFO"
mkfifo "$FIFO"

if [ -n "$GAMES" ]; then
    python3 nfs_online.py start --games "$GAMES" < "$FIFO" &
else
    python3 nfs_online.py start < "$FIFO" &
fi
PID=$!

# Opening the write end also keeps stdin open (no EOF), so the console blocks.
exec 3>"$FIFO"

stop_server() {
    printf 'quit\n' >&3 2>/dev/null || true
}
trap stop_server TERM INT

# Wait for the launcher to exit. Signals interrupt wait, so loop until the
# process is actually gone (graceful shutdown may take a moment).
while kill -0 "$PID" 2>/dev/null; do
    wait "$PID" || true
done
