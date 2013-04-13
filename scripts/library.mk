# Backward compatibility - to be removed...
extra-y	+= $(EXTRA_TARGETS)
# Figure out what we need to build from the various variables
# ===========================================================================

# When an object is listed to be built compiled-in and modular,
# only build the compiled-in version

obj-m := $(filter-out $(obj-y),$(obj-m))

# Libraries are always collected in one lib file.
# Filter out objects already built-in

lib-y := $(filter-out $(obj-y), $(sort $(lib-y) $(lib-m)))


# Handle objects in subdirs
# ---------------------------------------------------------------------------
# o if we encounter foo/ in $(obj-y), replace it by foo/built-in.o
#   and add the directory to the list of dirs to descend into: $(subdir-y)
# o if we encounter foo/ in $(obj-m), remove it from $(obj-m) 
#   and add the directory to the list of dirs to descend into: $(subdir-m)

__subdir-y	:= $(patsubst %/,%,$(filter %/, $(obj-y)))
subdir-y	+= $(__subdir-y)
__subdir-m	:= $(patsubst %/,%,$(filter %/, $(obj-m)))
subdir-m	+= $(__subdir-m)
obj-y		:= $(patsubst %/, %/built-in.o, $(obj-y))
obj-m		:= $(filter-out %/, $(obj-m))

# if $(foo-objs) exists, foo.o is a composite object 
multi-used-y := $(sort $(foreach m,$(obj-y), $(if $(strip $($(m:.o=-objs)) $($(m:.o=-y))), $(m))))
multi-used-m := $(sort $(foreach m,$(obj-m), $(if $(strip $($(m:.o=-objs)) $($(m:.o=-y))), $(m))))
multi-used   := $(multi-used-y) $(multi-used-m)
single-used-m := $(sort $(filter-out $(multi-used-m),$(obj-m)))

# Build list of the parts of our composite objects, our composite
# objects depend on those (obviously)
multi-objs-y := $(foreach m, $(multi-used-y), $($(m:.o=-objs)) $($(m:.o=-y)))
multi-objs-m := $(foreach m, $(multi-used-m), $($(m:.o=-objs)) $($(m:.o=-y)))
multi-objs   := $(multi-objs-y) $(multi-objs-m)

# $(subdir-obj-y) is the list of objects in $(obj-y) which do not live
# in the local directory
subdir-obj-y := $(foreach o,$(obj-y),$(if $(filter-out $(o),$(notdir $(o))),$(o)))

# $(obj-dirs) is a list of directories that contain object files
obj-dirs := $(dir $(multi-objs) $(subdir-obj-y))

# Replace multi-part objects by their individual parts, look at local dir only
real-objs-y := $(foreach m, $(filter-out $(subdir-obj-y), $(obj-y)), $(if $(strip $($(m:.o=-objs)) $($(m:.o=-y))),$($(m:.o=-objs)) $($(m:.o=-y)),$(m))) $(extra-y)
real-objs-m := $(foreach m, $(obj-m), $(if $(strip $($(m:.o=-objs)) $($(m:.o=-y))),$($(m:.o=-objs)) $($(m:.o=-y)),$(m)))

# These flags are needed for modversions and compiling, so we define them here
# already
# $(modname_flags) #defines KBUILD_MODNAME as the name of the module it will 
# end up in (or would, if it gets compiled in)
# Note: It's possible that one object gets potentially linked into more
#       than one module. In that case KBUILD_MODNAME will be set to foo_bar,
#       where foo and bar are the name of the modules.
name-fix = $(subst $(comma),_,$(subst -,_,$1))
basename_flags = -D"KBUILD_BASENAME=KBUILD_STR($(call name-fix,$(basetarget)))"
modname_flags  = $(if $(filter 1,$(words $(modname))),\
                 -D"KBUILD_MODNAME=KBUILD_STR($(call name-fix,$(modname)))")

_c_flags       = $(CFLAGS) $(EXTRA_CFLAGS) $(CFLAGS_$(basetarget).o)
_a_flags       = $(AFLAGS) $(EXTRA_AFLAGS) $(AFLAGS_$(basetarget).o)
_cpp_flags     = $(CPPFLAGS) $(EXTRA_CPPFLAGS) $(CPPFLAGS_$(@F))

# If building the kernel in a separate objtree expand all occurrences
# of -Idir to -I$(srctree)/dir except for absolute paths (starting with '/').

ifeq ($(BUILD_SRC),)
__c_flags	= $(_c_flags)
__a_flags	= $(_a_flags)
__cpp_flags     = $(_cpp_flags)
else

# -I$(obj) locates generated .h files
# $(call addtree,-I$(obj)) locates .h files in srctree, from generated .c files
#   and locates generated .h files
# FIXME: Replace both with specific CFLAGS* statements in the makefiles
__c_flags	= $(call addtree,-I$(obj)) $(call flags,_c_flags)
__a_flags	=                          $(call flags,_a_flags)
__cpp_flags     =                          $(call flags,_cpp_flags)
endif

c_flags        = -Wp,-MD,$(depfile) $(NOSTDINC_FLAGS) $(CPPFLAGS) \
		 $(__c_flags) $(modkern_cflags) \
		 -D"KBUILD_STR(s)=\#s" $(basename_flags) $(modname_flags)

a_flags        = -Wp,-MD,$(depfile) $(NOSTDINC_FLAGS) $(CPPFLAGS) \
		 $(__a_flags) $(modkern_aflags)

cpp_flags      = -Wp,-MD,$(depfile) $(NOSTDINC_FLAGS) $(__cpp_flags)

ld_flags       = $(LDFLAGS) $(EXTRA_LDFLAGS)

# Finds the multi-part object the current object will be linked into
modname-multi = $(sort $(foreach m,$(multi-used),\
		$(if $(filter $(subst $(obj)/,,$*.o), $($(m:.o=-objs)) $($(m:.o=-y))),$(m:.o=))))

# Shipped files
# ===========================================================================

quiet_cmd_shipped = SHIPPED $@
cmd_shipped = cat $< > $@

$(obj)/%: $(src)/%_shipped
	$(call cmd,shipped)

# Commands useful for building a boot image
# ===========================================================================
# 
#	Use as following:
#
#	target: source(s) FORCE
#		$(if_changed,ld/objcopy/gzip)
#
#	and add target to EXTRA_TARGETS so that we know we have to
#	read in the saved command line

# Linking
# ---------------------------------------------------------------------------

quiet_cmd_ld = LD      $@
cmd_ld = $(LD) $(LDFLAGS) $(EXTRA_LDFLAGS) $(LDFLAGS_$(@F)) \
	       $(filter-out FORCE,$^) -o $@ 

# Objcopy
# ---------------------------------------------------------------------------

quiet_cmd_objcopy = OBJCOPY $@
cmd_objcopy = $(OBJCOPY) $(OBJCOPYFLAGS) $(OBJCOPYFLAGS_$(@F)) $< $@

# Gzip
# ---------------------------------------------------------------------------

quiet_cmd_gzip = GZIP    $@
cmd_gzip = gzip -f -9 < $< > $@

# Link Library
# ---------------------------------------------------------------------------
quiet_cmd_link_l_target = AR      $@
cmd_link_l_target = rm -f $@; $(AR) $(EXTRA_ARFLAGS) rcs $@ $(lib-y)

$(lib-target): $(lib-y) FORCE
	$(call if_changed,link_l_target)


