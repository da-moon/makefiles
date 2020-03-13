include $(abspath $(dir $(lastword $(MAKEFILE_LIST)))/../../pkg/functions/functions.mk)
include $(abspath $(dir $(lastword $(MAKEFILE_LIST)))/../../pkg/git/git.mk)
ifeq ($(OS),Windows_NT)
    GO_PATH = $(subst \,/,${GOPATH})
else
    GO_PATH = ${GOPATH}
endif
THIS_FILE := $(lastword $(MAKEFILE_LIST))
SELF_DIR := $(dir $(THIS_FILE))

GO_TARGET = $(notdir $(patsubst %/,%,$(dir $(wildcard ./cmd/*/.))))
CGO=0
GO_ARCHITECTURE=amd64
GO_IMAGE=golang:buster
MOD=off
GO_PKG_DIR=$(call relative_to_absolute,$(SELF_DIR))
.PHONY: go-build go-build-mac-os go-build-linux go-build-windows go-clean go-print
.SILENT: go-build go-build-mac-os go-build-linux go-build-windows go-clean go-print
go-print:
	- $(info $(GO_PKG_DIR))

go-build:
	- $(CLEAR)
	- @$(MAKE) --no-print-directory -f $(THIS_FILE) go-build-linux
	- @$(MAKE) --no-print-directory -f $(THIS_FILE) go-build-windows
	- @$(MAKE) --no-print-directory -f $(THIS_FILE) go-build-mac-os

go-build-linux:  
	- $(eval GOOS := linux)
    ifeq ($(DOCKER_ENV),true)
ifeq (${MOD},on)
ifeq ($(wildcard ./go.mod),)
	- @$(MAKE) --no-print-directory -f $(THIS_FILE) shell docker_image="${GO_IMAGE}" container_name="go_builder_container" mount_point="/go/src/github.com/da-moon/go-packages" cmd="GO111MODULE=on \
    CGO_ENABLED=${CGO} \
    GOARCH=${GO_ARCHITECTURE} \
    go mod init"
endif
	- @$(MAKE) --no-print-directory -f $(THIS_FILE) shell docker_image="${GO_IMAGE}" container_name="go_builder_container" mount_point="/go/src/github.com/da-moon/go-packages" cmd="GO111MODULE=on \
    CGO_ENABLED=${CGO} \
    GOARCH=${GO_ARCHITECTURE} \
    go mod tidy"
endif
	for target in $(GO_TARGET); do \
            $(MAKE) --no-print-directory -f $(THIS_FILE) shell docker_image="${GO_IMAGE}" container_name="go_builder_container" mount_point="/go/src/github.com/da-moon/go-packages" cmd="rm -rf /go/src/github.com/da-moon/go-packages/bin/$$target/${GOOS}/${VERSION} && \
            GO111MODULE=on \
            CGO_ENABLED=${CGO} \
            GOARCH=${GO_ARCHITECTURE} \
            GOOS=${GOOS} \
            go build -a -installsuffix cgo -ldflags \
            '-X github.com/da-moon/go-packages/build/version.Version=${VERSION} \
			-X github.com/da-moon/go-packages/build/version.Revision=${REVISION} \
			-X github.com/da-moon/go-packages/build/version.Branch=${BRANCH} \
			-X github.com/da-moon/go-packages/build/version.BuildUser=${BUILDUSER} \
			-X github.com/da-moon/go-packages/build/version.BuildDate=${BUILDTIME}' \
			-o .$(PSEP)bin$(PSEP)$$target$(PSEP)${GOOS}$(PSEP)${VERSION}$(PSEP)$$target .$(PSEP)cmd$(PSEP)$$target"; \
	done

    endif
    ifeq ($(DOCKER_ENV),false)
ifeq (${MOD},on)
ifeq ($(wildcard ./go.mod),)
	- @$(MAKE) --no-print-directory -f $(THIS_FILE) shell cmd="GO111MODULE=on \
    CGO_ENABLED=${CGO} \
    GOARCH=${GO_ARCHITECTURE} \
    go mod init"
endif
	- @$(MAKE) --no-print-directory -f $(THIS_FILE) shell cmd="GO111MODULE=on \
    CGO_ENABLED=${CGO} \
    GOARCH=${GO_ARCHITECTURE} \
    go mod tidy"
endif
	for target in $(GO_TARGET); do \
            $(RM) .$(PSEP)bin$(PSEP)$$target$(PSEP)${GOOS}$(PSEP)${VERSION}; \
			$(MAKE) --no-print-directory -f $(THIS_FILE) shell cmd="CGO_ENABLED=${CGO} \
            GO111MODULE=$(MOD) \
            GOARCH=${GO_ARCHITECTURE} \
            GOOS=${GOOS} \
            go build -a -installsuffix cgo -ldflags \
            '-X github.com/da-moon/go-packages/build/version.Version=${VERSION} \
			-X github.com/da-moon/go-packages/build/version.Revision=${REVISION} \
			-X github.com/da-moon/go-packages/build/version.Branch=${BRANCH} \
			-X github.com/da-moon/go-packages/build/version.BuildUser=${BUILDUSER} \
			-X github.com/da-moon/go-packages/build/version.BuildDate=${BUILDTIME}' \
			-o .$(PSEP)bin$(PSEP)$$target$(PSEP)${GOOS}$(PSEP)${VERSION}$(PSEP)$$target .$(PSEP)cmd$(PSEP)$$target"; \
	done
    endif

go-build-windows:
	- $(eval GOOS := windows)
    ifeq ($(DOCKER_ENV),true)
ifeq (${MOD},on)
ifeq ($(wildcard ./go.mod),)
	- @$(MAKE) --no-print-directory -f $(THIS_FILE) shell docker_image="${GO_IMAGE}" container_name="go_builder_container" mount_point="/go/src/github.com/da-moon/go-packages" cmd="GO111MODULE=on \
    CGO_ENABLED=${CGO} \
    GOARCH=${GO_ARCHITECTURE} \
    go mod init"
endif
	- @$(MAKE) --no-print-directory -f $(THIS_FILE) shell docker_image="${GO_IMAGE}" container_name="go_builder_container" mount_point="/go/src/github.com/da-moon/go-packages" cmd="GO111MODULE=on \
    CGO_ENABLED=${CGO} \
    GOARCH=${GO_ARCHITECTURE} \
    go mod tidy"
endif
	for target in $(GO_TARGET); do \
            $(MAKE) --no-print-directory -f $(THIS_FILE) shell docker_image="${GO_IMAGE}" container_name="go_builder_container" mount_point="/go/src/github.com/da-moon/go-packages" cmd="rm -rf /go/src/github.com/da-moon/go-packages/bin/$$target/${GOOS}/${VERSION} && \
            GO111MODULE=on \
            CGO_ENABLED=${CGO} \
            GOARCH=${GO_ARCHITECTURE} \
            GOOS=${GOOS} \
            go build -a -installsuffix cgo -ldflags \
            '-X github.com/da-moon/go-packages/build/version.Version=${VERSION} \
			-X github.com/da-moon/go-packages/build/version.Revision=${REVISION} \
			-X github.com/da-moon/go-packages/build/version.Branch=${BRANCH} \
			-X github.com/da-moon/go-packages/build/version.BuildUser=${BUILDUSER} \
			-X github.com/da-moon/go-packages/build/version.BuildDate=${BUILDTIME}' \
			-o .$(PSEP)bin$(PSEP)$$target$(PSEP)${GOOS}$(PSEP)${VERSION}$(PSEP)$$target.exe .$(PSEP)cmd$(PSEP)$$target"; \
	done

    endif
    ifeq ($(DOCKER_ENV),false)
ifeq (${MOD},on)
ifeq ($(wildcard ./go.mod),)
	- @$(MAKE) --no-print-directory -f $(THIS_FILE) shell cmd="GO111MODULE=on \
    CGO_ENABLED=${CGO} \
    GOARCH=${GO_ARCHITECTURE} \
    go mod init"
endif
	- @$(MAKE) --no-print-directory -f $(THIS_FILE) shell cmd="GO111MODULE=on \
    CGO_ENABLED=${CGO} \
    GOARCH=${GO_ARCHITECTURE} \
    go mod tidy"
endif
	for target in $(GO_TARGET); do \
            $(RM) .$(PSEP)bin$(PSEP)$$target$(PSEP)${GOOS}$(PSEP)${VERSION}; \
			$(MAKE) --no-print-directory -f $(THIS_FILE) shell cmd="CGO_ENABLED=${CGO} \
            GO111MODULE=$(MOD) \
            GOARCH=${GO_ARCHITECTURE} \
            GOOS=${GOOS} \
            go build -a -installsuffix cgo -ldflags \
            '-X github.com/da-moon/go-packages/build/version.Version=${VERSION} \
			-X github.com/da-moon/go-packages/build/version.Revision=${REVISION} \
			-X github.com/da-moon/go-packages/build/version.Branch=${BRANCH} \
			-X github.com/da-moon/go-packages/build/version.BuildUser=${BUILDUSER} \
			-X github.com/da-moon/go-packages/build/version.BuildDate=${BUILDTIME}' \
			-o .$(PSEP)bin$(PSEP)$$target$(PSEP)${GOOS}$(PSEP)${VERSION}$(PSEP)$$target .$(PSEP)cmd$(PSEP)$$target"; \
	done
    endif

go-build-mac-os:
	- $(eval GOOS := darwin)
    ifeq ($(DOCKER_ENV),true)
ifeq (${MOD},on)
ifeq ($(wildcard ./go.mod),)
	- @$(MAKE) --no-print-directory -f $(THIS_FILE) shell docker_image="${GO_IMAGE}" container_name="go_builder_container" mount_point="/go/src/github.com/da-moon/go-packages" cmd="GO111MODULE=on \
    CGO_ENABLED=${CGO} \
    GOARCH=${GO_ARCHITECTURE} \
    go mod init"
endif
	- @$(MAKE) --no-print-directory -f $(THIS_FILE) shell docker_image="${GO_IMAGE}" container_name="go_builder_container" mount_point="/go/src/github.com/da-moon/go-packages" cmd="GO111MODULE=on \
    CGO_ENABLED=${CGO} \
    GOARCH=${GO_ARCHITECTURE} \
    go mod tidy"
endif
	for target in $(GO_TARGET); do \
            $(MAKE) --no-print-directory -f $(THIS_FILE) shell docker_image="${GO_IMAGE}" container_name="go_builder_container" mount_point="/go/src/github.com/da-moon/go-packages" cmd="rm -rf /go/src/github.com/da-moon/go-packages/bin/$$target/${GOOS}/${VERSION} && \
            GO111MODULE=on \
            CGO_ENABLED=${CGO} \
            GOARCH=${GO_ARCHITECTURE} \
            GOOS=${GOOS} \
            go build -a -installsuffix cgo -ldflags \
            '-X github.com/da-moon/go-packages/build/version.Version=${VERSION} \
			-X github.com/da-moon/go-packages/build/version.Revision=${REVISION} \
			-X github.com/da-moon/go-packages/build/version.Branch=${BRANCH} \
			-X github.com/da-moon/go-packages/build/version.BuildUser=${BUILDUSER} \
			-X github.com/da-moon/go-packages/build/version.BuildDate=${BUILDTIME}' \
			-o .$(PSEP)bin$(PSEP)$$target$(PSEP)${GOOS}$(PSEP)${VERSION}$(PSEP)$$target .$(PSEP)cmd$(PSEP)$$target"; \
	done

    endif
    ifeq ($(DOCKER_ENV),false)
ifeq (${MOD},on)
ifeq ($(wildcard ./go.mod),)
	- @$(MAKE) --no-print-directory -f $(THIS_FILE) shell cmd="GO111MODULE=on \
    CGO_ENABLED=${CGO} \
    GOARCH=${GO_ARCHITECTURE} \
    go mod init"
endif
	- @$(MAKE) --no-print-directory -f $(THIS_FILE) shell cmd="GO111MODULE=on \
    CGO_ENABLED=${CGO} \
    GOARCH=${GO_ARCHITECTURE} \
    go mod tidy"
endif
	for target in $(GO_TARGET); do \
            $(RM) .$(PSEP)bin$(PSEP)$$target$(PSEP)${GOOS}$(PSEP)${VERSION}; \
			$(MAKE) --no-print-directory -f $(THIS_FILE) shell cmd="CGO_ENABLED=${CGO} \
            GO111MODULE=$(MOD) \
            GOARCH=${GO_ARCHITECTURE} \
            GOOS=${GOOS} \
            go build -a -installsuffix cgo -ldflags \
            '-X github.com/da-moon/go-packages/build/version.Version=${VERSION} \
			-X github.com/da-moon/go-packages/build/version.Revision=${REVISION} \
			-X github.com/da-moon/go-packages/build/version.Branch=${BRANCH} \
			-X github.com/da-moon/go-packages/build/version.BuildUser=${BUILDUSER} \
			-X github.com/da-moon/go-packages/build/version.BuildDate=${BUILDTIME}' \
			-o .$(PSEP)bin$(PSEP)$$target$(PSEP)${GOOS}$(PSEP)${VERSION}$(PSEP)$$target .$(PSEP)cmd$(PSEP)$$target"; \
	done
    endif

go-clean:
	- $(CLEAR)
    ifeq ($(DOCKER_ENV),true)
	- @$(MAKE) --no-print-directory -f $(THIS_FILE) shell docker_image="${GO_IMAGE}" container_name="go_builder_container" mount_point="/go/src/github.com/da-moon/go-packages" cmd="rm -rf /go/src/github.com/da-moon/go-packages/bin/"
    else
	- $(RM) ./bin/
    endif
