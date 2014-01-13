# ==========================================================================
# Building binaries on the host system
# Binaries are used during the compilation of the kernel, for example
# to preprocess a data file.
#
# Both C and C++ is supported, but preferred language is C for such utilities.
#
# Samle syntax (see Documentation/kbuild/makefile.txt for reference)
# hostprogs-y := bin2hex
# Will compile bin2hex.c and create an executable named bin2hex
#
# hostprogs-y    := lxdialog
# lxdialog-objs := checklist.o lxdialog.o
# Will compile lxdialog.c and checklist.c, and then link the executable
# lxdialog, based on checklist.o and lxdialog.o
#
# hostprogs-y      := qconf
# qconf-cxxobjs   := qconf.o
# qconf-objs      := menu.o
# Will compile qconf as a C++ program, and menu as a C program.
# They are linked as C++ code to the executable qconf

# hostprogs-y := conf
# conf-objs  := conf.o libkconfig.so
# libkconfig-objs := expr.o type.o
# Will create a shared library named libkconfig.so that consist of
# expr.o and type.o (they are both compiled as C code and the object file
# are made as position independent code).
# conf.c is compiled as a c program, and conf.o is linked together with
# libkconfig.so as the executable conf.
# Note: Shared libraries consisting of C++ files are not supported

__hostprogs := $(sort $(hostprogs-y) $(hostprogs-m))

# C code
# Executables compiled from a single .c file
host-csingle	:= $(foreach m,$(__hostprogs),$(if $($(m)-cxxobjs),,$(if $($(m)-objs),,$(m))))
sdk-csingle		:= $(foreach m,$(host-csingle),$(if $($(m)-install),$(m)))
host-csingle		:= $(foreach m,$(host-csingle),$(if $($(m)-install),,$(m)))

# C executables linked based on several .o files
host-cmulti	:= $(foreach m,$(__hostprogs),$(if $($(m)-cxxobjs),,$(if $($(m)-objs),$(m)$(shell rm -f $(addprefix $(hostobj)/,$(filter-out -l%,$($(m)-objs)))))))
sdk-cmulti		:= $(foreach m,$(host-cmulti),$(if $($(m)-install),$(m)))
host-cmulti		:= $(foreach m,$(host-cmulti),$(if $($(m)-install),,$(m)))

# Object (.o) files compiled from .c files
host-cobjs	:= $(sort $(foreach m,$(__hostprogs),$($(m)-objs)))

# C++ code
# C++ executables compiled from at least on .cc file
# and zero or more .c files
host-cxxmulti	:= $(foreach m,$(__hostprogs),$(if $($(m)-cxxobjs),$(m)$(shell rm -f $(addprefix $(hostobj)/,$(filter-out -l%,$($(m)-objs))))))
sdk-cxxmulti	:= $(foreach m,$(host-cxxmulti),$(if $($(m)-install),$(m)))
host-cxxmulti	:= $(foreach m,$(host-cxxmulti),$(if $($(m)-install),,$(m)))

# C++ Object (.o) files compiled from .cc files
host-cxxobjs	:= $(sort $(foreach m,$(host-cxxmulti),$($(m)-cxxobjs)))

# Shared libaries (only .c supported)
# Shared libraries (.so) - all .so files referenced in "xxx-objs"
host-cshlib	:= $(sort $(filter %.so, $(host-cobjs)))
sdk-cshlib	:= $(foreach m,$(host-cshlib),$(if $($(m)-install),$(m)))
host-cshlib	:= $(foreach m,$(host-cshlib),$(if $($(m)-install),,$(m)))

# Static libaries (only .c supported)
# Static libraries (.a) - all .a files referenced in "xxx-objs"
host-cstlib	:= $(sort $(filter %.a, $(host-cobjs)))

# Remove .so files from "xxx-objs"
host-cobjs	:= $(filter-out -l%,$(filter-out %.so,$(host-cobjs)))

#Object (.o) files used by the shared libaries
host-cshobjs	:= $(sort $(foreach m,$(host-cshlib),$($(m:.so=-objs))))

#Object (.o) files used by the static libaries
host-cstobjs	:= $(sort $(foreach m,$(host-cshlib),$($(m:.a=-objs))))

