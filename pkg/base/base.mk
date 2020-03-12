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