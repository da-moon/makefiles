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
define \nendef
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
include $(abspath $(dir $(lastword $(MAKEFILE_LIST)))/../string/string.mk)
# github.com/faiyaz7283/dcutil
define color_text
	tput setaf $(1); \
	[ "$3" ] && [ "$3" == "1" ] && tput bold; \
	printf $(2); \
	tput sgr0
endef
# Adds color to text and new line at the end
define print_color
	$(call color_text, $(1), $(2)'\n')
endef
# Print in dual colored text and new line at the end
define print_dual_color
	$(call color_text, $(1), $(2)); \
	$(call color_text, $(3), $(4)'\n')
endef
# Print in triple colored text and new line at the end
define print_triple_color
	$(call color_text, $(1), $(2)); \
	$(call color_text, $(3), $(4)); \
	$(call color_text, $(5), $(6)'\n')
endef
# Container enter printing
# $1 = command
# $2 = container
# $3 = shell
# $4 = user
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
# Container exit printing
define print_container_exit
	$(call color_text, 8, "\nExit; $$(date '+%Y-%m-%d %H:%M:%S')\n")
endef
# Running target printing
define print_running_target
	$(call trim, custom, $(1)); \
	custom=$${custom:-$@}; \
	$(call print_dual_color, ${GREEN}, "running... ", ${WHITE}, "$${custom}")
endef
# Target completed printing
define print_completed_target
	$(call trim, custom, $(1)); \
	custom=$${custom:-$@}; \
	$(call print_triple_color, ${GREEN}, "√ ", ${WHITE}, "$$custom", ${GREEN}, " done")
endef
# Target completed printing
define print_completed_target_new
	$(call trim, custom, $(1)); \
	custom=$${custom:-$(1)}; \
	custom=[$@]" "$${custom}  ; \
	$(call print_triple_color, ${GREEN}, "√ ", ${WHITE}, "$$custom", ${GREEN}, "done")
endef
# Target failed printing
define print_failed_target
	$(call trim, custom, $(1)); \
	custom=$${custom:-$@}; \
	$(call print_triple_color, ${RED}, "X ", ${WHITE}, "$${custom} ", ${RED}, "failed")
endef
# info printing
define print_target_info
	$(call print_dual_color, ${CYAN}, " • ", ${WHITE}, $(1))
endef
# general printing
define print_target_general
	$(call print_dual_color, ${WHITE}, " • ", ${WHITE}, $(1))
endef
# success printing
define print_target_success
	$(call print_dual_color, ${GREEN}, " • ", ${WHITE}, $(1))
endef
# error printing
define print_target_error
	$(call print_dual_color, ${RED}, " • ", ${WHITE}, $(1))
endef
# Print command for a specific type
define print_command
	$(call trim, name, $(1)); \
	$(call trim, commands, $(2)); \
	commands="$${commands// /\\n - }"; \
	$(call print_dual_color, ${WHITE}, "\n$${name} commands: \n", ${GREEN}, " - $${commands}")
endef
# Get the pmf target label for printing
define get_pmf_target_label
	$(call get_custom_project_makefile); \
    makefilename="$$(basename $${pmf})"; \
	$(call trim, target, $(1)); \
    pmf_target_label="$${makefilename} » $$target"
