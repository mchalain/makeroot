cmd_tools/install/lib/human.o := CFLAGS= gcc -Wp,-MD,tools/install/lib/.human.d -Wall -Wstrict-prototypes -O2 -fomit-frame-pointer     -DHAVE_CONFIG_H -I/usr/include -Itools/install -Itools/install/lib -Itools/install/src -c -o tools/install/lib/human.o tools/install/lib/human.c

deps_tools/install/lib/human.o := \
  tools/install/lib/human.c \
    $(wildcard include/config/h.h) \
  tools/install/config.h \
  /usr/include/inttypes.h \
  /usr/include/features.h \
  /usr/include/x86_64-linux-gnu/bits/predefs.h \
  /usr/include/x86_64-linux-gnu/sys/cdefs.h \
  /usr/include/x86_64-linux-gnu/bits/wordsize.h \
  /usr/include/x86_64-linux-gnu/gnu/stubs.h \
  /usr/include/x86_64-linux-gnu/gnu/stubs-64.h \
  /usr/lib/gcc/x86_64-linux-gnu/4.6/include/stdint.h \
  /usr/include/stdint.h \
  /usr/include/x86_64-linux-gnu/bits/wchar.h \
  /usr/include/x86_64-linux-gnu/sys/types.h \
  /usr/include/x86_64-linux-gnu/bits/types.h \
  /usr/include/x86_64-linux-gnu/bits/typesizes.h \
  /usr/include/time.h \
  /usr/lib/gcc/x86_64-linux-gnu/4.6/include/stddef.h \
  /usr/include/endian.h \
  /usr/include/x86_64-linux-gnu/bits/endian.h \
  /usr/include/x86_64-linux-gnu/bits/byteswap.h \
  /usr/include/x86_64-linux-gnu/sys/select.h \
  /usr/include/x86_64-linux-gnu/bits/select.h \
  /usr/include/x86_64-linux-gnu/bits/sigset.h \
  /usr/include/x86_64-linux-gnu/bits/time.h \
  /usr/include/x86_64-linux-gnu/bits/select2.h \
  /usr/include/x86_64-linux-gnu/sys/sysmacros.h \
  /usr/include/x86_64-linux-gnu/bits/pthreadtypes.h \
  /usr/include/stdio.h \
  /usr/include/libio.h \
  /usr/include/_G_config.h \
  /usr/include/wchar.h \
  /usr/lib/gcc/x86_64-linux-gnu/4.6/include/stdarg.h \
  /usr/include/x86_64-linux-gnu/bits/stdio_lim.h \
  /usr/include/x86_64-linux-gnu/bits/sys_errlist.h \
  /usr/include/x86_64-linux-gnu/bits/stdio.h \
  /usr/include/x86_64-linux-gnu/bits/stdio2.h \
  /usr/lib/gcc/x86_64-linux-gnu/4.6/include-fixed/limits.h \
  /usr/lib/gcc/x86_64-linux-gnu/4.6/include-fixed/syslimits.h \
  /usr/include/limits.h \
  /usr/include/x86_64-linux-gnu/bits/posix1_lim.h \
  /usr/include/x86_64-linux-gnu/bits/local_lim.h \
  /usr/include/linux/limits.h \
  /usr/include/x86_64-linux-gnu/bits/posix2_lim.h \
  /usr/include/stdlib.h \
  /usr/include/x86_64-linux-gnu/bits/waitflags.h \
  /usr/include/x86_64-linux-gnu/bits/waitstatus.h \
  /usr/include/alloca.h \
  /usr/include/x86_64-linux-gnu/bits/stdlib.h \
  /usr/include/libintl.h \
  /usr/include/locale.h \
  /usr/include/x86_64-linux-gnu/bits/locale.h \
  /usr/include/xlocale.h \
  tools/install/lib/argmatch.h \
  tools/install/lib/error.h \
  tools/install/lib/xstrtoul.h \
  tools/install/lib/xstrtol.h \
  tools/install/lib/human.h \

tools/install/lib/human.o: $(deps_tools/install/lib/human.o)

$(deps_tools/install/lib/human.o):