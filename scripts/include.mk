####
#  Generic definitions

# SHELL used by kbuild
CONFIG_SHELL := $(shell if [ -x "$$BASH" ]; then echo $$BASH; \
	  else if [ -x /bin/bash ]; then echo /bin/bash; \
	  else echo sh; fi ; fi)

include $(srctree)/scripts/mode.mk

# Convenient variables
comma   := ,
squote  := '
empty   :=
space   := $(empty) $(empty)

###
# Name of target with a '.' as filename prefix. foo/bar.o => foo/.bar.o
dot-target = $(dir $@).$(basename $(notdir $@))

###
# The temporary file to save gcc -MD generated dependencies must not
# contain a comma
depfile = $(subst $(comma),_,$(dot-target).d)

###
# filename of target with directory and extension stripped
basetarget = $(basename $(notdir $@))

###
# Escape single quote for use in echo statements
escsq = $(subst $(squote),'\$(squote)',$1)

###
# filechk is used to check if the content of a generated file is updated.
# Sample usage:
# define filechk_sample
#	echo $KERNELRELEASE
# endef
# version.h : Makefile
#	$(call filechk,sample)
# The rule defined shall write to stdout the content of the new file.
# The existing file will be compared with the new one.
# - If no file exist it is created
# - If the content differ the new file is used
# - If they are equal no change, and no timestamp update
# - stdin is piped in from the first prerequisite ($<) so one has
#   to specify a valid file as first prerequisite (often the kbuild file)
define filechk
	$(Q)set -e;				\
	echo '  CHK     $@';			\
	mkdir -p $(dir $@);			\
	$(filechk_$(1)) < $< > $@.tmp;		\
	if [ -r $@ ] && cmp -s $@ $@.tmp; then	\
		rm -f $@.tmp;			\
	else					\
		echo '  UPD     $@';		\
		mv -f $@.tmp $@;		\
	fi
endef

######
# gcc support functions
# See documentation in Documentation/kbuild/makefiles.txt

# output directory for tests below
TMPOUT := $(if $(KBUILD_EXTMOD),$(firstword $(KBUILD_EXTMOD))/)

# try-run
# Usage: option = $(call try-run, $(CC)...-o "$$TMP",option-ok,otherwise)
# Exit code chooses option. "$$TMP" is can be used as temporary file and
# is automatically cleaned up.
try-run = $(shell set -e;		\
	TMP="$(TMPOUT).$$$$.tmp";	\
	if ($(1)) >/dev/null 2>&1;	\
	then echo "$(2)";		\
	else echo "$(3)";		\
	fi;				\
	rm -f "$$TMP")

# as-option
# Usage: cflags-y += $(call as-option,-Wa$(comma)-isa=foo,)

as-option = $(call try-run,\
	$(CC) $(CFLAGS) $(1) -c -xassembler /dev/null -o "$$TMP",$(1),$(2))

# as-instr
# Usage: cflags-y += $(call as-instr,instr,option1,option2)

as-instr = $(call try-run,\
	echo -e "$(1)" | $(CC) $(AFLAGS) -c -xassembler -o "$$TMP" -,$(2),$(3))

# cc-option
# Usage: cflags-y += $(call cc-option,-march=winchip-c6,-march=i586)

cc-option = $(call try-run,\
	$(CC) $(CFLAGS) $(1) -S -xc /dev/null -o "$$TMP",$(1),$(2))

# cc-option-yn
# Usage: flag := $(call cc-option-yn,-march=winchip-c6)
cc-option-yn = $(call try-run,\
	$(CC) $(CFLAGS) $(1) -S -xc /dev/null -o "$$TMP",y,n)

# cc-option-align
# Prefix align with either -falign or -malign
cc-option-align = $(subst -functions=0,,\
	$(call cc-option,-falign-functions=0,-malign-functions=0))

# cc-version
# Usage gcc-ver := $(call cc-version)
cc-version = $(shell $(CONFIG_SHELL) $(srctree)/scripts/gcc-version.sh $(CC))

# cc-fullversion
# Usage gcc-ver := $(call cc-fullversion)
cc-fullversion = $(shell $(CONFIG_SHELL) \
	$(srctree)/scripts/gcc-version.sh -p $(CC))

# cc-ifversion
# Usage:  EXTRA_CFLAGS += $(call cc-ifversion, -lt, 0402, -O1)
cc-ifversion = $(shell [ $(call cc-version, $(CC)) $(1) $(2) ] && echo $(3))

# ld-option
# Usage: ldflags += $(call ld-option, -Wl$(comma)--hash-style=both)
ld-option = $(call try-run,\
	$(CC) $(1) -nostdlib -xc /dev/null -o "$$TMP",$(1),$(2))

######

###
# Shorthand for $(Q)$(MAKE) -f scripts/Makefile obj=
# Usage:
# $(Q)$(MAKE) $(build)=dir
build := -f $(if $(BUILD_SRC),$(srctree)/)scripts/Makefile obj
android-build := -C $(if $(BUILD_SRC),$(srctree)/)scripts/android ONE_SHOT_MAKEFILE

# Prefix -I with $(srctree) if it is not an absolute path.
addtree = $(if $(filter-out -I/%,$(1)),$(patsubst -I%,-I$(srctree)/%,$(1))) $(1)

# Find all -I options and call addtree
flags = $(foreach o,$($(1)),$(if $(filter -I%,$(o)),$(call addtree,$(o)),$(o)))

# use the cmd like :
# $(call cmd,<cmd_name>)
# without space after the virgule

# echo command.
# Short version is used, if $(quiet) equals `quiet_', otherwise full one.
echo-cmd = $(if $($(quiet)cmd_$(1)),\
	echo '  $(call escsq,$($(quiet)cmd_$(1)))$(echo-why)';)

