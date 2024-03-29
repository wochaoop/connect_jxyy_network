NAME=connect_jxyy_network
BINDIR=bin
VERSION=$(shell git describe --tags || echo "unknown version")
BUILDTIME=$(shell date -u)
GOBUILD=CGO_ENABLED=0 go build -trimpath -ldflags '-X "github.com/wochaoop/connect_jxyy_network/constant.Version=$(VERSION)" \
		-X "github.com/wochaoop/connect_jxyy_network/constant.BuildTime=$(BUILDTIME)" \
		-w -s -buildid='

PLATFORM_LIST = \
	darwin-amd64 \
	darwin-amd64-v3 \
	darwin-arm64 \
	linux-386 \
	linux-amd64 \
	linux-amd64-v3 \
	linux-armv5 \
	linux-armv6 \
	linux-armv7 \
	linux-arm64 \
	linux-mips-softfloat \
	linux-mips-hardfloat \
	linux-mipsle-softfloat \
	linux-mipsle-hardfloat \
	linux-mips64 \
	linux-mips64le \
	linux-riscv64 \
	linux-loong64 \
	freebsd-386 \
	freebsd-amd64 \
	freebsd-amd64-v3 \
	freebsd-arm64

WINDOWS_ARCH_LIST = \
	windows-386 \
	windows-amd64 \
	windows-amd64-v3 \
	windows-arm64 \
	windows-armv7

all: linux-amd64 darwin-amd64 windows-amd64 # Most used

darwin-amd64:
	GOARCH=amd64 GOOS=darwin $(GOBUILD) -o $(BINDIR)/$(basename $@)/$(NAME)

darwin-amd64-v3:
	GOARCH=amd64 GOOS=darwin GOAMD64=v3 $(GOBUILD) -o $(BINDIR)/$(basename $@)/$(NAME)

darwin-arm64:
	GOARCH=arm64 GOOS=darwin $(GOBUILD) -o $(BINDIR)/$(basename $@)/$(NAME)

linux-386:
	GOARCH=386 GOOS=linux $(GOBUILD) -o $(BINDIR)/$(basename $@)/$(NAME)

linux-amd64:
	GOARCH=amd64 GOOS=linux $(GOBUILD) -o $(BINDIR)/$(basename $@)/$(NAME)

linux-amd64-v3:
	GOARCH=amd64 GOOS=linux GOAMD64=v3 $(GOBUILD) -o $(BINDIR)/$(basename $@)/$(NAME)

linux-armv5:
	GOARCH=arm GOOS=linux GOARM=5 $(GOBUILD) -o $(BINDIR)/$(basename $@)/$(NAME)

linux-armv6:
	GOARCH=arm GOOS=linux GOARM=6 $(GOBUILD) -o $(BINDIR)/$(basename $@)/$(NAME)

linux-armv7:
	GOARCH=arm GOOS=linux GOARM=7 $(GOBUILD) -o $(BINDIR)/$(basename $@)/$(NAME)

linux-arm64:
	GOARCH=arm64 GOOS=linux $(GOBUILD) -o $(BINDIR)/$(basename $@)/$(NAME)

linux-mips-softfloat:
	GOARCH=mips GOMIPS=softfloat GOOS=linux $(GOBUILD) -o $(BINDIR)/$(basename $@)/$(NAME)

linux-mips-hardfloat:
	GOARCH=mips GOMIPS=hardfloat GOOS=linux $(GOBUILD) -o $(BINDIR)/$(basename $@)/$(NAME)

linux-mipsle-softfloat:
	GOARCH=mipsle GOMIPS=softfloat GOOS=linux $(GOBUILD) -o $(BINDIR)/$(basename $@)/$(NAME)

linux-mipsle-hardfloat:
	GOARCH=mipsle GOMIPS=hardfloat GOOS=linux $(GOBUILD) -o $(BINDIR)/$(basename $@)/$(NAME)

linux-mips64:
	GOARCH=mips64 GOOS=linux $(GOBUILD) -o $(BINDIR)/$(basename $@)/$(NAME)

linux-mips64le:
	GOARCH=mips64le GOOS=linux $(GOBUILD) -o $(BINDIR)/$(basename $@)/$(NAME)

linux-riscv64:
	GOARCH=riscv64 GOOS=linux $(GOBUILD) -o $(BINDIR)/$(basename $@)/$(NAME)

linux-loong64:
	GOARCH=loong64 GOOS=linux $(GOBUILD) -o $(BINDIR)/$(basename $@)/$(NAME)

freebsd-386:
	GOARCH=386 GOOS=freebsd $(GOBUILD) -o $(BINDIR)/$(basename $@)/$(NAME)

freebsd-amd64:
	GOARCH=amd64 GOOS=freebsd $(GOBUILD) -o $(BINDIR)/$(basename $@)/$(NAME)

freebsd-amd64-v3:
	GOARCH=amd64 GOOS=freebsd GOAMD64=v3 $(GOBUILD) -o $(BINDIR)/$(basename $@)/$(NAME)

freebsd-arm64:
	GOARCH=arm64 GOOS=freebsd $(GOBUILD) -o $(BINDIR)/$(basename $@)/$(NAME)

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

$(gz_releases): %.gz : %
	-upx -9 $(BINDIR)/$(basename $@)/$(NAME)
	chmod +x $(BINDIR)/$(basename $@)/$(NAME)
	gzip -f -S -$(VERSION).gz $(BINDIR)/$(basename $@)/$(NAME)
	mv $(BINDIR)/$(basename $@)/$(NAME)-$(VERSION).gz $(BINDIR)/$(NAME)-$(basename $@)-$(VERSION).gz

$(zip_releases): %.zip : %
	-upx -9 $(BINDIR)/$(basename $@)/$(NAME)
	zip -m -j $(BINDIR)/$(basename $@)/$(NAME)-$(VERSION).zip $(BINDIR)/$(basename $@)/$(NAME).exe
	mv $(BINDIR)/$(basename $@)/$(NAME)-$(VERSION).zip $(BINDIR)/$(NAME)-$(basename $@)-$(VERSION).zip

all-arch: $(PLATFORM_LIST) $(WINDOWS_ARCH_LIST)

releases: $(gz_releases) $(zip_releases)

LINT_OS_LIST := darwin windows linux freebsd openbsd

lint: $(foreach os,$(LINT_OS_LIST),$(os)-lint)
%-lint:
	GOOS=$* golangci-lint run ./...

lint-fix: $(foreach os,$(LINT_OS_LIST),$(os)-lint-fix)
%-lint-fix:
	GOOS=$* golangci-lint run --fix ./...

clean:
	rm $(BINDIR)/*