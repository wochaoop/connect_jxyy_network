NAME=connect_jxyy_network
BINDIR=bin
VERSION=$(shell git describe --tags || echo "unknown version")
BUILDTIME=$(shell date -u)
GOBUILD=CGO_ENABLED=0 go build -trimpath -ldflags '-X "github.com/wochaoop/connect_jxyy_network/constant.Version=$(VERSION)" \
		-X "github.com/wochaoop/connect_jxyy_network/constant.BuildTime=$(BUILDTIME)" \
		-w -s -buildid='

PLATFORM_LIST = \
	aix-ppc64 \
    android-arm64 \
    darwin-amd64 \
    darwin-arm64 \
    dragonfly-amd64 \
    freebsd-386 \
    freebsd-amd64 \
    freebsd-arm \
    freebsd-arm64 \
    freebsd-riscv64 \
    illumos-amd64 \
    ios-amd64 \
    ios-arm64 \
    linux-386 \
    linux-amd64 \
    linux-arm \
    linux-arm64 \
    linux-loong64 \
    linux-mips \
    linux-mips64 \
    linux-mips64le \
    linux-mipsle \
    linux-ppc64 \
    linux-ppc64le \
    linux-riscv64 \
    linux-s390x \
    netbsd-386 \
    netbsd-amd64 \
    netbsd-arm \
    netbsd-arm64 \
    openbsd-386 \
    openbsd-amd64 \
    openbsd-arm \
    openbsd-arm64 \
    openbsd-ppc64 \
    plan9-386 \
    plan9-amd64 \
    plan9-arm \
    solaris-amd64

WINDOWS_ARCH_LIST = \
	windows-386 \
	windows-amd64 \
	windows-amd64-v3 \
	windows-arm64 \
	windows-armv7

WASM_LIST = \
	js-wasm \
	wasip1-wasm

all: linux-amd64 darwin-amd64 windows-amd64 # Most used

aix-ppc64:
	GOARCH=ppc64 GOOS=aix $(GOBUILD) -o $(BINDIR)/$(basename $@)/$(NAME)

android-386:
	GOARCH=386 GOOS=android $(GOBUILD) -o $(BINDIR)/$(basename $@)/$(NAME)

android-amd64:

android-arm:
	GOARCH=arm GOOS=android $(GOBUILD) -o $(BINDIR)/$(basename $@)/$(NAME)

android-arm64:
	GOARCH=arm64 GOOS=android $(GOBUILD) -o $(BINDIR)/$(basename $@)/$(NAME)

darwin-amd64:
	GOARCH=amd64 GOOS=darwin $(GOBUILD) -o $(BINDIR)/$(basename $@)/$(NAME)

darwin-arm64:
	GOARCH=arm64 GOOS=darwin $(GOBUILD) -o $(BINDIR)/$(basename $@)/$(NAME)

dragonfly-amd64:
	GOARCH=amd64 GOOS=dragonfly $(GOBUILD) -o $(BINDIR)/$(basename $@)/$(NAME)

freebsd-386:
	GOARCH=386 GOOS=freebsd $(GOBUILD) -o $(BINDIR)/$(basename $@)/$(NAME)

freebsd-amd64:
	GOARCH=amd64 GOOS=freebsd $(GOBUILD) -o $(BINDIR)/$(basename $@)/$(NAME)

freebsd-arm:
	GOARCH=arm GOOS=freebsd $(GOBUILD) -o $(BINDIR)/$(basename $@)/$(NAME)

freebsd-arm64:
	GOARCH=arm64 GOOS=freebsd $(GOBUILD) -o $(BINDIR)/$(basename $@)/$(NAME)

freebsd-riscv64:
	GOARCH=riscv64 GOOS=freebsd $(GOBUILD) -o $(BINDIR)/$(basename $@)/$(NAME)

illumos-amd64:
	GOARCH=amd64 GOOS=illumos $(GOBUILD) -o $(BINDIR)/$(basename $@)/$(NAME)

