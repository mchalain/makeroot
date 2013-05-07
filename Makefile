DPRINT=@echo

ifeq ($(BUILD_SRC),)
# That's our default target when none is given on the command line
PHONY := _all
_all:

# Cancel implicit rules on top Makefile
$(CURDIR)/Makefile Makefile: ;
endif # ifeq ($(BUILD_SRC),)

PHONY+=all
_all: all

# CURDIR will be $(srctree)
MAKEFLAGS += --include-dir=$(srctree)

CONFIG_FILE	?= $(srctree)/.config
export CONFIG_FILE

srctree		:= $(if $(BUILD_SRC),$(BUILD_SRC),$(CURDIR))
-include  $(srctree)/$(CONFIG_FILE)

CROSS_COMPILE   ?= $(CONFIG_CROSS_COMPILE:"%"=%-)
ARCH ?= $(CONFIG_ARCH:"%"=%)
BOARD ?= $(CONFIG_BOARD_NAME:"%"=%)
SUBARCH ?= $(CONFIG_SUBARCH:"%"=%)
HFP ?= $(CONFIG_HFP_CPU:"%"=%)
THUMB ?= $(CONFIG_THUMB:"%"=%)
GCC_FLAGS ?=  $(CONFIG_GCC_FLAGS:"%"=%)
TOOLCHAIN_PATH ?=$(if $(CONFIG_TOOLCHAIN_PATH), $(CONFIG_TOOLCHAIN_PATH:"%"=%),$(join $(hostobjtree), toolchain/bin))
export CROSS_COMPILE ARCH BOARD SUBARCH HFP THUMB GCC_FLAGS TOOLCHAIN_PATH

srctree		:= $(if $(BUILD_SRC),$(BUILD_SRC),$(CURDIR))
objtree		:= $(CURDIR)/out/target/$(if $(BOARD),$(BOARD)/)
hostobjtree	:= $(CURDIR)/out/host/
src			:= $(srctree)
obj			:= 
sysroot		:= $(objtree)

export srctree objtree sysroot hostobjtree

# We need some generic definitions.
$(srctree)/scripts/include.mk: ;
include $(srctree)/scripts/include.mk

$(objtree):
	$(MKDIR) $(objtree)

# Basic helpers built in scripts/
PHONY += scripts_basic
scripts_basic:
	$(Q)$(MAKE) $(build)=scripts/basic
# To avoid any implicit rule to kick in, define an empty command.
scripts/basic/%: scripts_basic ;

PHONY+=menuconfig
menuconfig: scripts_basic
	$(Q)$(MAKE) $(build)=scripts/kconfig $@

$(CONFIG_FILE):
	$(error run " make menuconfig " first)

$(objtree)/include/config/auto.conf: $(CONFIG_FILE)
	$(Q)mkdir -p $(objtree)/include/config
	$(Q)cp $(CONFIG_FILE) $(objtree)/include/config/auto.conf 
	echo $@

SUBDIRS +=tree libc kernel env init system graphics image

all: toolchain $(SUBDIRS)

image: tree kernel libc env init 

toolchain:
	$(MAKE) $(build)=tools/gcc

bootloader: FORCE
	$(MAKE) $(build)=$@

PHONY += $(SUBDIRS)
$(SUBDIRS): FORCE
	$(MAKE) $(build)=$@

FORCE:;
