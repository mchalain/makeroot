cups-version=1.7.0
subproject-$(CONFIG_SERVER_CUPS)+=cups
cups-url="http://www.cups.org/software/$(cups-version)/cups-$(cups-version)-source.tar.bz2"
cups-configure-arguments:=--disable-unit-tests --enable-libusb 
hostprogs-y+=mantohtml
mantohtml-objs:=cups$(cups-version:%=-%)/man/mantohtml.o
mantohtml-cflags:=-I$(src)/cups$(cups-version:%=-%)/
#hostprogs-y+=genstrings
#genstrings-cxxobjs:=genstrings.o \
#		ppdc-array.o \
#		ppdc-attr.o \
#		ppdc-catalog.o \
#		ppdc-choice.o \
#		ppdc-constraint.o \
#		ppdc-driver.o \
#		ppdc-file.o \
#		ppdc-filter.o \
#		ppdc-font.o \
#		ppdc-group.o \
#		ppdc-import.o \
#		ppdc-mediasize.o \
#		ppdc-message.o \
#		ppdc-option.o \
#		ppdc-profile.o \
#		ppdc-shared.o \
#		ppdc-source.o \
#		ppdc-string.o \
#		ppdc-variable.o
#genstrings-cxxobjs:= $(addprefix cups$(cups-version:%=-%)/ppdc/,$(notdir $(genstrings-cxxobjs)))
#genstrings-cflags:=-I$(src)/cups$(cups-version:%=-%)/

proftpd-version=1.3.4d
subproject-$(CONFIG_SERVER_PROFTP)+=proftpd
proftpd-url=ftp://ftp.proftpd.org/distrib/source/proftpd-$(proftpd-version).tar.gz
proftpd-configure-arguments:=--enable-dso --enable-nls --disable-ipv6
proftpd-configure-arguments+=--localstatedir=/var
ifneq ($(CONFIG_SECURITY_PAM),y)
proftpd-configure-arguments+=--disable-auth-pam
endif
ifeq ($(CONFIG_SECURITY_OPENSSL),y)
proftpd-configure-arguments+=--enable-openssl
endif
ifneq ($(CONFIG_SECURITY_CAP),y)
proftpd-configure-arguments+=--disable-cap --disable-facl
endif
ifneq ($(CONFIG_NCURSES),y)
proftpd-configure-arguments+=--disable-curses --disable-ncurses
endif
install-$(CONFIG_SERVER_PROFTP)+=etc/proftpd.conf
etc/proftpd.conf:copy=$(packagesdir)/proftpd-$(proftpd-version)/etc/proftpd.conf
etc/proftpd.conf:$(packagesdir)/proftpd-$(proftpd-version)/etc/proftpd.conf

tcp_wrappers-version:=7.6
subproject-$(CONFIG_SERVER_TCPW)+=tcp_wrappers
tcp_wrappers-url:=ftp://ftp.cn.debian.org/gentoo/distfiles/tcp_wrappers_$(tcp_wrappers-version).tar.gz
tcp_wrappers-CFLAGS:=-fPIC -DPIC -D_REENTRANT -DSYS_ERRLIST_DEFINED -DBROKEN_SO_LINGER
tcp_wrappers-CFLAGS+=-Dss_family=__ss_family -Dss_len=__ss_len -DHAVE_WEAKSYMS
ifeq ($(CONFIG_INET6),y)
tcp_wrappers-CFLAGS+=-DINET6=1
endif
tcp_wrappers-makeflags:=\
	REAL_DAEMON_DIR=/tmp/tcp_wrappers \
	ARFLAGS=rv \
	LIBS=-lnsl \
	AUX_OBJ=weak_symbols.o \
	NETGROUP="-DNETGROUP"  \
	EXTRA_CFLAGS="$(tcp_wrappers-CFLAGS) $(CFLAGS)"
tcp_wrappers-install:= \
	$(INSTALL) -D     libwrap.a $(sprj-destdir)/usr/lib/ && \
	$(INSTALL) -DrpP  libwrap.so* $(sprj-destdir)/usr/lib && \
	$(INSTALL) -D     tcpd.h $(sprj-destdir)/usr/include/tcpd.h && \
	$(INSTALL) -D     safe_finger tcpd tcpdchk tcpdmatch try-from $(sprj-destdir)/usr/bin/safe_finger
download-$(CONFIG_SERVER_TCPW)+=hosts.allow
hosts.allow-url:=http://svnweb.freebsd.org/base/head/etc/hosts.allow?view=co
install-$(CONFIG_SERVER_TCPW)+=etc/hosts.allow
etc/hosts.allow:copy=$(src)/hosts.allow
etc/hosts.allow:$(src)/hosts.allow


