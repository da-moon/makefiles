include pkg/functions/functions.mk
include pkg/color/color.mk
# todo remove me ...
include targets/os/os.mk

THIS_FILE := $(firstword $(MAKEFILE_LIST))
SELF_DIR := $(dir $(THIS_FILE))
.PHONY: all flatten remove-lines clean 
.SILENT: all flatten remove-lines clean 

flatten: clean
	- $(call print_running_target)
	- $(eval path=$(PWD)/pkg)
	- $(eval output=$(PWD)/flattened/Makefile)
	- $(eval TARGET = $(call rwildcard,$(path),*.mk))
	- $(foreach O,\
			$(sort $(TARGET)),\
			$(call append_to_file,\
				$(output),$(call read_file_content,$O)\
			)\
		)
	- $(call print_completed_target,flattened library files)
	# - $(call write_to_file,$(output),$(call remove_empty_line,$(call read_file_content,$(output))))
	# - $(call print_completed_target,removed empty lines)
	- $(eval path=$(PWD)/targets)
	- $(eval TARGET = $(call rwildcard,$(path),*.mk))
	- $(foreach O,\
			$(sort $(TARGET)),\
			$(call append_to_file,\
				$(output),$(call read_file_content,$O)\
			)\
		)
	- $(call print_completed_target,added targets to flattened library)
	- $(call print_completed_target)
	
remove-lines: 
	- $(eval TARGET=$(PWD)/README.md)
	- $(call write_to_file,$(TARGET).md,$(call remove_empty_line,$(call read_file_content,$(TARGET))))
	- $(MAKE) -f $(THIS_FILE) check_root
clean: 
	- $(eval res=$(PWD)/flattened/Makefile)
	- $(RM) $(res)


# ----
# $(eval loaded=$(call read_file_content,$(1)))
# echo $$blah

	# - $(info $(TARGET))
	# - $(call generate_file,$(TARGET))
