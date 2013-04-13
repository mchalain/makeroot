# Compile C sources (.c)
# ---------------------------------------------------------------------------

# Default is built-in, unless we know otherwise
modkern_cflags := $(CFLAGS_KERNEL)
quiet_modtag := $(empty)   $(empty)

$(real-objs-m)        : modkern_cflags := $(CFLAGS_MODULE)
$(real-objs-m:.o=.i)  : modkern_cflags := $(CFLAGS_MODULE)
$(real-objs-m:.o=.s)  : modkern_cflags := $(CFLAGS_MODULE)
$(real-objs-m:.o=.lst): modkern_cflags := $(CFLAGS_MODULE)

$(real-objs-m)        : quiet_modtag := [M]
$(real-objs-m:.o=.i)  : quiet_modtag := [M]
$(real-objs-m:.o=.s)  : quiet_modtag := [M]
$(real-objs-m:.o=.lst): quiet_modtag := [M]

$(obj-m)              : quiet_modtag := [M]

# Default for not multi-part modules
modname = $(basetarget)

$(multi-objs-m)         : modname = $(modname-multi)
$(multi-objs-m:.o=.i)   : modname = $(modname-multi)
$(multi-objs-m:.o=.s)   : modname = $(modname-multi)
$(multi-objs-m:.o=.lst) : modname = $(modname-multi)
$(multi-objs-y)         : modname = $(modname-multi)
$(multi-objs-y:.o=.i)   : modname = $(modname-multi)
$(multi-objs-y:.o=.s)   : modname = $(modname-multi)
$(multi-objs-y:.o=.lst) : modname = $(modname-multi)

quiet_cmd_cc_s_c = CC $(quiet_modtag)  $@
cmd_cc_s_c       = $(CC) $(c_flags) -fverbose-asm -S -o $@ $<

$(obj)/%.s: $(src)/%.c FORCE
	$(call if_changed_dep,cc_s_c)

quiet_cmd_cc_i_c = CPP $(quiet_modtag) $@
cmd_cc_i_c       = $(CPP) $(c_flags)   -o $@ $<

$(obj)/%.i: $(src)/%.c FORCE
	$(call if_changed_dep,cc_i_c)

quiet_cmd_cc_symtypes_c = SYM $(quiet_modtag) $@
cmd_cc_symtypes_c	   = \
		$(CPP) -D__GENKSYMS__ $(c_flags) $<			\
		| $(GENKSYMS) -T $@ >/dev/null;				\
		test -s $@ || rm -f $@

$(obj)/%.symtypes : $(src)/%.c FORCE
	$(call if_changed_dep,cc_symtypes_c)

# C (.c) files
# The C file is compiled and updated dependency information is generated.
# (See cmd_cc_o_c + relevant part of rule_cc_o_c)

quiet_cmd_cc_o_c = CC $(quiet_modtag)  $@

ifndef CONFIG_MODVERSIONS
cmd_cc_o_c = $(CC) $(c_flags) -c -o $@ $<

else
# When module versioning is enabled the following steps are executed:
# o compile a .tmp_<file>.o from <file>.c
# o if .tmp_<file>.o doesn't contain a __ksymtab version, i.e. does
#   not export symbols, we just rename .tmp_<file>.o to <file>.o and
#   are done.
# o otherwise, we calculate symbol versions using the good old
#   genksyms on the preprocessed source and postprocess them in a way
#   that they are usable as a linker script
# o generate <file>.o from .tmp_<file>.o using the linker to
#   replace the unresolved symbols __crc_exported_symbol with
#   the actual value of the checksum generated by genksyms

cmd_cc_o_c = $(CC) $(c_flags) -c -o $(@D)/.tmp_$(@F) $<
cmd_modversions =							\
	if $(OBJDUMP) -h $(@D)/.tmp_$(@F) | grep -q __ksymtab; then	\
		$(CPP) -D__GENKSYMS__ $(c_flags) $<			\
		| $(GENKSYMS) $(if $(KBUILD_SYMTYPES),			\
			      -T $(@D)/$(@F:.o=.symtypes)) -a $(ARCH)	\
		> $(@D)/.tmp_$(@F:.o=.ver);				\
									\
		$(LD) $(LDFLAGS) -r -o $@ $(@D)/.tmp_$(@F) 		\
			-T $(@D)/.tmp_$(@F:.o=.ver);			\
		rm -f $(@D)/.tmp_$(@F) $(@D)/.tmp_$(@F:.o=.ver);	\
	else								\
		mv -f $(@D)/.tmp_$(@F) $@;				\
	fi;
