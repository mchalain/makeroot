hostprogs-y+=rpcgen
rpcgen-install:=rpcgen

rpcgen_VERSION = 4.0

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
rpc_util.c
rpcgen-objs = $(rpcgen_SOURCES:%.c=%.o)

rpcgen_LIBS = 

AM_CFLAGS = $(CFLAGS)

INCLUDES = -I.

SUBDIRS = doc

VPATH += $(resdir)
MAJOR = $(shell echo $(rpcgen_VERSION) | sed -e "s/\..*$$//")
MINOR = $(shell echo $(rpcgen_VERSION) | sed -e "s/^[^\.]*\.0*\([0-9]\+\).*$$/\1/") 
rpcgen_LDFLAGS = $(LDFLAGS) -Wl,--major-image-version=$(MAJOR) -Wl,--minor-image-version=$(MINOR)

SUFFIXES = .c .o
