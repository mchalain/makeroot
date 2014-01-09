cmd_tools/install/lib/getopt1.o := CFLAGS= gcc -Wp,-MD,tools/install/lib/.getopt1.d -Wall -Wstrict-prototypes -O2 -fomit-frame-pointer     -DHAVE_CONFIG_H -I/usr/include -Itools/install -Itools/install/lib -Itools/install/src -c -o tools/install/lib/getopt1.o tools/install/lib/getopt1.c

deps_tools/install/lib/getopt1.o := \
  tools/install/lib/getopt1.c \
    $(wildcard include/config/h.h) \
  tools/install/config.h \
  tools/install/lib/getopt.h \
  /usr/include/stdio.h \
  /usr/include/features.h \
  /usr/include/x86_64-linux-gnu/bits/predefs.h \
  /usr/include/x86_64-linux-gnu/sys/cdefs.h \
  /usr/include/x86_64-linux-gnu/bits/wordsize.h \
  /usr/include/x86_64-linux-gnu/gnu/stubs.h \
  /usr/include/x86_64-linux-gnu/gnu/stubs-64.h \
  /usr/lib/gcc/x86_64-linux-gnu/4.6/include/stddef.h \
  /usr/include/x86_64-linux-gnu/bits/types.h \
  /usr/include/x86_64-linux-gnu/bits/typesizes.h \
  /usr/include/libio.h \
  /usr/include/_G_config.h \
  /usr/include/wchar.h \
  /usr/lib/gcc/x86_64-linux-gnu/4.6/include/stdarg.h \
  /usr/include/x86_64-linux-gnu/bits/stdio_lim.h \
  /usr/include/x86_64-linux-gnu/bits/sys_errlist.h \
  /usr/include/x86_64-linux-gnu/bits/stdio.h \
  /usr/include/x86_64-linux-gnu/bits/stdio2.h \
  /usr/include/gnu-versions.h \

tools/install/lib/getopt1.o: $(deps_tools/install/lib/getopt1.o)

$(deps_tools/install/lib/getopt1.o):
