cups-version=$(CONFIG_SERVER_CUPS_VERSION)
subproject-$(CONFIG_SERVER_CUPS_SP)+=cups
cups-url="http://www.cups.org/software/$(cups-version)/cups-$(cups-version)-source.tar.bz2"
cups-configure-arguments:=--disable-unit-tests --enable-libusb 
hostprogs-$(CONFIG_SERVER_CUPS)+=mantohtml
mantohtml-objs:=cups$(cups-version:%=-%)/man/mantohtml.o
mantohtml-cflags:=-I$(src)/cups$(cups-version:%=-%)/
#hostprogs-$(CONFIG_SERVER_CUPS)+=genstrings
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

proftpd-version=$(CONFIG_SERVER_PROFTP_VERSION)
subproject-$(CONFIG_SERVER_PROFTP_SP)+=proftpd
proftpd-url=ftp://ftp.proftpd.org/distrib/source/proftpd-$(proftpd-version).tar.gz
proftpd-configure-arguments:=--enable-dso --disable-strip
proftpd-configure-arguments+=--localstatedir=/var/run
ifneq ($(CONFIG_NETWORK_IPV6),y)
proftpd-configure-arguments:=--disable-ipv6
endif
ifeq ($(CONFIG_LIBC_NLS),y)
proftpd-configure-arguments:=--enable-nls
endif
ifneq ($(CONFIG_SECURITY_PAM),y)
proftpd-configure-arguments+=--disable-auth-pam
endif
ifeq ($(CONFIG_SECURITY_OPENSSL_SP),y)
proftpd-configure-arguments+=--enable-openssl
endif
ifeq (y,$(CONFIG_FW_PCRE_SP))
proftpd-configure-arguments+=--enable-pcre
endif
ifneq ($(CONFIG_SECURITY_CAP),y)
proftpd-configure-arguments+=--disable-cap --disable-facl
endif
ifneq ($(CONFIG_NCURSES),y)
proftpd-configure-arguments+=--disable-curses --disable-ncurses
endif

tcp_wrappers-version:=$(CONFIG_SERVER_TCPW_VERSION)
subproject-$(CONFIG_SERVER_TCPW_SP)+=tcp_wrappers
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
download-$(CONFIG_SERVER_TCPW_SP)+=hosts.allow
hosts.allow-url:=http://svnweb.freebsd.org/base/head/etc/hosts.allow?view=co
install-$(CONFIG_SERVER_TCPW_SP)+=etc/hosts.allow
etc/hosts.allow:copy=$(src)/hosts.allow
etc/hosts.allow:$(src)/hosts.allow

libtirpc-version:=$(CONFIG_SERVER_LIBTIRPC_VERSION)
subproject-$(CONFIG_SERVER_LIBTIRPC_SP)+=libtirpc
libtirpc-url:=http://downloads.sourceforge.net/project/libtirpc/libtirpc/$(libtirpc-version)/libtirpc-$(libtirpc-version).tar.bz2
libtirpc-builddir:=y
libtirpc-makeflags:=CPPFLAGS="$(CPPFLAGS) -I$(sysroot)/usr/include/tirpc"
libtirpc-configure-arguments:=--disable-static
ifneq ($(CONFIG_SECURITY_GSS),y)
libtirpc-configure-arguments+=--disable-gssapi
endif
ifneq ($(CONFIG_SERVER_NIS),y)
libtirpc-configure-arguments+=--disable-nis
endif
install-$(CONFIG_SERVER_RPC)+=etc/netconfig
etc/netconfig:copy=$(packagesdir)/libtirpc-$(libtirpc-version)/etc/netconfig