libtirpc-version:=0.2.4
subproject-$(CONFIG_SERVER_RPC)+=libtirpc
libtirpc-url:=http://downloads.sourceforge.net/project/libtirpc/libtirpc/$(libtirpc-version)/libtirpc-$(libtirpc-version).tar.bz2
libtirpc-configure-arguments:=--disable-static
ifneq ($(CONFIG_SECURITY_GSS),y)
libtirpc-configure-arguments+=--disable-gssapi
endif

rpcbind-version:=0.2.1
subproject-$(CONFIG_SERVER_RCP)+=rpcbind
rpcbind-url:=sourceforge.net/projects/rpcbind/files/rpcbind/$(rpcbind-version)/rpcbind-$(rpcbind-version).tar.bz2
rpcbind-configure-arguments:=--bindir=/sbin --with-rpcuser=root
ifeq ($(CONFIG_SERVER_TCPW),y)
rpcbind-configure-arguments+=--enable-libwrap
endif
download-$(CONFIG_SERVER_RCP)+=services
services-url:=http://svnweb.freebsd.org/base/head/etc/services?view=co
install-$(CONFIG_SERVER_RCP)+=etc/services
etc/services:copy=$(src)/services
etc/services:$(src)/services
download-$(CONFIG_SERVER_RCP)+=rpc
rpc-url:=http://svnweb.freebsd.org/base/head/etc/rpc?view=co
install-$(CONFIG_SERVER_RCP)+=etc/rpc
etc/rpc:copy=$(src)/rpc
etc/rpc:$(src)/rpc

libnfsidmap-version:=0.25
subproject-$(CONFIG_SERVER_NFS)+=libnfsidmap
libnfsidmap-url:=http://www.citi.umich.edu/projects/nfsv4/linux/libnfsidmap/libnfsidmap-$(libnfsidmap-version).tar.gz

nfs-utils-version=git
subproject-$(CONFIG_SERVER_NFS)+=nfs-utils
nfs-utils-url:=http://downloads.sourceforge.net/nfs/nfs-utils-1.2.9.tar.bz2
nfs-utils-git:=git://git.linux-nfs.org/projects/steved/nfs-utils.git
nfs-utils-configure-arguments:=LIBS=-lnsl --disable-nfsv41
ifneq ($(CONFIG_SERVER_TCPW),y)
nfs-utils-configure-arguments+=--without-tcp-wrappers
endif
ifneq ($(CONFIG_SECURITY_GSS),y)
nfs-utils-configure-arguments+=--disable-gss --disable-uuid --disable-nfsdcltrack
endif
install-$(CONFIG_SERVER_NFS)+=var/lib/nfs etc/exports
var/lib/nfs:dir=y
var/lib/nfs/rmtab:touch=y
etc/exports:generate=/tmp/exports
etc/exports:/tmp/exports
/tmp/exports:
	@echo "/home $(CONFIG_IPADDRESS)(rw,sync)" > $@

cifs-utils-version=6.3
subproject-$(CONFIG_SERVER_SMB)+=cifs-utils
cifs-utils-url:=http://ftp.samba.org/pub/linux-cifs/cifs-utils/cifs-utils-$(cifs-utils-version).tar.bz2
cifs-utils-configure-arguments:=
ifneq ($(CONFIG_SECURITY_PAM),y)
cifs-utils-configure-arguments+=--disable-pam
endif
ifneq ($(CONFIG_SYSTEMD),y)
cifs-utils-configure-arguments+=--disable-systemd
endif
ifneq ($(CONFIG_SECURITY_CAP),y)
cifs-utils-configure-arguments+=--with-libcap-ng=no --with-libcap=no 
endif