ios-amd64:
	GOARCH=amd64 GOOS=darwin $(GOBUILD) -o $(BINDIR)/$(basename $@)/$(NAME)

ios-arm64:
	GOARCH=arm64 GOOS=darwin $(GOBUILD) -o $(BINDIR)/$(basename $@)/$(NAME)

js-wasm:
	GOARCH=wasm GOOS=js $(GOBUILD) -o $(BINDIR)/$(basename $@)/$(NAME).wasm

linux-386:
	GOARCH=386 GOOS=linux $(GOBUILD) -o $(BINDIR)/$(basename $@)/$(NAME)

linux-amd64:
	GOARCH=amd64 GOOS=linux $(GOBUILD) -o $(BINDIR)/$(basename $@)/$(NAME)

linux-arm:
	GOARCH=arm GOOS=linux $(GOBUILD) -o $(BINDIR)/$(basename $@)/$(NAME)

linux-arm64:
	GOARCH=arm64 GOOS=linux $(GOBUILD) -o $(BINDIR)/$(basename $@)/$(NAME)

linux-loong64:
	GOARCH=loong64 GOOS=linux $(GOBUILD) -o $(BINDIR)/$(basename $@)/$(NAME)

linux-mips:
	GOARCH=mips GOOS=linux $(GOBUILD) -o $(BINDIR)/$(basename $@)/$(NAME)

linux-mips64:
	GOARCH=mips64 GOOS=linux $(GOBUILD) -o $(BINDIR)/$(basename $@)/$(NAME)

linux-mips64le:
	GOARCH=mips64le GOOS=linux $(GOBUILD) -o $(BINDIR)/$(basename $@)/$(NAME)

linux-mipsle:
	GOARCH=mipsle GOOS=linux $(GOBUILD) -o $(BINDIR)/$(basename $@)/$(NAME)

linux-ppc64:
	GOARCH=ppc64 GOOS=linux $(GOBUILD) -o $(BINDIR)/$(basename $@)/$(NAME)

linux-ppc64le:
	GOARCH=ppc64le GOOS=linux $(GOBUILD) -o $(BINDIR)/$(basename $@)/$(NAME)

linux-riscv64:
	GOARCH=riscv64 GOOS=linux $(GOBUILD) -o $(BINDIR)/$(basename $@)/$(NAME)

linux-s390x:
	GOARCH=s390x GOOS=linux $(GOBUILD) -o $(BINDIR)/$(basename $@)/$(NAME)

netbsd-386:
	GOARCH=386 GOOS=netbsd $(GOBUILD) -o $(BINDIR)/$(basename $@)/$(NAME)

netbsd-amd64:
	GOARCH=amd64 GOOS=netbsd $(GOBUILD) -o $(BINDIR)/$(basename $@)/$(NAME)

netbsd-arm:
	GOARCH=arm GOOS=netbsd $(GOBUILD) -o $(BINDIR)/$(basename $@)/$(NAME)

netbsd-arm64:
	GOARCH=arm64 GOOS=netbsd $(GOBUILD) -o $(BINDIR)/$(basename $@)/$(NAME)

openbsd-386:
	GOARCH=386 GOOS=openbsd $(GOBUILD) -o $(BINDIR)/$(basename $@)/$(NAME)

openbsd-amd64:
	GOARCH=amd64 GOOS=openbsd $(GOBUILD) -o $(BINDIR)/$(basename $@)/$(NAME)

openbsd-arm:
	GOARCH=arm GOOS=openbsd $(GOBUILD) -o $(BINDIR)/$(basename $@)/$(NAME)

openbsd-arm64:
	GOARCH=arm64 GOOS=openbsd $(GOBUILD) -o $(BINDIR)/$(basename $@)/$(NAME)

openbsd-ppc64:
	GOARCH=ppc64 GOOS=openbsd $(GOBUILD) -o $(BINDIR)/$(basename $@)/$(NAME)

