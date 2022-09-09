from ubuntu:20.04

LABEL maintainer="VergilGao"
LABEL org.opencontainers.image.source="https://github.com/VergilGao/docker-openwrt-compiler"
LABEL org.opencontainers.image.description "通过docker来构建你的openwrt固件"

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
	apt-get -y install --no-install-recommends \
        build-essential \
        asciidoc \
        binutils \
        bzip2 \
        gawk \
        gettext \
        git \
        libncurses5-dev \
        libz-dev \
        patch \
        python3 \
        python2.7 \
        unzip \
        zlib1g-dev \
        lib32gcc1 \
        libc6-dev-i386 \
        subversion \
        flex \
        uglifyjs \
        git-core \
        gcc-multilib \
        p7zip \
        p7zip-full \
        msmtp \
        libssl-dev \
        texinfo \
        libglib2.0-dev \
        xmlto \
        qemu-utils \
        upx \
        libelf-dev \
        autoconf \
        automake \
        libtool \
        autopoint \
        device-tree-compiler \
        g++-multilib \
        antlr3 \
        gperf \
        wget \
        curl \
        swig \
        rsync \
        gosu && \
    rm -rf /var/lib/apt/lists/*

ENV UMASK=000
ENV UID=99
ENV GID=100
ENV DATA_PERM=770
ENV TZ="Asia/Shanghai"

ENV REPO_URL=https://github.com/openwrt/openwrt
ENV REPO_BRANCH=openwrt-21.02
ENV DEVICE_NAME="Generic"

RUN mkdir -p /config /build /src /opt/scripts && \
    useradd -d /config -s /bin/bash user && \
    chown -R user /config /src && \
    ulimit -n 2048

ADD /scripts/*.sh /opt/scripts/
RUN chmod -R 770 /opt/scripts/

VOLUME [ "/src", "/config", "/build" ]

ENTRYPOINT ["/opt/scripts/docker-entrypoint.sh"]
