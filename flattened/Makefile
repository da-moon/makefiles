ifeq ($(OS),Windows_NT)
    CLEAR = cls
    LS = dir
    TOUCH =>> 
    RM = del /F /Q
    CPF = copy /y
    RMDIR = -RMDIR /S /Q
    MKDIR = -mkdir
    ERRIGNORE = 2>NUL || (exit 0)
    SEP=\\
else
    CLEAR = clear
    LS = ls
    TOUCH = touch
    CPF = cp -f
    RM = rm -rf 
    RMDIR = rm -rf 
    MKDIR = mkdir -p
    ERRIGNORE = 2>/dev/null
    SEP=/
endif
ifeq ($(findstring cmd.exe,$(SHELL)),cmd.exe)
DEVNUL := NUL
WHICH := where
else
DEVNUL := /dev/null
WHICH := which
endif
null :=
space := ${null} ${null}
PSEP = $(strip $(SEP))
PWD ?= $(realpath $(dir $(lastword $(MAKEFILE_LIST))))
${space} := ${space}
BLACK = 0
RED = 1
GREEN = 2
YELLOW = 3
BLUE = 4
MAGENTA = 5
CYAN = 6
WHITE = 7
DOCKER_ENV = false
CMD_ARGUMENTS ?= $(cmd)
STARTUP_SCRIPT ?= $(startup)
ifeq ($(DOCKER_ENV),true)
    ifeq ($(shell ${WHICH} docker 2>${DEVNUL}),)
        $(error "docker is not in your system PATH. Please install docker to continue or set DOCKER_ENV = false in make file ")
    endif
    DOCKER_IMAGE ?= $(docker_image)
    DOCKER_CONTAINER_NAME ?=$(container_name)
    DOCKER_CONTAINER_MOUNT_POINT?=$(mount_point)
    ifneq ($(DOCKER_CONTAINER_NAME),)
        CONTAINER_RUNNING := $(shell docker inspect -f '{{.State.Running}}' ${DOCKER_CONTAINER_NAME})
    endif
    ifneq ($(DOCKER_CONTAINER_NAME),)
        DOCKER_IMAGE_EXISTS := $(shell docker images -q ${DOCKER_IMAGE} 2> /dev/null)
    endif
endif
shell:
ifneq ($(DOCKER_ENV),)
ifeq ($(DOCKER_ENV),true)
    ifeq ($(DOCKER_IMAGE_EXISTS),)
	- @docker pull ${DOCKER_IMAGE}
    endif
    ifneq ($(CONTAINER_RUNNING),true)
	- @docker run --entrypoint "/bin/bash" -v ${CURDIR}:${DOCKER_CONTAINER_MOUNT_POINT} --name ${DOCKER_CONTAINER_NAME} --rm -d -i -t ${DOCKER_IMAGE} -c tail -f /dev/null
    ifneq ($(STARTUP_SCRIPT),)
	- @docker exec --workdir ${DOCKER_CONTAINER_MOUNT_POINT} ${DOCKER_CONTAINER_NAME} /bin/bash -c "${STARTUP_SCRIPT}"
    endif
    endif
endif
endif
ifneq ($(CMD_ARGUMENTS),)
	- $(info Executing in Docker Container)
	- $(info command : $(CMD_ARGUMENTS))
    ifeq ($(DOCKER_ENV),true)
        ifneq ($(DOCKER_ENV),)
	- @docker exec  --workdir ${DOCKER_CONTAINER_MOUNT_POINT} ${DOCKER_CONTAINER_NAME} /bin/bash -c "$(CMD_ARGUMENTS)"
        endif
    else
	- $(info Executing in local environment)
ifeq ($(OS),Windows_NT)
	- @CMD /c "$(CMD_ARGUMENTS)"
else
	- @/bin/bash -c "$(CMD_ARGUMENTS)"
endif
    endif
endif
.PHONY: all shell 
.SILENT: all shell 
define color_text
	tput setaf $(1); \
	[ "$3" ] && [ "$3" == "1" ] && tput bold; \
	printf $(2); \
	tput sgr0
endef
define print_color
	$(call color_text, $(1), $(2)'\n')
endef
define print_dual_color
	$(call color_text, $(1), $(2)); \
	$(call color_text, $(3), $(4)'\n')
endef
define print_triple_color
	$(call color_text, $(1), $(2)); \
	$(call color_text, $(3), $(4)); \
	$(call color_text, $(5), $(6)'\n')
endef
define print_container_enter
	$(call color_text, ${CYAN}, "Command: "); \
	$(call color_text, ${WHITE},"$(1)\n"); \
	$(call color_text, ${CYAN}, "Container: "); \
	$(call color_text, ${WHITE},"$(2)\n"); \
	$(call color_text, ${CYAN}, "Shell: "); \
	$(call color_text, ${WHITE},"$(3)\n"); \
	$(call color_text, ${CYAN}, "User: "); \
	$(call color_text, ${WHITE},"$(4)\n"); \
	$(call color_text, ${CYAN}, "Time: "); \
	$(call color_text, ${WHITE},"$$(date '+%Y-%m-%d %H:%M:%S')\n\n")
endef
define print_container_exit
	$(call color_text, 8, "\nExit; $$(date '+%Y-%m-%d %H:%M:%S')\n")
endef
define print_running_target
	$(call trim, custom, $(1)); \
	custom=$${custom:-$@}; \
	$(call print_dual_color, ${GREEN}, "running... ", ${WHITE}, "$${custom}")
