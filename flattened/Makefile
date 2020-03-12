
include $(abspath $(dir $(lastword $(MAKEFILE_LIST)))/../base/base.mk)
rwildcard=$(wildcard $1$2) $(foreach d,$(wildcard $1*),$(call rwildcard,$d/,$2))
# https://www.gnu.org/software/make/manual/html_node/Call-Function.html
recursive_call = $(foreach a,$(2),$(call $(1),$(a)))
relative_to_absolute=$(realpath $1)
pathsearch = $(firstword $(wildcard $(addsuffix /$(1),$(subst :, ,$(PATH)))))
read_file_content=$(file < $(1))
append_to_file=$(file >>$(1),$(2))
write_to_file=$(file >$(1),$(2))
empty_file=$(file >$(1),)
# make file used as base template
# for go projects
# OS specific part
# -----------------
ifeq ($(OS),Windows_NT)
    CLEAR = cls
    LS = dir
    TOUCH =>> 
    RM = del /F /Q
    CPF = copy /y
    RMDIR = -RMDIR /S /Q
    MKDIR = -mkdir
    ERRIGNORE = 2>NUL || (exit 0)
    GO_PATH = $(subst \,/,${GOPATH})
    SEP=\\
else
    CLEAR = clear
    GO_PATH = ${GOPATH}
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
nullstring :=
space := $(nullstring) 
PSEP = $(strip $(SEP))
PWD ?= $(realpath $(dir $(lastword $(MAKEFILE_LIST))))

# https://renenyffenegger.ch/notes/development/make/functions/foreach
include $(abspath $(dir $(lastword $(MAKEFILE_LIST)))/../base/base.mk)


VERSION   ?= $(shell git describe --tags)
REVISION  ?= $(shell git rev-parse HEAD)
BRANCH    ?= $(shell git rev-parse --abbrev-ref HEAD)
BUILDUSER ?= $(shell id -un)
BUILDTIME ?= $(shell date '+%Y%m%d-%H:%M:%S')
