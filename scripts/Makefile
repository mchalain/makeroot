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

# Read .config if it exist, otherwise ignore
include $(CONFIG_FILE)

# The filename Kbuild has precedence over Makefile
build-dir := $(if $(filter /%,$(src)),$(src),$(srctree)/$(src))
PHONY+=$(build-dir)
include  $(build-dir)/Makefile

include scripts/tool.mk

include scripts/include.mk

ifneq ($(strip $(lib-y) $(lib-m) $(lib-n) $(lib-)),)
include scripts/library.mk
lib-target := $(obj)/lib.a
endif

# Do not include host rules unles needed
ifneq ($(hostprogs-y)$(hostprogs-m),)
include scripts/host.mk
host-target := $(host-csingle) $(host-cmulti) $(host-cxxmulti) $(host-cshlib)
download-y+=$(foreach prog,$(hostprogs-y)$(hostprogs-m),$(if $($(prog)-url),$(prog)))
endif

# Do not include directories management rules unles needed
ifneq ($(install-y),)
include scripts/install.mk
endif

# Do not include projects rules unles needed
ifneq ($(subproject-y) $(subproject-m),)
download-y+=$(foreach prog, $(subproject-y) $(subproject-m),$(if $($(prog)-url),$(prog)))
include scripts/project.mk
endif

ifneq ($(toolchain-y),)
include scripts/toolchain.mk
toolchain-target :=  $(addprefix $(hostobjtree)/,$(toolchain-y))
download-y+=$(foreach prog, $(toolchain-y),$(if $($(prog)-url),$(prog)))
endif

ifneq ($(strip $(obj-y) $(obj-m) $(obj-n) $(obj-) $(lib-target)),)
include scripts/builtin.mk
builtin-target := $(obj)/built-in.o
endif

include scripts/subdir.mk

ifneq ($(download-y),)
download-y:=$(addprefix $(obj)/.,$(addsuffix .dwl,$(download-y)))
include scripts/download.mk
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

targets += $(targets-y)

# Descending
# ---------------------------------------------------------------------------

PHONY += $(subdir-ym)
$(subdir-ym):
	$(Q)$(MAKE) $(build)=$@

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

ifneq ($(cmd_files),)
  include $(cmd_files)
endif

__build: $(subdir-ym) $(targets) $(extra-y) \
	 $(download-y) $(host-target) $(toolchain-target) \
	 $(subproject-y) $(install-y)
	@:


# Declare the contents of the .PHONY variable as phony.  We keep that
# information in a variable se we can use it in if_changed and friends.

.PHONY: $(PHONY)