nis-utils-version:=1.4.1
subproject-$(CONFIG_SERVER_NIS)+=nis-utils
nis-utils-url:=http://www.linux-nis.org/download/NIS+/nis-utils-$(nis-utils-version).tar.gz
nis-utils-makeflags:=CFLAGS="$(CFLAGS) -I/usr/include/tircp"
nis-utils-configure-arguments:=
ifeq ($(CONFIG_LIBC_NLS),y)
nis-utils-configure-arguments+=--enable-nls
else
nis-utils-configure-arguments+=--disable-nls
endif
pre-install-$(CONFIG_SERVER_RCP)+=usr/include/rpcsvc/tirpc/nispasswd.h
usr/include/tirpc/rpcsvc/nispasswd.h: copy=$(src)/nis-utils-$(nis-utils-version)/src/rpc.nispasswdd/nispasswd.h
usr/include/tirpc/rpcsvc/nispasswd.h:install-sysroot:=y
pre-install-$(CONFIG_SERVER_RPC)+=usr/include/tirpc/rpcsvc/nis.h
usr/include/tirpc/rpcsvc/nis.h: generate=/tmp/nis.h
usr/include/tirpc/rpcsvc/nis.h:install-sysroot:=y
usr/include/tirpc/rpcsvc/nis.h: /tmp/nis.h
/tmp/nis.h:
	$(Q)$(hostbin)/rpcgen -h $(src)/nis-utils-$(nis-utils-version)/src/nis.x -o $@

pwdutils-version:=3.0.4
subproject-$(CONFIG_SERVER_NIS)+=pwdutils
pwdutils-url:=https://www.kernel.org/pub/linux/utils/net/NIS/pwdutils-$(pwdutils-version).tar.gz
pwdutils-configure-arguments:=
ifeq ($(CONFIG_LIBC_NLS),y)
pwdutils-configure-arguments+=--enable-nls
else
pwdutils-configure-arguments+=--disable-nls
endif

ypserv-version:=2.32
subproject-$(CONFIG_SERVER_NIS)+=ypserv
ypserv-url:=http://www.linux-nis.org/download/ypserv/ypserv-$(ypserv-version).tar.gz
ypserv-configure-arguments:=
ifeq ($(CONFIG_LIBC_NLS),y)
ypserv-configure-arguments+=--enable-nls
else
ypserv-configure-arguments+=--disable-nls
endif
pre-install-$(CONFIG_SERVER_NIS)+=usr/include/tirpc/rpcsvc/yp.h
usr/include/tirpc/rpcsvc/yp.h: copy=$(src)/ypserv-$(ypserv-version)/lib/yp.h
usr/include/tirpc/rpcsvc/yp.h:install-sysroot:=y
pre-install-$(CONFIG_SERVER_NIS)+=usr/include/tirpc/rpcsvc/yppasswd.h
usr/include/tirpc/rpcsvc/yppasswd.h: copy=$(src)/ypserv-$(ypserv-version)/rpc.yppasswdd/yppasswd.h
usr/include/tirpc/rpcsvc/yppasswd.h:install-sysroot:=y

yp-tools-version:=2.14
subproject-$(CONFIG_SERVER_NIS)+=yp-tools
yp-tools-url:=http://www.linux-nis.org/download/yp-tools/yp-tools-$(yp-tools-version).tar.gz
ifeq ($(CONFIG_LIBC_NLS),y)
yp-tools-configure-arguments:=--enable-nls
else
yp-tools-configure-arguments:=--disable-nls
endif
pre-install-$(CONFIG_SERVER_NIS)+=usr/include/tirpc/rpcsvc/ypclnt.h
usr/include/tirpc/rpcsvc/ypclnt.h: copy=$(src)/yp-tools-$(yp-tools-version)/src/ypclnt.h
usr/include/tirpc/rpcsvc/ypclnt.h:install-sysroot:=y

ypbind-mt-version:=1.37.1
subproject-$(CONFIG_SERVER_NIS)+=ypbind-mt
ypbind-mt-url:=http://www.linux-nis.org/download/ypbind-mt/ypbind-mt-$(ypbind-mt-version).tar.bz2
ifeq ($(CONFIG_LIBC_NLS),y)
ypbind-mt-configure-arguments:=--enable-nls
else
ypbind-mt-configure-arguments:=--disable-nls
endif

libnfsidmap-version:=$(CONFIG_SERVER_NFSIDMAP_VERSION)
subproject-$(CONFIG_SERVER_NFSIDMAP_SP)+=libnfsidmap
libnfsidmap-url:=http://www.citi.umich.edu/projects/nfsv4/linux/libnfsidmap/libnfsidmap-$(libnfsidmap-version).tar.gz
libnfsidmap-builddir:=y

