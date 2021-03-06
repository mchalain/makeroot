# ==========================================================================
# Building
# ==========================================================================

src := $(obj)

PHONY := __build
__build:

# Init all relevant variables used in kbuild files so
# 1) they have correct type
# 2) they do not inherit any value from the environment
obj-y :=
obj-m :=
lib-y :=
lib-m :=
always :=
targets :=
subdir-y :=
subdir-m :=
subproject-y :=
download-y :=
install-y :=
EXTRA_AFLAGS   :=
EXTRA_CFLAGS   :=
EXTRA_CPPFLAGS :=
EXTRA_LDFLAGS  :=

$(VERSION_FILE): versioning/default.config
	cp $< $@

# Read .config if it exist, otherwise ignore
include $(CONFIG_FILE)
include $(VERSION_FILE)

# The filename Kbuild has precedence over Makefile
build-dir := $(if $(filter /%,$(src)),$(src),$(srctree)/$(src))
PHONY+=$(build-dir)
include  $(build-dir)/Makefile

include scripts/tool.mk

include scripts/include.mk

include scripts/android.mk

hostobj:=$(obj)
hostbin:=$(hostobjtree)/bin
hostlib:=$(hostobjtree)/lib

ifneq ($(strip $(lib-y) $(lib-m) $(lib-n) $(lib-)),)
include scripts/library.mk
lib-target := $(obj)/lib.a
endif

# Do not include host rules unles needed
ifneq ($(hostprogs-y)$(hostprogs-m),)
include scripts/host.mk
host-target := $(host-csingle) $(host-cmulti) $(host-cxxmulti) $(host-cshlib) $(sdk-pkgconfig) $(sdk-csingle) $(sdk-cmulti) $(sdk-cxxmulti) $(sdk-cshlib)
download-y+=$(foreach prog,$(hostprogs-y)$(hostprogs-m),$(if $($(prog)-url),$(prog)))
endif

include scripts/install.mk

include scripts/toolchain.mk
download-y+=$(foreach prog, $(toolchain-y),$(if $($(prog)-url),$(prog)))
toolchain-target:=$(hostobjtree)/toolchain

# Do not include projects rules unles needed
ifneq ($(subproject-y) $(subproject-m),)
download-y+=$(foreach prog, $(subproject-y) $(subproject-m),$(if $($(prog)-url),$(prog),$(if $($(prog)-git),$(prog))))
include scripts/project.mk
endif

ifneq ($(strip $(obj-y) $(obj-m) $(obj-n) $(obj-) $(lib-target)),)
include scripts/builtin.mk
builtin-target := $(obj)/built-in.o
endif

include scripts/subdir.mk

ifneq ($(download-y),)
download-target:=$(addprefix $(obj)/.,$(addsuffix .dwl,$(download-y)))
include scripts/download.mk
endif

ifneq ($(image-y),)
image-target:=$(addsuffix .img,$(addprefix $(objtree)/,$(image-y)))
include scripts/image.mk
endif
# ===========================================================================

ifneq ($(BUILD_SRC),)
# Create output directory if not already present
_dummy := $(shell [ -d $(obj) ] || mkdir -p $(obj))

# Create directories for object files if directory does not exist
# Needed when obj-y := dir/file.o syntax is used
_dummy := $(foreach d,$(obj-dirs), $(shell [ -d $(d) ] || mkdir -pv $(d)))

endif

# Linus' kernel sanity checking tool
ifneq ($(BUILD_CHECKSRC),0)
  ifeq ($(BUILD_CHECKSRC),2)
    quiet_cmd_force_checksrc = CHECK   $<
	  cmd_force_checksrc = $(CHECK) $(CHECKFLAGS) $(c_flags) $< ;
  else
      quiet_cmd_checksrc     = CHECK   $<
	    cmd_checksrc     = $(CHECK) $(CHECKFLAGS) $(c_flags) $< ;
  endif
endif


# Build the compiled-in targets
# ---------------------------------------------------------------------------

# To build objects in subdirs, we need to descend into the directories
$(sort $(subdir-obj-y)): $(subdir-ym) ;

#
# Rule to compile a set of .o files into one .o file
#
ifdef builtin-target
targets += $(builtin-target)
endif # builtin-target

#
# Rule to compile a set of .o files into one .a file
#
targets += $(toolchain-target)

targets += $(host-target)

ifdef lib-target
targets += $(lib-target)
endif

targets += $(multi-used-y) $(multi-used-m)

# Descending
# ---------------------------------------------------------------------------

# Add FORCE to the prequisites of a target to force it to be always rebuilt.
# ---------------------------------------------------------------------------

PHONY += FORCE

FORCE:

# Read all saved command lines and dependencies for the $(targets) we
# may be building above, using $(if_changed{,_dep}). As an
# optimization, we don't need to read them if the target does not
# exist, we will rebuild anyway in that case.

targets := $(wildcard $(sort $(targets)))
cmd_files := $(wildcard $(foreach f,$(targets),$(dir $(f)).$(notdir $(f)).cmd))

# targets-y is rules which don't depend of a file
targets += $(targets-y)

ifneq ($(cmd_files),)
  include $(cmd_files)
endif

__build: \
	 $(download-target) $(host-target) $(pre-install-y) $(toolchain-target) \
	 $(subproject-y) $(install-y) $(image-target) $(subdir-ym)
	@:

ifeq (y,$(force-install))
target:="force-install=y install"
endif
install: $(subdir-ym) $(targets) $(extra-y) $(pre-install-y)\
	 $(subproject-y) $(install-y) $(image-target)
	@:
download: target:=download
download: $(subdir-ym) $(download-target)
	@:
$(rootfs) $(packagesdir) $(sysroot) $(bootfs) $(homefs) $(hostbin) $(host-objdirs) $(hostlib) $(hostlib)/pkgconfig:
	$(Q)mkdir -p $@

# Declare the contents of the .PHONY variable as phony.  We keep that
# information in a variable se we can use it in if_changed and friends.

.PHONY: $(PHONY)
