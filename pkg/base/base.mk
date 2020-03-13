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

# nullstring :=
# space := $(nullstring)

null :=
space := ${null} ${null}
PSEP = $(strip $(SEP))
PWD ?= $(realpath $(dir $(lastword $(MAKEFILE_LIST))))
# ${ } is a space
${space} := ${space}
BLACK = 0
RED = 1
GREEN = 2
YELLOW = 3
BLUE = 4
MAGENTA = 5
CYAN = 6
WHITE = 7

# https://renenyffenegger.ch/notes/development/make/functions/foreach
# https://unix.stackexchange.com/questions/33629/how-can-i-populate-a-file-with-random-data
# https://stackoverflow.com/questions/26554186/with-gnu-make-how-can-i-combine-multiple-files-into-one/26554251