nfs-utils-version=$(CONFIG_SERVER_NFSUTILS_VESION)
subproject-$(CONFIG_SERVER_NFSUTILS_SP)+=nfs-utils
nfs-utils-url:=ftp://ftp.kernel.org/pub/linux/utils/nfs-utils/$(nfs-utils-version)/nfs-utils-$(nfs-utils-version).tar.xz
nfs-utils-url:=http://ftp.free.fr/mirrors/ftp.kernel.org/linux/utils/nfs-utils/$(nfs-utils-version)/nfs-utils-$(nfs-utils-version).tar.xz
#nfs-utils-url:=http://downloads.sourceforge.net/nfs/nfs-utils-$(nfs-utils-version).tar.bz2
nfs-utils-git:=git://git.linux-nfs.org/projects/steved/nfs-utils.git
nfs-utils-LIBS:=-lrt -ldl
nfs-utils-LIBS+=-lnsl
nfs-utils-configure-arguments:=LIBS="$(nfs-utils-LIBS)" --disable-nfsv41 
nfs-utils-configure-arguments+=--with-sysroot=$(sysroot) --with-rpcgen=$(hostbin)/rpcgen
ifneq ($(CONFIG_SERVER_TCPW_SP),y)
nfs-utils-configure-arguments+=--without-tcp-wrappers
endif
ifneq ($(CONFIG_SECURITY_GSS),y)
nfs-utils-configure-arguments+=--disable-gss --disable-uuid --disable-nfsdcltrack
endif
ifeq ($(CONFIG_SERVER_LIBTIRPC_SP),y)
nfs-utils-configure-arguments+=--enable-tirpc --with-tirpcinclude=$(sysroot)/usr/include/tirpc
else
nfs-utils-configure-arguments+=--disable-tirpc
endif

install-$(CONFIG_SERVER_NFS)+=var/lib/nfs etc/exports usr/include/
var/lib/nfs:dir=y
var/lib/nfs/rmtab:touch=y
etc/exports:generate=/tmp/exports
etc/exports:/tmp/exports
/tmp/exports:
	$(Q)echo "/home $(CONFIG_IPADDRESS)(rw,sync)" > $@

pre-install-$(CONFIG_SERVER_RPC)+=usr/include/tirpc/rpcsvc/mount.h
usr/include/tirpc/rpcsvc/mount.h: generate=/tmp/mount.h
usr/include/tirpc/rpcsvc/mount.h:install-sysroot:=y
usr/include/tirpc/rpcsvc/mount.h: /tmp/mount.h
/tmp/mount.h:
	$(Q)$(hostbin)/rpcgen -h $(src)/nfs-utils-$(nfs-utils-version)/support/export/mount.x -o $@
pre-install-$(CONFIG_SERVER_RPC)+=usr/include/tirpc/rpcsvc/nfs_prot.h
usr/include/tirpc/rpcsvc/nfs_prot.h: copy=$(src)/nfs-utils-$(nfs-utils-version)/support/include/rpcsvc/nfs_prot.h
usr/include/tirpc/rpcsvc/nfs_prot.h:install-sysroot:=y

rpcbind-version:=$(CONFIG_SERVER_RPCBIND_VESION)
subproject-$(CONFIG_SERVER_RPCBIND_SP)+=rpcbind
rpcbind-url:=sourceforge.net/projects/rpcbind/files/rpcbind/$(rpcbind-version)/rpcbind-$(rpcbind-version).tar.bz2
rpcbind-builddir:=y
rpcbind-configure-arguments:=--bindir=/sbin --with-rpcuser=root
ifeq ($(CONFIG_SERVER_TCPW_SP),y)
rpcbind-configure-arguments+=--enable-libwrap
endif
rpcbind-CFLAGS:=
ifeq ($(CONFIG_SERVER_NIS),y)
rpcbind-CFLAGS+=-DCONFIG_SERVER_NIS
endif
ifeq ($(CONFIG_SERVER_RQUOTA),y)
rpcbind-CFLAGS+=-DCONFIG_SERVER_RQUOTA
endif
rpcbind-makeflags:=CFLAGS="$(CFLAGS) $(rpcbind-CFLAGS)"

