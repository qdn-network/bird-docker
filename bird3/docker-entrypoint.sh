#!/bin/bash

set -e

if [ "$1" = 'bird' ]; then

    BIRD_RUN_DIR=/run/bird
    mkdir --parents "$BIRD_RUN_DIR";

    # 配置文件目录
    BIRD_CONF_DIR=/etc/bird
    mkdir --parents "$BIRD_CONF_DIR";

    # 日志目录
    BIRD_LOG_DIR=/var/log/bird
    mkdir --parents "$BIRD_LOG_DIR";

    # 服务运行用户及用户组
    BIRD_RUN_USER=bird
    BIRD_RUN_GROUP=bird

    if [ ! -f "/etc/bird/bird.conf" ]; then
        cp -vf /usr/share/bird3/bird.conf /etc/bird
    fi

    chown -R --silent "$BIRD_RUN_USER:$BIRD_RUN_GROUP" "$BIRD_RUN_DIR"
    chown -R --silent "$BIRD_RUN_USER:$BIRD_RUN_GROUP" "$BIRD_CONF_DIR"
    chown -R --silent "$BIRD_RUN_USER:$BIRD_RUN_GROUP" "$BIRD_LOG_DIR"
    chmod 775 "$BIRD_RUN_DIR"

    if [ -d /docker-entrypoint.d ]; then
        for f in /docker-entrypoint.d/*.sh; do
            [ -f "$f" ] && . "$f"
        done
    fi

    if [ -n "$BIRD_ARGS" ]; then
        exec /usr/sbin/bird -f -u $BIRD_RUN_USER -g $BIRD_RUN_GROUP $BIRD_ARGS
    else
        exec /usr/sbin/bird -f -u $BIRD_RUN_USER -g $BIRD_RUN_GROUP
    fi

fi

exec "$@"
