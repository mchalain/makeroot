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

VERSION_FILE	?= versioning/.config
export VERSION_FILE

srctree		:= $(if $(BUILD_SRC),$(BUILD_SRC),$(CURDIR))
-include  $(srctree)/$(CONFIG_FILE)
-include  $(srctree)/$(VERSION_FILE)

BOARD ?= $(CONFIG_CONFIGNAME:"%"=%)
TOOLCHAIN_PATH ?=$(if $(CONFIG_TOOLCHAIN_PATH:"%"=%),$(CONFIG_TOOLCHAIN_PATH:"%"=%),$(CURDIR)/out/host/toolchain)

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
export root srctree objtree sysroot 
export hostobjtree hostbin toolchain_path
export packagesdir rootfs bootfs homefs

SYSTEM		:= $(CONFIG_SYSTEM:"%"=%)
CONFIGDIR	:= $(CONFIG_CONFIGDIR:"%"=%)
export SYSTEM CONFIGDIR

CROSS_COMPILE   ?= $(CONFIG_CROSS_COMPILE:"%"=%-)
KERNEL	?= $(if $(findstring y,$(CONFIG_LINUX)),linux,none)
ARCH ?= $(CONFIG_ARCH:"%"=%)
SUBARCH ?= $(CONFIG_SUBARCH:"%"=%)
HFP ?= $(CONFIG_HFP_CPU:"%"=%)
THUMB ?= $(CONFIG_THUMB:"%"=%)
ABI?=$(strip \
	$(if $(findstring arm,$(ARCH)), \
		$(if $(findstring y,$(THUMB)),thumb,\
		eabi\
		)\
	))
ifeq ($(CONFIG_LIBC_TOOLCHAIN),y)
LIBC?= \
	$(if $(findstring gnu,$(CROSS_COMPILE)),gnu,\
		$(if $(findstring uclibc,$(CROSS_COMPILE)),uclibc,\
			$(if $(findstring android,$(CROSS_COMPILE)),android,\
				$(if $(findstring musl,$(CROSS_COMPILE)),gnumusl,\
					$(if $(findstring dietlibc,$(CROSS_COMPILE)),dietlibc,\
						) \
				) \
			) \
		) \
	)

TRIPLET:=$(ARCH)-unknown-$(KERNEL)-$(LIBC)$(ABI)
else
LIBC:=$(strip \
	$(if $(findstring y,$(CONFIG_LIBC_GLIBC_SP)) $(findstring y,$(CONFIG_LIBC_EGLIBC_SP)),gnu,\
		$(if $(findstring y,$(CONFIG_LIBC_UCLIBC)),uclibc,\
			$(if $(findstring y,$(CONFIG_LIBC_BIONIC)),android,\
				$(if $(findstring y,$(CONFIG_LIBC_MUSL_SP)),gnumusl,\
					$(if $(findstring y,$(CONFIG_LIBC_DIETLIBC)),dietlibc,\
						$(if $(findstring y,$(CONFIG_LIBC_NEWLIB)),) \
					) \
				) \
			) \
		) \
	))
TRIPLET:=$(ARCH)-unknown-$(KERNEL)-$(LIBC)$(ABI)
endif
LIBC:=$(if $(LIBC),$(LIBC),newlib)
LDSO:=ld.so.1
export CROSS_COMPILE KERNEL ARCH LIBC BOARD SUBARCH HFP THUMB TRIPLET LDSO

GCC_FLAGS ?=  $(CONFIG_GCC_FLAGS:"%"=%)
export GCC_FLAGS
PATH:=$(hostbin):$(toolchain_path)/bin:$(PATH)
export PATH


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
all: $(SUBDIRS)
endif
install: target:="force-install=y install"
install: $(SUBDIRS)

download: target:=download
download: $(SUBDIRS)

tree: system/tree
	$(Q)$(MAKE) $(build)=$< $(target)
libc: system/libc
	$(Q)$(MAKE) $(build)=$< $(target)
base: system/base
	$(Q)$(MAKE) $(build)=$< $(target)
init: system/init
	$(Q)$(MAKE) $(build)=$< $(target)
egl: system/lowlevel/graphics/egl
	$(Q)$(MAKE) $(build)=$< $(target)

.PHONY:test
test:
	echo $(TRIPLET) $(HFP) $(LIBC) $(CONFIG_CONFIG_LIBC_TOOLCHAIN)
#	$(Q)$(MAKE) $(build)=$@ $(target)

PHONY += $(SUBDIRS)  test
$(SUBDIRS): FORCE
	$(Q)$(MAKE) $(build)=$@ $(target)

FORCE:;