download-$(CONFIG_SERVER_RPC)+=services
services-url:=http://svnweb.freebsd.org/base/head/etc/services?view=co
install-$(CONFIG_SERVER_RPC)+=etc/services
etc/services:copy=$(src)/services
etc/services:$(src)/services
download-$(CONFIG_SERVER_RPC)+=rpc
rpc-url:=http://svnweb.freebsd.org/base/head/etc/rpc?view=co
install-$(CONFIG_SERVER_RPC)+=etc/rpc
etc/rpc:copy=$(src)/rpc
etc/rpc:$(src)/rpc

cifs-utils-version=$(CONFIG_SERVER_CIFSUTILS_VERSION)
subproject-$(CONFIG_SERVER_CIFSUTILS_SP)+=cifs-utils
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

samba-version=$(CONFIG_SERVER_SAMBA_VERSION)
subproject-$(CONFIG_SERVER_SAMBA_SP)+=samba
subproject-n+=samba
samba-url:=http://ftp.samba.org/pub/samba/stable/samba-$(samba-version).tar.gz
samba-config:=cd source3 && ./configure --host=$(TRIPLET) --target=$(TRIPLET)
#samba-config:=./source3/configure --cross-compile --cross-execute=$(CROSS_COMPILE:%-=%)-  --abi-check
samba-config+= --prefix=/usr --sysconfdir=/etc --with-configdir=/etc/samba
samba-configure-arguments+= --without-ads
samba-configure-arguments+= --enable-swat=no --with-winbind=no
samba-configure-arguments+= samba_cv_CC_NEGATIVE_ENUM_VALUES=yes
samba-configure-arguments+= libreplace_cv_HAVE_GETADDRINFO=no
samba-configure-arguments+= ac_cv_file__proc_sys_kernel_core_pattern=yes
ifneq ($(CONFIG_FW_GLIB_AVAHI),y)
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
ifneq ($(CONFIG_SERVER_CUPS_SP),y)
samba-configure-arguments+=--disable-cups
endif
samba-config+=$(samba-configure-arguments)
samba-build:=cd source3 && make
samba-install:=cd source3 && make DESTDIR=$(destdir) install

lighttpd-version:=$(CONFIG_SERVER_LIGHTTPD_VERSION)
subproject-$(CONFIG_SERVER_LIGHTTPD_SP)+=lighttpd
lighttpd-url:=http://download.lighttpd.net/lighttpd/releases-1.4.x/lighttpd-1.4.35.tar.gz
lighttpd-git:=
lighttpd-builddir:=y
lighttpd-makeflags:=
lighttpd-configure-arguments:=--program-prefix=
ifneq (y,$(CONFIG_FW_PCRE_SP))
lighttpd-configure-arguments+=--without-pcre
else
lighttpd-makeflags+=PCRECONFIG=$(rootfs)/usr/bin/pcre-config
endif
ifneq (y,$(CONFIG_FW_BZIP2_SP))
lighttpd-configure-arguments+=--without-bzip2
endif
ifeq (y,$(CONFIG_DB_GDBM_SP))
lighttpd-configure-arguments+=--with-gdbm
endif
ifeq (y,$(CONFIG_SECURITY_OPENSSL_SP))
lighttpd-configure-arguments+=--with-openssl
endif
ifeq (y,$(CONFIG_SECURITY_KRB5))
lighttpd-configure-arguments+=--with-kerberos5
endif

# the git reposiroty stores the cod inside pupnp directory,
# the official release stores the code inside libupnp
libupnp-version:=$(CONFIG_SERVER_LIBUPNP_VESION)
#libupnp-version:=git
subproject-$(CONFIG_SERVER_LIBUPNP_SP)+=libupnp
libupnp-url:=http://downloads.sourceforge.net/pupnp/libupnp-$(libupnp-version).tar.bz2
libupnp-git:= git://gitorious.org/pupnp/pupnp.git
libupnp-builddir:=y
libupnp-makeflags:=CPPFLAGS="$(CPPFLAGS) -I$(srctree)/$(src)/libupnp$(if $(findstring git,$(libupnp-version)),,$(libupnp-version:%=-%))/upnp/inc"
#the configuration request that the $LD version answers "*GNU*" but gcc as linker answers GCC
#during the configuration we use ld
libupnp-configure-arguments:=--enable-samples --enable-debug
libupnp-configure-arguments+=--without-documentation

