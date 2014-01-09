cmd_tools/install/lib/stripslash.o := CFLAGS= gcc -Wp,-MD,tools/install/lib/.stripslash.d -Wall -Wstrict-prototypes -O2 -fomit-frame-pointer     -DHAVE_CONFIG_H -I/usr/include -Itools/install -Itools/install/lib -Itools/install/src -c -o tools/install/lib/stripslash.o tools/install/lib/stripslash.c

deps_tools/install/lib/stripslash.o := \
  tools/install/lib/stripslash.c \
    $(wildcard include/config/h.h) \
  tools/install/config.h \
  /usr/include/string.h \
  /usr/include/features.h \
  /usr/include/x86_64-linux-gnu/bits/predefs.h \
  /usr/include/x86_64-linux-gnu/sys/cdefs.h \
  /usr/include/x86_64-linux-gnu/bits/wordsize.h \
  /usr/include/x86_64-linux-gnu/gnu/stubs.h \
  /usr/include/x86_64-linux-gnu/gnu/stubs-64.h \
  /usr/lib/gcc/x86_64-linux-gnu/4.6/include/stddef.h \
  /usr/include/xlocale.h \
  /usr/include/x86_64-linux-gnu/bits/string.h \
  /usr/include/x86_64-linux-gnu/bits/string2.h \
  /usr/include/endian.h \
  /usr/include/x86_64-linux-gnu/bits/endian.h \
  /usr/include/x86_64-linux-gnu/bits/byteswap.h \
  /usr/include/x86_64-linux-gnu/bits/types.h \
  /usr/include/x86_64-linux-gnu/bits/typesizes.h \
  /usr/include/stdlib.h \
  /usr/include/x86_64-linux-gnu/bits/string3.h \

tools/install/lib/stripslash.o: $(deps_tools/install/lib/stripslash.o)

$(deps_tools/install/lib/stripslash.o):
