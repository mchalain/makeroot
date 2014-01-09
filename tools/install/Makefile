subdir-y+=$(src)/lib

libfu-objs:=getdate.o posixtm.o getopt.o getopt1.o \
addext.o argmatch.o backupfile.o basename.o \
closeout.o dirname.o exclude.o filemode.o \
full-write.o human.o idcache.o \
isdir.o long-options.o makepath.o modechange.o hash.o path-concat.o \
quotearg.o safe-read.o save-cwd.o savedir.o stripslash.o userspec.o xgetcwd.o \
xmalloc.o xstrdup.o xstrtol.o xstrtoul.o yesno.o

hostprogs-y+=install
install-objs:=src/install.o src/copy.o src/cp-hash.o
libfu-objs := $(addprefix lib/,$(notdir $(libfu-objs)))
install-objs+=$(libfu-objs)
install-install:=install
install-cflags:=-I$(src) -I/usr/include -I$(src)/lib -I$(src)/src -DHAVE_CONFIG_H
