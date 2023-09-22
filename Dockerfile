# 阶段一：构建阶段
FROM golang:1.21.1-alpine3.18 AS builder

# 安装 UPX 压缩工具
RUN apk --no-cache add curl xz && \
    curl -L -o upx.tar.xz https://github.com/upx/upx/releases/latest/download/upx-4.1.0-amd64_linux.tar.xz && \
    tar -xJf upx.tar.xz && \
    mv upx-*-amd64_linux/upx /usr/local/bin/ && \
    rm -rf upx.tar.xz upx-*

# 设置工作目录
WORKDIR /build

# 复制Go程序文件到容器中
COPY . .

# 构建Go程序
RUN go build -o connect_jxyy_network

# 压缩可执行文件
- RUN upx -9 connect_jxyy_network

# 阶段二：运行阶段
FROM alpine:latest

# 设置工作目录
WORKDIR /app

# 从第一阶段中复制生成的可执行文件到当前容器
COPY --from=builder /build/connect_jxyy_network /app/connect_jxyy_network

# 定义启动容器时运行的命令
CMD ["/app/connect_jxyy_network"]
