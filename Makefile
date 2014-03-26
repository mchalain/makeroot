DPRINT=@echo

CURDIR=$(shell pwd)

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

CONFIG_FILE	?= .config
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
hostobjtree	:= $(CURDIR)/out/host/
TOOLCHAIN_PATH ?=$(if $(CONFIG_TOOLCHAIN_PATH:"%"=%),$(CONFIG_TOOLCHAIN_PATH:"%"=%),$(join $(hostobjtree),toolchain))/bin
sysroot=$(objtree)
PATH:=$(PATH):$(join $(hostobjtree), bin):$(TOOLCHAIN_PATH)
export GCC_FLAGS CROSS_COMPILE ARCH BOARD SUBARCH HFP THUMB TOOLCHAIN_PATH

root		:= $(CURDIR)
srctree		:= $(if $(BUILD_SRC),$(BUILD_SRC),$(CURDIR))
objtree		:= $(CURDIR)/out/target/$(if $(BOARD),$(BOARD)/)
hostobjtree	:= $(CURDIR)/out/host/
src			:= $(srctree)
obj			:= 
sysroot		:= $(objtree)/sysroot
packagesdir	:= $(objtree)/packages
rootfs		:= $(objtree)/rootfs
hostbin		:= $(hostobjtree)/bin
toolchain	:= $(CONFIG_TOOLCHAIN_PATH:"%"=%)
toolchain	?= $(join $(hostobjtree),toolchain)
export root srctree objtree sysroot hostobjtree
export packagesdir rootfs hostbin toolchain

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

%config: FORCE
	@echo Make $@
	$(Q)$(MAKE) $(build)=scripts/kconfig $@

$(CONFIG_FILE):
	$(error run " make menuconfig " first)

$(objtree)/auto.conf: $(CONFIG_FILE)
	$(Q)mkdir -p $(dir $@)
	$(Q)cp $(CONFIG_FILE) $@

SUBDIRS +=tools bootloader kernel system image
ifeq ($(CONFIG_TOOLCHAIN_INSTALL),y)
all: toolchain $(SUBDIRS)
toolchain:
	$(Q)$(MAKE) $(build)=tools/gcc
else
all: tools $(SUBDIRS)
endif

tree: system/tree
	$(Q)$(MAKE) $(build)=$<
libc: system/libc
	$(Q)$(MAKE) $(build)=$<
base: system/base
	$(Q)$(MAKE) $(build)=$<
init: system/init
	$(Q)$(MAKE) $(build)=$<
egl: system/lowlevel/graphics/egl
	$(Q)$(MAKE) $(build)=$<

bootloader: FORCE
	$(Q)$(MAKE) $(build)=$@

.PHONY:test
test:
	$(Q)$(MAKE) $(build)=$@

PHONY += $(SUBDIRS)  test
$(SUBDIRS): FORCE
	$(Q)$(MAKE) $(build)=$@

FORCE:;
