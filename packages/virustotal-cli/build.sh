TERMUX_PKG_HOMEPAGE=https://github.com/VirusTotal/vt-cli
TERMUX_PKG_DESCRIPTION="Command line interface for VirusTotal"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="Leonid Pliushch <leonid.pliushch@gmail.com>"
TERMUX_PKG_VERSION=0.8.0
TERMUX_PKG_SRCURL=https://github.com/VirusTotal/vt-cli/archive/$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=48de52aaafa5790e36d6522086c49c73bac3aff9a814164aa1b0c5f6487f1669
TERMUX_PKG_BREAKS="vt-cli"
TERMUX_PKG_REPLACES="vt-cli"

termux_step_make() {
	termux_setup_golang

	export GOPATH=$TERMUX_PKG_BUILDDIR
	mkdir -p "$GOPATH"/src/github.com/VirusTotal
	ln -sf "$TERMUX_PKG_SRCDIR" "$GOPATH"/src/github.com/VirusTotal/vt-cli

	cd "$GOPATH"/src/github.com/VirusTotal/vt-cli

	GOOS=linux GOARCH=amd64 CC=gcc LD=gcc \
		go get -u github.com/golang/dep/cmd/dep
	"$GOPATH"/bin/dep ensure

	go build \
		-ldflags "-X github.com/VirusTotal/vt-cli/cmd.Version=$TERMUX_PKG_VERSION" \
		-o "$TERMUX_PREFIX"/bin/vt-cli \
		./vt/main.go
}

termux_step_make_install() {
	ln -sfr "$TERMUX_PREFIX"/bin/vt-cli "$TERMUX_PREFIX"/bin/vt
}
