#!/bin/bash

set -eu

BIRD_RUN_DIR=/run/bird

if [ "$1" = 'bird' ]; then
    if [ ! -f "/etc/bird/bird.conf" ]; then
        #mkdir -p "$BIRD_CONF_DIR";
        #mkdir -p "$BIRD_LOG_DIR";
        #mkdir -p "$BIRD_RUN_DIR";
        cp -vf /usr/share/bird3/bird.conf /etc/bird
        cp -vf /usr/share/bird3/envvars /etc/bird
    fi

    # 引入环境变量
    . /etc/bird/envvars

    chown -R --silent "$BIRD_RUN_USER:$BIRD_RUN_GROUP" "$BIRD_CONF_DIR"
    chown -R --silent "$BIRD_RUN_USER:$BIRD_RUN_GROUP" "$BIRD_LOG_DIR"
    chown -R --silent "$BIRD_RUN_USER:$BIRD_RUN_GROUP" "$BIRD_RUN_DIR"
    chmod 775 "$BIRD_RUN_DIR"

    if [ -d /docker-entrypoint.d ]; then
        for f in /docker-entrypoint.d/*.sh; do
            [ -f "$f" ] && . "$f"
        done
    fi
    exec /usr/sbin/bird -f -u $BIRD_RUN_USER -g $BIRD_RUN_GROUP $BIRD_ARGS
fi

exec "$@"