endef 
include $(abspath $(dir $(lastword $(MAKEFILE_LIST)))/../base/base.mk)
define rwildcard
$(wildcard $1$2) $(foreach d,$(wildcard $1*),$(call rwildcard,$d/,$2))
endef
# https://www.gnu.org/software/make/manual/html_node/Call-Function.html
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
# MIN - Parameterized "function" that results in the minimum lexical value of
#   the two values given.
define MIN
$(firstword $(sort ${1} ${2}))
endef
# PEEK - Parameterized "function" that results in the value at the top of the
#   specified colon-delimited stack.
define PEEK
$(lastword $(subst :, ,${1}))
endef
# POP - Parameterized "function" that pops the top value off of the specified
#   colon-delimited stack, and results in the new value of the stack. Note that
#   the popped value cannot be obtained using this function; use peek for that.
define POP
${1:%:$(lastword $(subst :, ,${1}))=%}
endef
# PUSH - Parameterized "function" that pushes a value onto the specified colon-
#   delimited stack, and results in the new value of the stack.
define PUSH
${2:%=${1}:%}
endef
# QUALIFY_PATH - Given a "root" directory and one or more paths, qualifies the
#   paths using the "root" directory (i.e. appends the root directory name to
#   the paths) except for paths that are absolute.
define QUALIFY_PATH
$(addprefix ${1}/,$(filter-out /%,${2})) $(filter /%,${2})
endef
# Retrieves a host part of the given string (without port).
# Param:
#   1. String to parse in form 'host[:port]'.
define extract_host
$(firstword \
	$(subst :, ,$1)\
)
endef
# Returns a port (if any).
# If there is no port part in the string, returns the second argument
# (if specified).
# Param:
#   1. String to parse in form 'host[:port]'.
#   2. (optional) Fallback value.
define extract_port
$(or \
	$(word 2,\
		$(subst :, ,$1)\
	),$(value 2)\
)
endef
define replace_space_with_empty_line
$(subst ${ },${\n},${1})
endef
define replace_empty_line_with_space
$(subst ${\n},${ },${1})
endef
define remove_empty_line_
$(subst ${\n}${\n},${\n},${1})
endef
define remove_empty_line
$(subst $(\n)$(\n),,$(subst $(\n)$(\n),$(\n),$(1)))
endef 
include $(abspath $(dir $(lastword $(MAKEFILE_LIST)))/../base/base.mk)VERSION   ?= $(shell git describe --tags)
REVISION  ?= $(shell git rev-parse HEAD)
BRANCH    ?= $(shell git rev-parse --abbrev-ref HEAD)
BUILDUSER ?= $(shell id -un)
BUILDTIME ?= $(shell date '+%Y%m%d-%H:%M:%S') 
# github.com/faiyaz7283/dcutil
include $(abspath $(dir $(lastword $(MAKEFILE_LIST)))/../base/base.mk)
# Convert string to upper
define to_upper
	$(1)=$$(echo $(2) | tr '[:lower:]' '[:upper:]')
endef
# Convert string to lower
define to_lower
	$(1)=$$(echo $(2) | tr '[:upper:]' '[:lower:]')
endef# Trim white spaces
define trim
	value="$(2)"; \
	$(1)=$$(echo $${value%/} | xargs)
endef
# Set a var
define var
	$(call trim, value, $(2)); \
	$(1)="$$value"
endef
# Search for string, replace with string in the given file
define find_replace
	if [ "$(4)" ]; then \
		$(call trim, dlm, $(4)); \
	else \
		dlm=#; \
	fi; \
	$(call trim, find, $(1)); \
	$(call trim, replace, $(2)); \
	$(call trim, file, $(3)); \
	sed -i.bak -e "s$${dlm}$${find}$${dlm}$${replace}$${dlm}g" $$file && rm -f $${file}.bak
endef
# Replace or update
define replace_or_update
	$(call trim, var_name, $(1)); \
	var_name=$${var_name%'%'}; \
	var_name=$${var_name#'%'}; \
        $(call find_replace, $(1), $(2), $(3), $${4:-#}); \
	if [ "$${!var_name}" ] && [ -f "$${file}.backup" ]; then \
		$(call remove_matching_line, $$var_name, $${file}.backup); \
	fi
endef
# Search for matching string, and remove the entire line
define remove_matching_line
	$(call trim, find, $(1)); \
	$(call trim, file, $(2)); \
	sed -i.bak -e "/$${find}/d" $$file && rm -f $${file}.bak
endef
 
include $(abspath $(dir $(lastword $(MAKEFILE_LIST)))/../../pkg/color/color.mk)

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