endif

define rule_cc_o_c
	$(call echo-cmd,checksrc) $(cmd_checksrc)			  \
	$(call echo-cmd,cc_o_c) $(cmd_cc_o_c);				  \
	$(cmd_modversions)						  \
	scripts/basic/fixdep $(depfile) $@ '$(call make-cmd,cc_o_c)' >    \
						      $(dot-target).tmp;  \
	rm -f $(depfile);						  \
	mv -f $(dot-target).tmp $(dot-target).cmd
endef

# Built-in and composite module parts
$(obj)/%.o: $(src)/%.c FORCE
	$(call cmd,force_checksrc)
	$(call if_changed_rule,cc_o_c)

# Single-part modules are special since we need to mark them in $(MODVERDIR)

$(single-used-m): $(obj)/%.o: $(src)/%.c FORCE
	$(call cmd,force_checksrc)
	$(call if_changed_rule,cc_o_c)
	@{ echo $(@:.o=.ko); echo $@; } > $(MODVERDIR)/$(@F:.o=.mod)

quiet_cmd_cc_lst_c = MKLST   $@
      cmd_cc_lst_c = $(CC) $(c_flags) -g -c -o $*.o $< && \
		     $(CONFIG_SHELL) $(srctree)/scripts/makelst $*.o \
				     System.map $(OBJDUMP) > $@

$(obj)/%.lst: $(src)/%.c FORCE
	$(call if_changed_dep,cc_lst_c)

# Compile assembler sources (.S)
# ---------------------------------------------------------------------------

modkern_aflags := $(AFLAGS_KERNEL)

$(real-objs-m)      : modkern_aflags := $(AFLAGS_MODULE)
$(real-objs-m:.o=.s): modkern_aflags := $(AFLAGS_MODULE)

quiet_cmd_as_s_S = CPP $(quiet_modtag) $@
cmd_as_s_S       = $(CPP) $(a_flags)   -o $@ $< 

$(obj)/%.s: $(src)/%.S FORCE
	$(call if_changed_dep,as_s_S)

quiet_cmd_as_o_S = AS $(quiet_modtag)  $@
cmd_as_o_S       = $(CC) $(a_flags) -c -o $@ $<

$(obj)/%.o: $(src)/%.S FORCE
	$(call if_changed_dep,as_o_S)

targets += $(real-objs-y) $(real-objs-m) $(lib-y)
targets += $(extra-y) $(MAKECMDGOALS) $(always)

# Linker scripts preprocessor (.lds.S -> .lds)
# ---------------------------------------------------------------------------
quiet_cmd_cpp_lds_S = LDS     $@
      cmd_cpp_lds_S = $(CPP) $(cpp_flags) -D__ASSEMBLY__ -o $@ $<

$(obj)/%.lds: $(src)/%.lds.S FORCE
	$(call if_changed_dep,cpp_lds_S)

#
# Rule to link composite objects
#
#  Composite objects are specified in kbuild makefile as follows:
#    <composite-object>-objs := <list of .o files>
#  or
#    <composite-object>-y    := <list of .o files>
link_multi_deps =                     \
$(filter $(addprefix $(obj)/,         \
$($(subst $(obj)/,,$(@:.o=-objs)))    \
$($(subst $(obj)/,,$(@:.o=-y)))), $^)
 
quiet_cmd_link_multi-y = LD      $@
cmd_link_multi-y = $(LD) $(ld_flags) -r -o $@ $(link_multi_deps)

quiet_cmd_link_multi-m = LD [M]  $@
cmd_link_multi-m = $(cmd_link_multi-y)

#
# Rule to link the single target
#
quiet_cmd_link_o_target = LD      $@
# If the list of objects to link is empty, just create an empty built-in.o
cmd_link_o_target = $(if $(strip $(obj-y)),\
		      $(LD) $(ld_flags) -r -o $@ $(filter $(obj-y), $^),\
		      rm -f $@; $(AR) rcs $@)

$(builtin-target): $(obj-y) FORCE
	$(call if_changed,link_o_target)

# We would rather have a list of rules like
# 	foo.o: $(foo-objs)
# but that's not so easy, so we rather make all composite objects depend
# on the set of all their parts
$(multi-used-y) : %.o: $(multi-objs-y) FORCE
	$(call if_changed,link_multi-y)

$(multi-used-m) : %.o: $(multi-objs-m) FORCE
	$(call if_changed,link_multi-m)
	@{ echo $(@:.o=.ko); echo $(link_multi_deps); } > $(MODVERDIR)/$(@F:.o=.mod)