libdlna-version=$(CONFIG_SERVER_LIBDLNA_VERSION)
subproject-$(CONFIG_SERVER_LIBDLNA_SP)+=libdlna
libdlna-url= http://libdlna.geexbox.org/releases/libdlna-$(libdlna-version).tar.bz2
libdlna-hg=http://hg.geexbox.org/libdlna
libdlna-config:=$(srctree)/$(src)/libdlna$(if $(findstring git,$(libdlna-version)),,$(libdlna-version:%=-%))/configure --cross-compile --cross-prefix=$(CROSS_COMPILE) --prefix=/usr

ushare-version=$(CONFIG_SERVER_USHARE_VERSION)
subproject-$(CONFIG_SERVER_USHARE_SP)+=ushare
ushare-url=http://ushare.geexbox.org/releases/ushare-$(ushare-version).tar.bz2
ushare-hg=http://hg.geexbox.org/ushare
ushare-config=$(srctree)/$(src)/ushare$(if $(findstring git,$(ushare-version)),,$(ushare-version:%=-%))/configure --cross-compile --cross-prefix=$(CROSS_COMPILE)
ushare-config+=--prefix=/usr --bindir=/usr/sbin --sysconfdir=/etc --disable-strip --enable-debug
ifneq ($(CONFIG_LIBC_NLS),y)
ushare-config+=--disable-nls
endif
ifeq ($(CONFIG_SERVER_LIBDLNA_SP),y)
ushare-config+=--enable-dlna
endif
install-$(CONFIG_SERVER_USHARE_SP)+=etc/ushare.conf
etc/ushare.conf:copy=$(packagesdir)/ushare-$(ushare-version)/etc/ushare.conf

mediatomb-version=$(CONFIG_SERVER_MEDIATOMB_VERSION)
subproject-$(CONFIG_SERVER_MEDIATOMB_SP)+=mediatomb
mediatomb-url=http://downloads.sourceforge.net/mediatomb/mediatomb-$(mediatomb-version).tar.gz
mediatomb-git=git://mediatomb.git.sourceforge.net/gitroot/mediatomb/mediatomb

empty:=
space:=$(empty) $(empty)
define mainversion
	$(eval versions=$(subst .,$(space),$(1)))
	$(subst $(space),.,$(filter-out $(lastword $(versions)),$(versions)))
endef

libsoup-version=2.45.3
libsoup-mainversion=$(call mainversion,$(libsoup-version))
#libsoup-version=git
subproject-$(CONFIG_SERVER_LIBSOUP)+=libsoup
libsoup-url=https://download.gnome.org/sources/libsoup/$(libsoup-mainversion)/libsoup-$(libsoup-version).tar.xz
libsoup-git=git://git.gnome.org/libsoup

gupnp-dlna-version=$(CONFIG_SERVER_GUPNP_DLNA_VERSION)
gupnp-dlna-mainversion=0.10
subproject-$(CONFIG_SERVER_GUPNP_DLNA_SP)+=gupnp-dlna
gupnp-dlna-url=https://download.gnome.org/sources/gupnp/$(gupnp-dlna-mainversion)/gupnp-dlna-$(gupnp-dlna-version).tar.xz
gupnp-dlna-git=git://git.gnome.org/gupnp-dlna.git

gupnp-version=$(CONFIG_SERVER_GUPNP_VERSION)
gupnp-mainversion=0.20
subproject-$(CONFIG_SERVER_GUPNP_SP)+=gupnp
gupnp-url=https://download.gnome.org/sources/gupnp/$(gupnp-mainversion)/gupnp-$(gupnp-version).tar.xz
gupnp-git=git://git.gnome.org/gupnp.git
