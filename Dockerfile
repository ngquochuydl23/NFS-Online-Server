FROM python:3.12-slim

ENV PYTHONUNBUFFERED=1 \
    PYTHONDONTWRITEBYTECODE=1 \
    PIP_NO_CACHE_DIR=1

WORKDIR /app

# Server runtime: launcher, service modules, config, seed data and client INIs.
COPY nfs_online.py ./
COPY server ./server
COPY config ./config
COPY data ./data
COPY clients ./clients
# Required by the launcher's package layout check (build.zig); Zig toolchain
# is not needed at server runtime.
COPY source ./source

# Writable runtime directories (created so a bind-mount doesn't fail).
RUN mkdir -p runtime logs

COPY docker/entrypoint.sh /usr/local/bin/nfs-entrypoint
RUN chmod +x /usr/local/bin/nfs-entrypoint

# The server binds many TCP/UDP ports; see README "Default ports".
# Expose the most common set here and map them in docker run / compose.
EXPOSE 13505/tcp \
       20921/tcp 20922/tcp 20923/tcp \
       30920/tcp 30921/tcp \
       18210/tcp 18215/tcp \
       9000/tcp \
       20000/udp 19119/udp

ENTRYPOINT ["/usr/local/bin/nfs-entrypoint"]
