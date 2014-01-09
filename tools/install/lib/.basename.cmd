cmd_tools/install/lib/basename.o := CFLAGS= gcc -Wp,-MD,tools/install/lib/.basename.d -Wall -Wstrict-prototypes -O2 -fomit-frame-pointer     -DHAVE_CONFIG_H -I/usr/include -Itools/install -Itools/install/lib -Itools/install/src -c -o tools/install/lib/basename.o tools/install/lib/basename.c

deps_tools/install/lib/basename.o := \
  tools/install/lib/basename.c \
    $(wildcard include/config/h.h) \
  tools/install/config.h \

tools/install/lib/basename.o: $(deps_tools/install/lib/basename.o)

$(deps_tools/install/lib/basename.o):