plan9-386:
	GOARCH=386 GOOS=plan9 $(GOBUILD) -o $(BINDIR)/$(basename $@)/$(NAME)

plan9-amd64:
	GOARCH=amd64 GOOS=plan9 $(GOBUILD) -o $(BINDIR)/$(basename $@)/$(NAME)

plan9-arm:
	GOARCH=arm GOOS=plan9 $(GOBUILD) -o $(BINDIR)/$(basename $@)/$(NAME)

solaris-amd64:
	GOARCH=amd64 GOOS=solaris $(GOBUILD) -o $(BINDIR)/$(basename $@)/$(NAME)

wasip1-wasm:
	GOARCH=wasm GOOS=js $(GOBUILD) -o $(BINDIR)/$(basename $@)/$(NAME).wasm

windows-386:
	GOARCH=386 GOOS=windows $(GOBUILD) -o $(BINDIR)/$(basename $@)/$(NAME).exe

windows-amd64:
	GOARCH=amd64 GOOS=windows $(GOBUILD) -o $(BINDIR)/$(basename $@)/$(NAME).exe

windows-amd64-v3:
	GOARCH=amd64 GOOS=windows GOAMD64=v3 $(GOBUILD) -o $(BINDIR)/$(basename $@)/$(NAME).exe

windows-arm64:
	GOARCH=arm64 GOOS=windows $(GOBUILD) -o $(BINDIR)/$(basename $@)/$(NAME).exe

windows-armv7:
	GOARCH=arm GOOS=windows GOARM=7 $(GOBUILD) -o $(BINDIR)/$(basename $@)/$(NAME).exe

gz_releases=$(addsuffix .gz, $(PLATFORM_LIST))
zip_releases=$(addsuffix .zip, $(WINDOWS_ARCH_LIST))
wasm_releases=$(addsuffix .wasm, $(WASM_LIST))

$(gz_releases): %.gz : %
	-upx -9 $(BINDIR)/$(basename $@)/$(NAME)
	chmod +x $(BINDIR)/$(basename $@)/$(NAME)
	gzip -f -S -$(VERSION).gz $(BINDIR)/$(basename $@)/$(NAME)
	mv $(BINDIR)/$(basename $@)/$(NAME)-$(VERSION).gz $(BINDIR)/$(NAME)-$(basename $@)-$(VERSION).gz
	rm -r $(BINDIR)/$(basename $@)

$(zip_releases): %.zip : %
	-upx -9 $(BINDIR)/$(basename $@)/$(NAME).exe
	zip -m -j $(BINDIR)/$(basename $@)/$(NAME)-$(VERSION).zip $(BINDIR)/$(basename $@)/$(NAME).exe
	mv $(BINDIR)/$(basename $@)/$(NAME)-$(VERSION).zip $(BINDIR)/$(NAME)-$(basename $@)-$(VERSION).zip
	rm -r $(BINDIR)/$(basename $@)

$(wasm_releases): %.wasm : %
	-upx -9 $(BINDIR)/$(basename $@)/$(NAME).wasm
	mv $(BINDIR)/$(basename $@)/$(NAME).wasm $(BINDIR)/$(NAME)-$(basename $@).wasm
	rm -r $(BINDIR)/$(basename $@)

all-arch: $(PLATFORM_LIST) $(WINDOWS_ARCH_LIST) $(WASM_LIST)

releases: $(gz_releases) $(zip_releases) $(wasm_releases)

LINT_OS_LIST := darwin windows linux freebsd openbsd

lint: $(foreach os,$(LINT_OS_LIST),$(os)-lint)
%-lint:
	GOOS=$* golangci-lint run ./...

lint-fix: $(foreach os,$(LINT_OS_LIST),$(os)-lint-fix)
%-lint-fix:
	GOOS=$* golangci-lint run --fix ./...

clean:
	rm $(BINDIR)/*