endef
define print_completed_target
	$(call trim, custom, $(1)); \
	custom=$${custom:-$@}; \
	$(call print_triple_color, ${GREEN}, "√ ", ${WHITE}, "$$custom", ${GREEN}, " done")
endef
define print_completed_target_new
	$(call trim, custom, $(1)); \
	custom=$${custom:-$(1)}; \
	custom=[$@]" "$${custom}  ; \
	$(call print_triple_color, ${GREEN}, "√ ", ${WHITE}, "$$custom", ${GREEN}, "done")
endef
define print_failed_target
	$(call trim, custom, $(1)); \
	custom=$${custom:-$@}; \
	$(call print_triple_color, ${RED}, "X ", ${WHITE}, "$${custom} ", ${RED}, "failed")
endef
define print_target_info
	$(call print_dual_color, ${CYAN}, " • ", ${WHITE}, $(1))
endef
define print_target_general
	$(call print_dual_color, ${WHITE}, " • ", ${WHITE}, $(1))
endef
define print_target_success
	$(call print_dual_color, ${GREEN}, " • ", ${WHITE}, $(1))
endef
define print_target_error
	$(call print_dual_color, ${RED}, " • ", ${WHITE}, $(1))
endef
define print_command
	$(call trim, name, $(1)); \
	$(call trim, commands, $(2)); \
	commands="$${commands// /\\n - }"; \
	$(call print_dual_color, ${WHITE}, "\n$${name} commands: \n", ${GREEN}, " - $${commands}")
endef
define get_pmf_target_label
	$(call get_custom_project_makefile); \
    makefilename="$$(basename $${pmf})"; \
	$(call trim, target, $(1)); \
    pmf_target_label="$${makefilename} » $$target"
endef 
define rwildcard
$(wildcard $1$2) $(foreach d,$(wildcard $1*),$(call rwildcard,$d/,$2))
endef
define recursive_call
$(foreach a,$(2),$(call $(1),$(a)))
endef
define relative_to_absolute
$(realpath $1)
endef
define pathsearch
$(firstword $(wildcard $(addsuffix /$(1),$(subst :, ,$(PATH)))))
endef
define append_to_file
$(file >>$(1),$(2))
endef
define write_to_file
$(file >$(1),$(2))
endef
define empty_file
$(file >$(1),)
endef
define read_file_content
$(file < $(1))
endef
define canonical_path
$(patsubst ${CURDIR}/%,%,$(abspath ${1}))
endef
define MIN
$(firstword $(sort ${1} ${2}))
endef
define PEEK
$(lastword $(subst :, ,${1}))
endef
define POP
${1:%:$(lastword $(subst :, ,${1}))=%}
endef
define PUSH
${2:%=${1}:%}
endef
define QUALIFY_PATH
$(addprefix ${1}/,$(filter-out /%,${2})) $(filter /%,${2})
endef
define extract_host
$(firstword \
	$(subst :, ,$1)\
)
endef
define extract_port
$(or \
	$(word 2,\
		$(subst :, ,$1)\
	),$(value 2)\
)
endef
VERSION   ?= $(shell git describe --tags)
REVISION  ?= $(shell git rev-parse HEAD)
BRANCH    ?= $(shell git rev-parse --abbrev-ref HEAD)
BUILDUSER ?= $(shell id -un)
BUILDTIME ?= $(shell date '+%Y%m%d-%H:%M:%S') 
define to_upper
	$(1)=$$(echo $(2) | tr '[:lower:]' '[:upper:]')
endef
define to_lower
	$(1)=$$(echo $(2) | tr '[:upper:]' '[:lower:]')
endef
define trim
	value="$(2)"; \
	$(1)=$$(echo $${value%/} | xargs)
endef
define var
	$(call trim, value, $(2)); \
	$(1)="$$value"
endef
define find_replace
	if [ "$(4)" ]; then \
		$(call trim, dlm, $(4)); \
	else \
	fi; \
	$(call trim, find, $(1)); \
	$(call trim, replace, $(2)); \
	$(call trim, file, $(3)); \
	sed -i.bak -e "s$${dlm}$${find}$${dlm}$${replace}$${dlm}g" $$file && rm -f $${file}.bak
endef
define replace_or_update
	$(call trim, var_name, $(1)); \
	var_name=$${var_name%'%'}; \
	if [ "$${!var_name}" ] && [ -f "$${file}.backup" ]; then \
		$(call remove_matching_lines, $$var_name, $${file}.backup); \
	fi
endef
define remove_matching_lines
	$(call trim, find, $(1)); \
	$(call trim, file, $(2)); \
	sed -i.bak -e "/$${find}/d" $$file && rm -f $${file}.bak
endef
define remove_empty_lines
	$(call trim, file, $(1)); \
	sed -i.bak -e "/^[[:space:]]*$$/d" $$file && rm -f $${file}.bak
endef
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
.PHONY: check_not_root check_root
.SILENT: check_not_root check_root
check_not_root :
ifeq ($(shell id -u),0)
	- $(call print_color, $(YELLOW), "Please do not use sudo or run as root")
	- $(call print_failed_target)
	- exit 1
else
	- $(call print_completed_target)
	- exit 0
endif
check_root :
ifneq ($(shell id -u),0)
	- $(call print_color, $(YELLOW), "Please use sudo or run as root")
	- $(call print_failed_target)
	- exit 1
else
	- $(call print_completed_target)
	- exit 0
endif 
