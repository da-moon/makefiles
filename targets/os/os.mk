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
