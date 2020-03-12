
include $(abspath $(dir $(lastword $(MAKEFILE_LIST)))/../../pkg/functions/functions.mk)
THIS_FILE := $(lastword $(MAKEFILE_LIST))
SELF_DIR := $(dir $(THIS_FILE))
.PHONY: first-target second-target
.SILENT: first-target second-target
# an example in calling a target from another one
first-target:
	- @$(MAKE) -f $(THIS_FILE) second-target
second-target:
	- $(info $(@))
	- $(info $(THIS_FILE))
