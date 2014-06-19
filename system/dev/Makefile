termcap-version=1.3.1
subproject-$(CONFIG_TOOLS_GDB)+=termcap
termcap-url=ftp://ftp.gnu.org/gnu/termcap/termcap-$(termcap-version).tar.gz
termcap-config:=./configure --host=$(TRIPLET) --target=$(TRIPLET) --prefix=/usr/local
termcap-install= \
	rm -rf $(sprj-destdir)/usr && \
	$(INSTALL) -D libtermcap.a $(sprj-destdir)/usr/lib/ && \
	$(INSTALL) -D termcap.h $(sprj-destdir)/usr/include/

gdb-version=7.6
subproject-$(CONFIG_TOOLS_GDB)+=gdb
gdb-url=http://ftp.gnu.org/gnu/gdb/gdb-$(gdb-version).tar.gz
gdb-configure-arguments:=--prefix=/usr/local
gdb-builddir:=y

strace-version=4.8
subproject-$(CONFIG_TOOLS_GDB)+=strace
strace-url:=http://sourceforge.net/projects/strace/files/strace/$(strace-version)/strace-$(strace-version).tar.xz
