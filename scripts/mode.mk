# Beautify output
# ---------------------------------------------------------------------------
#
# Normally, we echo the whole command before executing it. By making
# that echo $($(quiet)$(cmd)), we now have the possibility to set
# $(quiet) to choose other forms of output instead, e.g.
#
#         quiet_cmd_cc_o_c = Compiling $(RELDIR)/$@
#         cmd_cc_o_c       = $(CC) $(c_flags) -c -o $@ $<
#
# If $(quiet) is empty, the whole command will be printed.
# If it is set to "quiet_", only the short version will be printed. 
# If it is set to "silent_", nothing will be printed at all, since
# the variable $(silent_cmd_cc_o_c) doesn't exist.
#
# A simple variant is to prefix commands with $(Q) - that's useful
# for commands that shall be hidden in non-verbose mode.
#
#	$(Q)ln $@ :<
#
# If KBUILD_VERBOSE equals 0 then the above command will be hidden.
# If KBUILD_VERBOSE equals 1 then the above command is displayed.

# To put more focus on warnings, be less verbose as default
# Use 'make V=1' to see the full commands

ifdef V
  ifeq ("$(origin V)", "command line")
    BUILD_VERBOSE = $(V)
  endif
endif
ifndef BUILD_VERBOSE
  BUILD_VERBOSE = 0
endif

# Call a source code checker (by default, "sparse") as part of the
# C compilation.
#
# Use 'make C=1' to enable checking of only re-compiled files.
# Use 'make C=2' to enable checking of *all* source files, regardless
# of whether they are re-compiled or not.
#
# See the file "Documentation/sparse.txt" for more details, including
# where to get the "sparse" utility.

ifdef C
	ifeq ("$(origin C)", "command line")
		BUILD_CHECKSRC = $(C)
	endif
endif
ifndef KBUILD_CHECKSRC
	BUILD_CHECKSRC = 0
endif

ifeq ($(BUILD_VERBOSE),1)
	quiet =
	Q =
else
	quiet=quiet_
	Q = @
endif

# If the user is running make -s (silent mode), suppress echoing of
# commands

ifneq ($(findstring -s,$(MAKEFLAGS)),)
	quiet=silent_
endif

ifdef D
  ifeq ("$(origin D)", "command line")
	ifeq ( "$(D)", "y")
		BUILD_DOWNLOAD_PATH = ~/Download
	else
		BUILD_DOWNLOAD_PATH = $(D)
	endif
	BUILD_DOWNLOAD_KEEP_COPY = y
  endif
endif
ifndef BUILD_DOWNLOAD_PATH
	BUILD_DOWNLOAD_PATH = ~/Download
	BUILD_DOWNLOAD_KEEP_COPY = n
endif
export quiet Q BUILD_VERBOSE

