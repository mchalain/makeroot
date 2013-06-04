termcap-version=1.3.1
subproject-$(CONFIG_TOOLS_GDB)+=termcap
termcap-url=ftp://ftp.gnu.org/gnu/termcap/termcap-$(termcap-version).tar.gz
termcap-config=./configure  --target=$(CROSS_COMPILE:%-=%) --host=$(CROSS_COMPILE:%-=%) CC=$(CROSS_COMPILE:%-=%)-gcc --prefix=/usr/local
termcap-install=cp libtermcap.a $(objtree)/usr/local/lib; cp termcap.h $(objtree)/usr/local/include

gdb-version=7.6
subproject-$(CONFIG_TOOLS_GDB)+=gdb
gdb-url=http://ftp.gnu.org/gnu/gdb/gdb-$(gdb-version).tar.gz
gdb-config=./configure  --target=$(CROSS_COMPILE:%-=%) --host=$(CROSS_COMPILE:%-=%) CC=$(CROSS_COMPILE:%-=%)-gcc --prefix=/usr/local

