MAKE=make
MKDIR=mkdir -p
RM=rm -rf
LN=ln
INSTALL=install
AWK		= awk
# SHELL used by kbuild
CONFIG_SHELL := $(shell if [ -x "$$BASH" ]; then echo $$BASH; \
	  else if [ -x /bin/bash ]; then echo /bin/bash; \
	  else echo sh; fi ; fi)

export MAKE MKDIR RM LN INSTALL AWK CONFIG_SHELL

HOSTCC       = gcc
HOSTCXX      = g++
HOSTCFLAGS   = -Wall -Wstrict-prototypes -O2 -fomit-frame-pointer
HOSTCXXFLAGS = -O2
export HOSTCC HOSTCXX HOSTCFLAGS HOSTCXXFLAGS

# We need some generic definitions.
# Make variables (CC, etc...)

export CROSS_COMPILE

AS		= $(CROSS_COMPILE)as
LD		= $(CROSS_COMPILE)ld
CC		= $(CROSS_COMPILE)gcc
CPP		= $(CC) -E
AR		= $(CROSS_COMPILE)ar
RANLIB		= $(CROSS_COMPILE)ranlib
NM		= $(CROSS_COMPILE)nm
STRIP		= $(CROSS_COMPILE)strip
OBJCOPY		= $(CROSS_COMPILE)objcopy
OBJDUMP		= $(CROSS_COMPILE)objdump

export AS LD CC CPP AR NM STRIP OBJCOPY OBJDUMP

