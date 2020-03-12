include $(abspath $(dir $(lastword $(MAKEFILE_LIST)))/../../pkg/functions/functions.mk)
.PHONY: store-to-file flatten-file
.SILENT: store-to-file flatten-file
# this is a dummy as a sample on how to store to a file
store-to-file: 
	- $(info $(^))
	- $(eval res=./$(@))
	- $(call empty_file,$(res))
	- $(foreach O,$(TARGET),$(file >>$(res),$O))
flatten-file: 
	- $(eval res=./$(@))
	- $(foreach O,$(TARGET),$(call append_to_file,$(res),$(call read_file_content,$O)))



