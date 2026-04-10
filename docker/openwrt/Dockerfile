# 使用一个稳定版的 Ubuntu 作为基础镜像
FROM ubuntu:noble

# 添加 OCI 标签以自动关联 GitHub 仓库
# 请确保将下面的 URL 替换为您自己的仓库地址
LABEL org.opencontainers.image.source="https://github.com/qqhpc/openwrt"

# 接收从 docker build 命令传递进来的用户和组ID
ARG UID=1000
ARG GID=1000

# 设置环境变量，避免 apt 安装时出现交互式提示
ENV DEBIAN_FRONTEND=noninteractive

# 更新apt源并安装所有编译依赖项
# 这是您提供的一长串依赖列表
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    build-essential asciidoc ack antlr3 autoconf automake autopoint binutils bison \
    bzip2 ccache cmake cpio curl device-tree-compiler fastjar flex gawk gettext \
    gcc-multilib g++-multilib git gperf haveged help2man intltool libc6-dev-i386 \
    libelf-dev libglib2.0-dev libgmp3-dev libltdl-dev libmpc-dev libmpfr-dev \
    libncurses5-dev libncursesw5-dev libreadline-dev libssl-dev libtool lrzsz \
    mkisofs msmtp nano ninja-build p7zip p7zip-full patch pkgconf python3 \
    python3-pip python3-setuptools python3-yaml qemu-utils rsync scons \
    squashfs-tools subversion swig texinfo time uglifyjs upx-ucl unzip vim \
    wget xmlto xxd zlib1g-dev clang && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# 创建一个与宿主机ID匹配的、健壮的非root用户 (强制覆盖)
RUN groupadd --force -g $GID builder && \
    useradd --no-log-init --non-unique --no-create-home --home /home/builder --shell /bin/bash -u $UID -g $GID builder

# 切换到 builder 用户
USER builder

# 设置工作目录
WORKDIR /home/builder

# 将我们的编译脚本复制到镜像中，并赋予执行权限
COPY --chown=builder:builder build-openwrt.sh /home/builder/build-openwrt.sh
RUN chmod +x /home/builder/build-openwrt.sh

# 设置容器启动时要执行的命令
ENTRYPOINT ["/home/builder/build-openwrt.sh"]