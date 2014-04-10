MAKEROOT_NAME:=makeroot
export MAKEROOT_NAME

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

BOARD ?= $(CONFIG_BOARD_NAME:"%"=%)
TOOLCHAIN_PATH ?=$(if $(CONFIG_TOOLCHAIN_PATH:"%"=%),$(CONFIG_TOOLCHAIN_PATH:"%"=%),$(CURDIR)/out/host/toolchain/bin)

root		:= $(CURDIR)
srctree		:= $(if $(BUILD_SRC),$(BUILD_SRC),$(CURDIR))
objtree		:= $(strip out/target/$(if $(BOARD),$(BOARD)/))
hostobjtree	:= out/host/
src			:= $(srctree)
obj			:= 
sysroot		:= $(root)/$(objtree)/sysroot
packagesdir	:= $(root)/$(objtree)/packages
rootfs		:= $(root)/$(objtree)/rootfs
bootfs		:= $(root)/$(objtree)/boot
homefs		:= $(root)/$(objtree)/homefs
objtree		:= $(root)/$(objtree)
hostobjtree	:= $(root)/$(hostobjtree)
hostbin		:= $(hostobjtree)/bin
hostlib		:= $(hostobjtree)/lib
toolchain_path	:= $(TOOLCHAIN_PATH)
toolchain_path	?= $(join $(hostobjtree),toolchain_path)
export root srctree objtree sysroot 
export hostobjtree hostbin toolchain_path
export packagesdir rootfs bootfs homefs

CROSS_COMPILE   ?= $(CONFIG_CROSS_COMPILE:"%"=%-)
ARCH ?= $(CONFIG_ARCH:"%"=%)
SUBARCH ?= $(CONFIG_SUBARCH:"%"=%)
HFP ?= $(CONFIG_HFP_CPU:"%"=%)
THUMB ?= $(CONFIG_THUMB:"%"=%)
GCC_FLAGS ?=  $(CONFIG_GCC_FLAGS:"%"=%)
PATH:=$(hostbin):$(toolchain_path):$(PATH)
export GCC_FLAGS CROSS_COMPILE ARCH BOARD SUBARCH HFP THUMB PATH

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

SUBDIRS +=tools bootloader kernel system custom image
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

install:
	$(Q)$(MAKE) $(build)=image install

.PHONY:test
test:
	$(Q)$(MAKE) $(build)=$@

PHONY += $(SUBDIRS)  test
$(SUBDIRS): FORCE
	$(Q)$(MAKE) $(build)=$@

FORCE:;
