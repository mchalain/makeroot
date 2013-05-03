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
host-csingle	:= $(foreach m,$(__hostprogs),$(if $($(m)-objs),,$(m)))

# C executables linked based on several .o files
host-cmulti	:= $(foreach m,$(__hostprogs),\
		   $(if $($(m)-cxxobjs),,$(if $($(m)-objs),$(m))))

# Object (.o) files compiled from .c files
host-cobjs	:= $(sort $(foreach m,$(__hostprogs),$($(m)-objs)))

# C++ code
# C++ executables compiled from at least on .cc file
# and zero or more .c files
host-cxxmulti	:= $(foreach m,$(__hostprogs),$(if $($(m)-cxxobjs),$(m)))

# C++ Object (.o) files compiled from .cc files
host-cxxobjs	:= $(sort $(foreach m,$(host-cxxmulti),$($(m)-cxxobjs)))

# Shared libaries (only .c supported)
# Shared libraries (.so) - all .so files referenced in "xxx-objs"
host-cshlib	:= $(sort $(filter %.so, $(host-cobjs)))
host-shlib		:= $(sort $(filter -l%, $(host-cobjs)))
# Remove .so files from "xxx-objs"
host-cobjs	:= $(filter-out -l%,$(filter-out %.so,$(host-cobjs)))

#Object (.o) files used by the shared libaries
host-cshobjs	:= $(sort $(foreach m,$(host-cshlib),$($(m:.so=-objs))))

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

hosto-csingle	:= $(addprefix $(obj)/,$(host-csingle))
host-csingle	:= $(addprefix $(hostobjtree)/bin/,$(host-csingle))
hosto-cmulti	:= $(addprefix $(obj)/,$(host-cmulti))
host-cmulti	:= $(addprefix $(hostobjtree)/bin/,$(host-cmulti))
host-cobjs		:= $(addprefix $(obj)/,$(host-cobjs))
hosto-cxxmulti	:= $(addprefix $(obj)/,$(host-cxxmulti))
host-cxxmulti	:= $(addprefix $(hostobjtree)/bin/,$(host-cxxmulti))
host-cxxobjs	:= $(addprefix $(obj)/,$(host-cxxobjs))
hosto-cshlib	:= $(addprefix $(obj)/,$(host-cshlib))
host-cshlib	:= $(addprefix $(hostobjtree)/lib/,$(host-cshlib))
host-cshobjs	:= $(addprefix $(obj)/,$(host-cshobjs))
host-objdirs    := $(addprefix $(obj)/,$(host-objdirs))

obj-dirs += $(host-objdirs)

#####
# Handle options to gcc. Support building with separate output directory

_hostc_flags   = $(HOSTCFLAGS)   $(HOST_EXTRACFLAGS)   \
		 $(HOSTCFLAGS_$(basetarget).o)
_hostcxx_flags = $(HOSTCXXFLAGS) $(HOST_EXTRACXXFLAGS) \
		 $(HOSTCXXFLAGS_$(basetarget).o)

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

# Create executable from a single .c file
# host-csingle -> Executable
quiet_cmd_host-csingle 	= HOSTCC $@
      cmd_host-csingle	= $(eval override CFLAGS= )$(eval override LDFLAGS= )$(HOSTCC) $(hostc_flags) -o $@ $< \
		-L$(hostobjtree)/lib $(HOST_LOADLIBES) $(HOSTLOADLIBES_$(@F)) $(host-shlib)
$(hosto-csingle): $(obj)/%: $(src)/%.c
	$(call if_changed_dep,host-csingle)

$(host-csingle): $(hosto-csingle)
	$(call if_changed,hostcopy)

# Link an executable based on list of .o files, all plain c
# host-cmulti -> executable
quiet_cmd_host-cmulti	= HOSTLD  $@
      cmd_host-cmulti	= $(eval override LDFLAGS= )$(HOSTCC) $(HOSTLDFLAGS) -o $@ \
			  $(addprefix $(obj)/,$(filter-out -l%, $(filter-out %.so,$($(@F)-objs)))) \
			  -L$(hostobjtree)/lib $(HOST_LOADLIBES) $(HOSTLOADLIBES_$(@F)) $(host-shlib)
$(hosto-cmulti): $(host-cobjs) $(host-cshlib)
	$(call if_changed,host-cmulti)

$(host-cmulti): $(hosto-cmulti)
	$(call if_changed,hostcopy)

# Create .o file from a single .c file
# host-cobjs -> .o
quiet_cmd_host-cobjs	= HOSTCC  $@
      cmd_host-cobjs	= $(eval override CFLAGS= )$(HOSTCC) $(hostc_flags) -c -o $@ $<
$(host-cobjs): $(obj)/%.o: $(src)/%.c
	$(call if_changed_dep,host-cobjs)

# Link an executable based on list of .o files, a mixture of .c and .cc
# host-cxxmulti -> executable
quiet_cmd_host-cxxmulti	= HOSTLD  $@
      cmd_host-cxxmulti	= $(HOSTCXX) $(HOSTLDFLAGS) -o $@ \
			  $(foreach o,objs cxxobjs, $(addprefix $(obj)/,$(filter-out -l%, $(filter-out %.so,$($(@F)-$(o)))))) \
			  -L$(hostobjtree)/lib $(HOST_LOADLIBES) $(HOSTLOADLIBES_$(@F)) $(host-shlib)
$(hosto-cxxmulti): $(host-cobjs) $(host-cxxobjs) $(host-cshlib)
	$(call if_changed,host-cxxmulti)

$(host-cxxmulti): $(hosto-cxxmulti)
	$(call if_changed,hostcopy)

# Create .o file from a single .cc (C++) file
quiet_cmd_host-cxxobjs	= HOSTCXX $@
      cmd_host-cxxobjs	= $(HOSTCXX) $(hostcxx_flags) -c -o $@ $<
$(host-cxxobjs): $(obj)/%.o: $(src)/%.cc
	$(call if_changed_dep,host-cxxobjs)
$(host-cxxobjs): $(obj)/%.o: $(src)/%.cpp
	$(call if_changed_dep,host-cxxobjs)

# Compile .c file, create position independent .o file
# host-cshobjs -> .o
quiet_cmd_host-cshobjs	= HOSTCC  -fPIC $@
      cmd_host-cshobjs	= $(HOSTCC) $(hostc_flags) -fPIC -c -o $@ $<
$(host-cshobjs): $(obj)/%.o: $(src)/%.c
	$(call if_changed_dep,host-cshobjs)

# Link a shared library, based on position independent .o files
# *.o -> .so shared library (host-cshlib)
quiet_cmd_host-cshlib	= HOSTLLD -shared $@
      cmd_host-cshlib	= $(HOSTCC) $(HOSTLDFLAGS) -shared -o $@ \
			  $(addprefix $(obj)/,$(filter-out -l%, $($(@F:.so=-objs)))) \
			  $(HOST_LOADLIBES) $(HOSTLOADLIBES_$(@F)) $(host-shlib)
$(hosto-cshlib): $(host-cshobjs)
	$(call if_changed,host-cshlib)

$(host-cshlib): $(hosto-cshlib)
	$(call if_changed,hostcopy)

targets += $(host-csingle)  $(host-cmulti) $(host-cobjs)\
	   $(host-cxxmulti) $(host-cxxobjs) $(host-cshlib) $(host-cshobjs) 