# output directory for programs/.o files
# hostprogs-y := tools/build may have been specified. Retreive directory
host-objdirs := $(foreach f,$(__hostprogs), $(if $(dir $(f)),$(dir $(f))))
# directory of .o files from prog-objs notation
host-objdirs += $(foreach f,$(host-cmulti),                  \
		    $(foreach m,$($(f)-objs),                \
			$(if $(dir $(m)),$(dir $(m)))))
# directory of .o files from prog-cxxobjs notation
host-objdirs += $(foreach f,$(host-cxxmulti),                  \
		    $(foreach m,$($(f)-cxxobjs),                \
			$(if $(dir $(m)),$(dir $(m)))))

host-objdirs := $(strip $(sort $(filter-out ./,$(host-objdirs))))

host-csingle	:= $(addprefix $(obj)/,$(notdir $(host-csingle)))
host-csingle	+= $(addprefix $(hostbin)/,$(notdir $(sdk-csingle)))
host-cmulti	:= $(addprefix $(obj)/,$(notdir $(host-cmulti)))
host-cmulti	+= $(addprefix $(hostbin)/,$(notdir $(sdk-cmulti)))
host-cobjs		:= $(addprefix $(hostobj)/,$(host-cobjs))
host-cxxmulti	:= $(addprefix $(obj)/,$(notdir $(host-cxxmulti)))
host-cxxmulti	+= $(addprefix $(hostbin)/,$(notdir $(sdk-cxxmulti)))
host-cxxobjs	:= $(addprefix $(hostobj)/,$(host-cxxobjs))
host-cshlib	:= $(addprefix $(obj)/,$(notdir $(host-cshlib)))
host-cshlib	+= $(addprefix $(hostlib)/,$(notdir $(sdk-cshlib)))
host-cshobjs	:= $(addprefix $(hostobj)/,$(host-cshobjs))
host-cstobjs	:= $(addprefix $(hostobj)/,$(host-cstobjs))
host-srcdirs    := $(addprefix $(src)/,$(host-objdirs))
host-objdirs    := $(addprefix $(hostobj)/,$(host-objdirs))

obj-dirs += $(host-objdirs)

#####
# Handle options to gcc. Support building with separate output directory

_hostc_flags   = $(HOSTCFLAGS)   $(HOST_EXTRACFLAGS)   \
		 $(HOSTCFLAGS_$(basetarget).o) $(sort $(foreach m,$(__hostprogs),$($(m)-cflags)))
_hostcxx_flags = $(HOSTCXXFLAGS) $(HOST_EXTRACXXFLAGS) \
		 $(HOSTCXXFLAGS_$(basetarget).o) $(sort $(foreach m,$(__hostprogs),$($(m)-cflags)))

ifeq ($(KBUILD_SRC),)
__hostc_flags	= $(_hostc_flags)
__hostcxx_flags	= $(_hostcxx_flags)
else
__hostc_flags	= -I$(obj) $(call flags,_hostc_flags)
__hostcxx_flags	= -I$(obj) $(call flags,_hostcxx_flags)
endif

hostc_flags    = -Wp,-MD,$(depfile) $(__hostc_flags)
hostcxx_flags  = -Wp,-MD,$(depfile) $(__hostcxx_flags)

#####
# Compile programs on the host
quiet_cmd_hostcopy = HOSTCOPY $@
      cmd_hostcopy = cp $< $@

$(host-objdirs) $(hostbin) $(hostlib):
	mkdir -p $@

# Create executable from a single .c file
# host-csingle -> Executable
quiet_cmd_host-csingle 	= HOSTCC $@
      cmd_host-csingle	= CFLAGS= LDFLAGS=  \
		$(HOSTCC) $(hostc_flags) -o $@ $< \
		-L$(hostlib) $(HOST_LOADLIBES) $(HOSTLOADLIBES_$(@F)) $(host-shlib)
$(host-csingle): $(obj)/%: $(src)/%.c
	$(call if_changed_dep,host-csingle)
$(host-csingle): $(hostbin)/%: $(src)/%.c
	$(call if_changed_dep,host-csingle)

