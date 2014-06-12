bin_PROGRAMS = rpcgen

rpcgen_SOURCES = \
rpc_clntout.c \
rpc_cout.c \
rpc_hout.c \
rpc_main.c \
rpc_parse.c \
rpc_sample.c \
rpc_scan.c \
rpc_svcout.c \
rpc_tblout.c \
rpc_util.c \
rpcgen-res.rc

rpcgen_LIBS = @LIBS@ 

AM_CFLAGS = $(CFLAGS)

INCLUDES = -I. -I$(top_srcdir)

SUBDIRS = doc

resdir = @top_builddir@/resource

VPATH += $(resdir)
MAJOR = $(shell echo @VERSION@ | sed -e "s/\..*$$//")
MINOR = $(shell echo @VERSION@ | sed -e "s/^[^\.]*\.0*\([0-9]\+\).*$$/\1/") 
AM_LDFLAGS = $(LDFLAGS) -Wl,--major-image-version=$(MAJOR) -Wl,--minor-image-version=$(MINOR)

SUFFIXES = .c .o .rc .exe

# Rule to make compiled resource (Windows)
.rc.o:
	windres --include-dir $(resdir) -i $< -o $@
