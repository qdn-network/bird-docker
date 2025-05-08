FROM registry.tsingyao.com/library/debian:bookworm AS base
LABEL maintainer=yujintong@126.com

RUN apt-get update && apt-get -y upgrade

RUN apt-get install -y vim libreadline-dev libncurses-dev libssh-dev libc-dev

# Add some stuff for debugging network
RUN apt-get install -y tcpdump netcat-openbsd mtr traceroute procps inetutils-ping telnet

RUN mkdir -p /run/bird && mkdir -p /etc/bird && mkdir -p /var/log/bird && mkdir -p /usr/share/bird2
RUN groupadd -r bird --gid=900 && useradd -r -g bird --uid=900 bird

# 设置时区
ENV TZ=Asia/Shanghai
RUN echo $TZ > /etc/timezone && dpkg-reconfigure -f noninteractive tzdata



FROM base AS compiler

# 安装编译相关的软件
RUN apt-get install -y \
    git \
    vim \
    wget \
    curl \
    autoconf \
    bison \
    build-essential \
    flex \
    libreadline-dev \
    libncurses-dev \
    libssh-dev \
    m4 \
    unzip

# Bird2
WORKDIR /tmp
ARG BIRDV=2.17.1
RUN wget https://bird.network.cz/download/bird-${BIRDV}.tar.gz
RUN tar -xvzf bird-${BIRDV}.tar.gz

# make
WORKDIR /tmp/bird-${BIRDV}
RUN ./configure --prefix=/usr --sysconfdir=/etc/bird --localstatedir=/var --enable-debug --with-runtimedir=/run/bird
RUN make



FROM base AS final
ARG BIRDV=2.17.1

COPY --from=compiler /tmp/bird-${BIRDV}/bird /tmp/bird-${BIRDV}/birdc /tmp/bird-${BIRDV}/birdcl /usr/sbin/

COPY docker-entrypoint.sh /docker-entrypoint.sh

RUN chmod +x /docker-entrypoint.sh

COPY bird.conf /usr/share/bird2
COPY envvars /usr/share/bird2

EXPOSE 179

HEALTHCHECK --interval=15s --timeout=5s \
    CMD  birdc show status | grep -q ^up || exit 1

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["bird"]
