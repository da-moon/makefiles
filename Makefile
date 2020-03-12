include pkg/functions/functions.mk
include examples/basic/basic-example.mk
THIS_FILE := $(firstword $(MAKEFILE_LIST))
SELF_DIR := $(dir $(THIS_FILE))
.PHONY: all flatten-repo remove-lines
.SILENT: all flatten-repo remove-lines
flatten-repo: 
	- $(eval EXT=mk)
	- $(eval path=$(PWD)/pkg)
	- $(eval res=$(PWD)/flattened/Makefile)
	- $(eval TARGET = $(call rwildcard,$(path),*.${EXT}))
	- $(call empty_file,$(res))
	- $(foreach O,$(TARGET),$(call append_to_file,$(res),$(call read_file_content,$O)))
remove-lines: 
	- $(eval EXT=mk)
	- $(eval path=$(PWD)/pkg)
	- $(eval TARGET = $(call rwildcard,$(path),*.${EXT}))
	- $(foreach O,$(TARGET),$(info $(res),$(res),$(call read_file_content,$O)))