#!/bin/bash

NAME=connect_jxyy_network
BINDIR=bin
VERSION=$(git describe --tags || echo "unknown version")
BUILDTIME=$(date -u)
GOBUILD="CGO_ENABLED=0 go build -trimpath -ldflags '-X \"github.com/wochaoop/connect_jxyy_network/constant.Version=${VERSION}\" \
  -X \"github.com/wochaoop/connect_jxyy_network/constant.BuildTime=${BUILDTIME}\" \
  -w -s -buildid='"

PLATFORM_LIST=(
    aix-ppc64
    android-arm64
    darwin-amd64
    darwin-arm64
    dragonfly-amd64
    freebsd-386
    freebsd-amd64
    freebsd-arm
    freebsd-arm64
    freebsd-riscv64
    illumos-amd64
    ios-amd64
    ios-arm64
    linux-386
    linux-amd64
    linux-arm
    linux-arm64
    linux-loong64
    linux-mips
    linux-mips64
    linux-mips64le
    linux-mipsle
    linux-ppc64
    linux-ppc64le
    linux-riscv64
    linux-s390x
    netbsd-386
    netbsd-amd64
    netbsd-arm
    netbsd-arm64
    openbsd-386
    openbsd-amd64
    openbsd-arm
    openbsd-arm64
    openbsd-ppc64
    plan9-386
    plan9-amd64
    plan9-arm
    solaris-amd64
    windows-386
    windows-amd64
    windows-amd64-v3
    windows-arm64
    windows-armv7
    js-wasm
    wasip1-wasm
)

for platform in "${PLATFORM_LIST[@]}"; do
    os=${platform%-*}
    arch=${platform#*-}
    if [[ $os == "windows" ]]; then
        cmd="GOARCH=$arch GOOS=$os ${GOBUILD} -o ${BINDIR}/${platform}/${NAME}.exe"
        eval $cmd
        upx -9 ${BINDIR}/${platform}/${NAME}.exe
        zip -m -j ${BINDIR}/${platform}/${NAME}-${VERSION}.zip ${BINDIR}/${platform}/${NAME}.exe
        mv ${BINDIR}/${platform}/${NAME}-${VERSION}.zip ${BINDIR}/${NAME}-${platform}-${VERSION}.zip
    elif [[ $os == "js" ]]; then
        cmd="GOARCH=$arch GOOS=$os ${GOBUILD} -o ${BINDIR}/${platform}/${NAME}.wasm"
        eval $cmd
        upx -9 ${BINDIR}/${platform}/${NAME}.wasm
        mv ${BINDIR}/${platform}/${NAME}.wasm ${BINDIR}/${NAME}-${platform}.wasm
    else
        cmd="GOARCH=$arch GOOS=$os ${GOBUILD} -o ${BINDIR}/${platform}/${NAME}"
        eval $cmd
        upx -9 ${BINDIR}/${platform}/${NAME}
        gzip -f -S -${VERSION}.gz ${BINDIR}/${platform}/${NAME}
        mv ${BINDIR}/${platform}/${NAME}-${VERSION}.gz ${BINDIR}/${NAME}-${platform}-${VERSION}.gz
    fi
    rm -r ${BINDIR}/${platform}
done
