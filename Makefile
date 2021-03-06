include pkg/functions/functions.mk
include pkg/color/color.mk

THIS_FILE := $(firstword $(MAKEFILE_LIST))
SELF_DIR := $(dir $(THIS_FILE))
.PHONY: all flatten remove-lines clean go-example
.SILENT: all flatten remove-lines clean go-example

flatten: clean
	- $(call print_running_target)
	- $(eval pkg_path=$(PWD)/pkg)
	- $(eval targets_path=$(PWD)/targets)
	- $(eval TARGET = $(call rwildcard,$(pkg_path),*.mk) $(call rwildcard,$(targets_path),*.mk))
	- $(eval output=$(PWD)/flattened/Makefile)
	- $(foreach O,\
			$(sort $(TARGET)),\
			$(call append_to_file,\
				$(output),$(call read_file_content,$O)\
			)\
		)
	- $(call print_completed_target,flattened makefiles)
	- $(call remove_matching_lines, #, $(output))
	- $(call print_completed_target,removed comments)
	- $(call remove_matching_lines, include, $(output))
	- $(call print_completed_target,removed includes)
	- $(call remove_empty_lines, $(output))
	- $(call print_completed_target,removed empty lines)
	- $(call print_completed_target)

remove-lines: 
	- $(RM) $(PWD)/README-backup.md
	- $(CPF) $(PWD)/README.md $(PWD)/README-backup.md
	- $(call remove_matching_lines, #, $(PWD)/README-backup.md)
	- $(call remove_empty_lines, $(PWD)/README-backup.md)
go-example: flatten
	- $(CPF) $(PWD)/flattened/Makefile $(PWD)/examples/go/Makefile

clean: 
	- $(RM) $(PWD)/flattened/Makefile
	- $(RM) $(PWD)/examples/go/Makefile
	- $(RM) $(PWD)/examples/go/bin