# Link an executable based on list of .o files, all plain c
# host-cmulti -> executable
quiet_cmd_host-cmulti	= HOSTLD  $@
      cmd_host-cmulti	= LDFLAGS=  \
		$(HOSTCC) $(HOSTLDFLAGS) -o $@ \
		$(addprefix $(hostobj)/,$(filter %.o,$($(@F)-objs))) \
		-L$(hostlib) $(HOST_LOADLIBES) $(HOSTLOADLIBES_$(@F)) $(filter -l%,$($(@F)-objs))
$(host-cmulti): $(hostbin) $(host-cobjs) $(host-cshlib)
	$(call if_changed,host-cmulti)


# Create .o file from a multi .c file
# host-cobjs -> .o
quiet_cmd_host-cobjs	= HOSTCC  $@
      cmd_host-cobjs	= CFLAGS= \
		$(HOSTCC) $(hostc_flags) -c -o $@ $<
$(host-cobjs): $(host-objdirs)
$(host-cobjs): $(hostobj)/%.o: $(src)/%.c
	$(call if_changed_dep,host-cobjs)

# Link an executable based on list of .o files, a mixture of .c and .cc
# host-cxxmulti -> executable
quiet_cmd_host-cxxmulti	= HOSTLD  $@
      cmd_host-cxxmulti	= $(HOSTCXX) $(HOSTLDFLAGS) -o $@ \
			  $(foreach o,objs cxxobjs, $(addprefix $(hostobj)/,$(filter %.o,$($(@F)-$(o))))) \
			  -L$(hostlib) $(HOST_LOADLIBES) $(HOSTLOADLIBES_$(@F)) $(foreach o,objs cxxobjs, $(filter -l%, $($(@F)-$(o))))
$(host-cxxmulti): $(hostbin) $(host-cobjs) $(host-cxxobjs) $(host-cshlib)
	$(call if_changed,host-cxxmulti)

# Create .o file from a single .cc (C++) file
quiet_cmd_host-cxxobjs	= HOSTCXX $@
      cmd_host-cxxobjs	= $(HOSTCXX) $(hostcxx_flags) -c -o $@ $<
$(host-cxxobjs): $(host-objdirs)
$(host-cxxobjs): $(hostobj)/%.o: $(src)/%.cxx
	$(call if_changed_dep,host-cxxobjs)
#$(host-cxxobjs): $(hostobj)/%.o: $(src)/%.cc
#	$(call if_changed_dep,host-cxxobjs)
#$(host-cxxobjs): $(hostobj)/%.o: $(src)/%.cpp
#	$(call if_changed_dep,host-cxxobjs)

# Compile .c file, create position independent .o file
# host-cshobjs -> .o
quiet_cmd_host-cshobjs	= HOSTCC  -fPIC $@
      cmd_host-cshobjs	= $(HOSTCC) $(hostc_flags) -fPIC -c -o $@ $<
$(host-cshobjs): $(host-objdirs)
$(host-cshobjs): $(hostobj)/%.o: $(src)/%.c
	$(call if_changed_dep,host-cshobjs)

# Link a shared library, based on position independent .o files
# *.o -> .so shared library (host-cshlib)
quiet_cmd_host-cshlib	= HOSTLD -shared $@
      cmd_host-cshlib	= $(HOSTCC) $(HOSTLDFLAGS) -shared -o $@ \
			  $(addprefix $(hostobj)/,$(filter %.o, $($(@F:.so=-objs)))) \
			  $(HOST_LOADLIBES) $(HOSTLOADLIBES_$(@F)) $(filter -l%, $($(@F:.so=-objs)))
$(hosto-cshlib): $(host-cshobjs)
	$(call if_changed,host-cshlib)

targets += $(host-csingle)  $(host-cmulti) $(host-cobjs)\
	   $(host-cxxmulti) $(host-cxxobjs) $(host-cshlib) $(host-cshobjs) 

.y.c:
	$(YACC) $(AM_YFLAGS) $(YFLAGS) $< && mv y.tab.c $*.c
	if test -f y.tab.h; then \
	if cmp -s y.tab.h $*.h; then rm -f y.tab.h; else mv y.tab.h $*.h; fi; \
	else :; fi