samba-version=3.6.23
#subproject-$(CONFIG_SERVER_SMB)+=samba
subproject-n+=samba
samba-url:=http://ftp.samba.org/pub/samba/stable/samba-$(samba-version).tar.gz
samba-config:=cd source3 && ./configure --host=$(CROSS_COMPILE:%-=%) --target=$(CROSS_COMPILE:%-=%)
#samba-config:=./source3/configure --cross-compile --cross-execute=$(CROSS_COMPILE:%-=%)-  --abi-check
samba-config+= --prefix=/usr --sysconfdir=/etc --with-configdir=/etc/samba
samba-configure-arguments+= --without-ads
samba-configure-arguments+= --enable-swat=no --with-winbind=no
samba-configure-arguments+= samba_cv_CC_NEGATIVE_ENUM_VALUES=yes
samba-configure-arguments+= libreplace_cv_HAVE_GETADDRINFO=no
samba-configure-arguments+= ac_cv_file__proc_sys_kernel_core_pattern=yes
ifneq ($(CONFIG_GLIB_AVAHI),y)
samba-configure-arguments+=--disable-avahi
endif
ifneq ($(CONFIG_SECURITY_LDAP),y)
samba-configure-arguments+= --without-ldap
endif
ifneq ($(CONFIG_SECURITY_KRB5),y)
samba-configure-arguments+= --without-krb5 
endif
ifneq ($(CONFIG_SECURITY_PAM),y)
samba-configure-arguments+=--without-pam
endif
ifneq ($(CONFIG_SERVER_CUPS),y)
samba-configure-arguments+=--disable-cups
endif
samba-config+=$(samba-configure-arguments)
samba-build:=cd source3 && make
samba-install:=cd source3 && make DESTDIR=$(destdir) install

subproject-$(CONFIG_SERVER_LIBUPNP_OLD)+=libupnp

# the git reposiroty stores the cod inside pupnp directory,
# the official release stores the code inside libupnp
libupnp-version=1.6.19
subproject-$(CONFIG_SERVER_LIBUPNP)+=$(if $(findstring git,$(libupnp-version)), pupnp, libupnp)
libupnp-url:=http://downloads.sourceforge.net/pupnp/libupnp-$(pupnp-version).tar.bz2
pupnp-git:= git://gitorious.org/pupnp/pupnp.git
libupnp-configure-arguments:=--enable-samples --enable-debug

libdlna-version=0.2.4
subproject-$(CONFIG_SERVER_LIBUPNP)+=libdlna
libdlna-url= http://libdlna.geexbox.org/releases/libdlna-$(libdlna-version).tar.bz2
libdlna-hg=http://hg.geexbox.org/libdlna
libdlna-config=./configure --cross-compile --cross-prefix=$(CROSS_COMPILE:%-=%)- --prefix=/usr

ushare-version=1.1a
subproject-$(CONFIG_SERVER_USHARE)+=ushare
ushare-url=http://ushare.geexbox.org/releases/ushare-$(ushare-version).tar.bz2
ushare-hg=http://hg.geexbox.org/ushare
ushare-config=./configure --cross-compile --cross-prefix=$(CROSS_COMPILE:%-=%)- --prefix=/usr --bindir=/usr/sbin --sysconfdir=/etc --disable-strip --enable-debug
ifeq ($(LIBDLNA),y)
ushare-config+=--enable-dlna
endif
install-$(CONFIG_SERVER_USHARE)+=etc/ushare.conf
etc/ushare.conf:copy=$(packagesdir)/ushare-$(ushare-version)/etc/ushare.conf

mediatomb-version=0.12.1
subproject-$(CONFIG_SERVER_MEDIATOMB)+=mediatomb
mediatomb-url=http://downloads.sourceforge.net/mediatomb/mediatomb-$(mediatomb-version).tar.gz
mediatomb-git=git://mediatomb.git.sourceforge.net/gitroot/mediatomb/mediatomb

libsoup-version=2.45.3
libsoup-mainversion=2.45
#libsoup-version=git
subproject-$(CONFIG_SERVER_LIBSOUP)+=libsoup
libsoup-url=https://download.gnome.org/sources/libsoup/$(libsoup-mainversion)/libsoup-$(libsoup-version).tar.xz
libsoup-git=git://git.gnome.org/libsoup

gssdp-version=0.14.6
gssdp-mainversion=0.14
subproject-$(CONFIG_SECURITY_GSSDP)+=gssdp
gssdp-url=https://download.gnome.org/sources/gupnp/$(gssdp-mainversion)/gssdp-$(gssdp-version).tar.xz
gssdp-git=git://git.gnome.org/gssdp.git

gupnp-version=0.20.9
gupnp-mainversion=0.20
subproject-$(CONFIG_SERVER_GUPNP)+=gupnp
gupnp-url=https://download.gnome.org/sources/gupnp/$(gupnp-mainversion)/gupnp-$(gupnp-version).tar.xz
gupnp-git=git://git.gnome.org/gupnp.git

gupnp-dlna-version=0.10.2
gupnp-dlna-mainversion=0.10
subproject-$(CONFIG_SERVER_GUPNP)+=gupnp-dlna
gupnp-dlna-url=https://download.gnome.org/sources/gupnp/$(gupnp-dlna-mainversion)/gupnp-dlna-$(gupnp-dlna-version).tar.xz
gupnp-dlna-git=git://git.gnome.org/gupnp-dlna.git