# printing commands
cmd = $(echo-cmd) $(cmd_$(1))

# Add $(obj)/ for paths that are not absolute
objectify = $(foreach o,$(1),$(if $(filter /%,$(o)),$(o),$(obj)/$(o)))

###
# if_changed      - execute command if any prerequisite is newer than
#                   target, or command line has changed
# if_changed_dep  - as if_changed, but uses fixdep to reveal dependencies
#                   including used config symbols
# if_changed_rule - as if_changed but execute rule instead
# See Documentation/kbuild/makefiles.txt for more info

ifneq ($(KBUILD_NOCMDDEP),1)
# Check if both arguments has same arguments. Result is empty string if equal.
# User may override this check using make KBUILD_NOCMDDEP=1
arg-check = $(strip $(filter-out $(cmd_$(1)), $(cmd_$@)) \
                    $(filter-out $(cmd_$@),   $(cmd_$(1))) )
endif

# >'< substitution is for echo to work,
# >$< substitution to preserve $ when reloading .cmd file
# note: when using inline perl scripts [perl -e '...$$t=1;...']
# in $(cmd_xxx) double $$ your perl vars
make-cmd = $(subst \#,\\\#,$(subst $$,$$$$,$(call escsq,$(cmd_$(1)))))

# Find any prerequisites that is newer than target or that does not exist.
# PHONY targets skipped in both cases.
any-prereq = $(filter-out $(PHONY),$?) $(filter-out $(PHONY) $(wildcard $^),$^)

# Execute command if command has changed or prerequisite(s) are updated.
#
if_changed = $(if $(strip $(any-prereq) $(arg-check)),                       \
	@set -e;                                                             \
	$(echo-cmd) $(cmd_$(1));                                             \
	echo 'cmd_$@ := $(make-cmd)' > $(dot-target).cmd)

# Execute the command and also postprocess generated .d dependencies file.
if_changed_dep = $(if $(strip $(any-prereq) $(arg-check) ),                  \
	@set -e;                                                             \
	$(echo-cmd) $(cmd_$(1));                                             \
	scripts/basic/fixdep $(depfile) $@ '$(make-cmd)' > $(dot-target).tmp;\
	rm -f $(depfile);                                                    \
	mv -f $(dot-target).tmp $(dot-target).cmd)

# Usage: $(call if_changed_rule,foo)
# Will check if $(cmd_foo) or any of the prerequisites changed,
# and if so will execute $(rule_foo).
if_changed_rule = $(if $(strip $(any-prereq) $(arg-check) ),                 \
	@set -e;                                                             \
	$(rule_$(1)))

###
# why - tell why a a target got build
#       enabled by make V=2
#       Output (listed in the order they are checked):
#          (1) - due to target is PHONY
#          (2) - due to target missing
#          (3) - due to: file1.h file2.h
#          (4) - due to command line change
#          (5) - due to missing .cmd file
#          (6) - due to target not in $(targets)
# (1) PHONY targets are always build
# (2) No target, so we better build it
# (3) Prerequisite is newer than target
# (4) The command line stored in the file named dir/.target.cmd
#     differed from actual command line. This happens when compiler
#     options changes
# (5) No dir/.target.cmd file (used to store command line)
# (6) No dir/.target.cmd file and target not listed in $(targets)
#     This is a good hint that there is a bug in the kbuild file
ifeq ($(BUILD_VERBOSE),2)
why =                                                                        \
    $(if $(filter $@, $(PHONY)),- due to target is PHONY,                    \
        $(if $(wildcard $@),                                                 \
            $(if $(strip $(any-prereq)),- due to: $(any-prereq),             \
                $(if $(arg-check),                                           \
                    $(if $(cmd_$@),- due to command line change,             \
                        $(if $(filter $@, $(targets)),                       \
                            - due to missing .cmd file,                      \
                            - due to $(notdir $@) not in $$(targets)         \
                         )                                                   \
                     )                                                       \
                 )                                                           \
             ),                                                              \
             - due to target missing                                         \
         )                                                                   \
     )

echo-why = $(call escsq, $(strip $(why)))
endif

# Add subdir path

extra-y		:= $(addprefix $(obj)/,$(extra-y))
always		:= $(addprefix $(obj)/,$(always))
targets		:= $(addprefix $(objtree)/,$(targets))
obj-y		:= $(addprefix $(obj)/,$(obj-y))
obj-m		:= $(addprefix $(obj)/,$(obj-m))
lib-y		:= $(addprefix $(obj)/,$(lib-y))
subdir-obj-y	:= $(addprefix $(obj)/,$(subdir-obj-y))
real-objs-y	:= $(addprefix $(obj)/,$(real-objs-y))
real-objs-m	:= $(addprefix $(obj)/,$(real-objs-m))
single-used-m	:= $(addprefix $(obj)/,$(single-used-m))
multi-used-y	:= $(addprefix $(obj)/,$(multi-used-y))
multi-used-m	:= $(addprefix $(obj)/,$(multi-used-m))
multi-objs-y	:= $(addprefix $(obj)/,$(multi-objs-y))
multi-objs-m	:= $(addprefix $(obj)/,$(multi-objs-m))
subdir-ym	:= $(addprefix $(obj)/,$(subdir-ym))
obj-dirs	:= $(addprefix $(obj)/,$(obj-dirs))
#subproject-y := $(addprefix $(obj)/,$(subproject-y))

ifneq ($(strip $(root)),)
objtree:=$(addsuffix $(root),$(objtree))
hostobjtree:=$(addsuffix $(root),$(hostobjtree))
endif
