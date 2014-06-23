subproject-$(CONFIG_SECURITY_KRB5)+=krb5

openssl-version=$(CONFIG_SECURITY_OPENSSL_VERSION)
subproject-$(CONFIG_SECURITY_OPENSSL_SP)+=openssl
openssl-url=http://www.openssl.org/source/openssl-$(openssl-version).tar.gz
ifeq ($(KERNEL),linux)
openssl-targetname:=$(openssl-targetname:%=%-)linux
endif
ifeq ($(ARCH),arm)
openssl-targetname:=$(openssl-targetname:%=%-)armv4
endif
openssl-makeflags:=MAKEFLAGS="CROSS_COMPILE= INSTALL_PREFIX=$(packagesdir)/openssl-$(openssl-version)"
openssl-config:=./Configure $(openssl-targetname) --prefix=/$(SYSTEM) --openssldir=/$(CONFIGDIR)/ssl
openssl-config+=shared zlib-dynamic
ifneq ($(CONFIG_SECURITY_KRB5),y)
openssl-config+= no-krb5 
endif

openssh-version=$(CONFIG_SECURITY_OPENSSH_VERSION)
subproject-$(CONFIG_SECURITY_OPENSSH_SP)+=openssh
openssh-url=http://mirrors.ircam.fr/pub/OpenBSD/OpenSSH/portable/openssh-$(openssh-version).tar.gz
openssh-makeflags:=LD=$(CC)
openssh-configure-arguments:=--disable-strip

subproject-$(CONFIG_SECURITY_PAM)+=pam

subproject-$(CONFIG_SECURITY_CAP)+=CAP

subproject-$(CONFIG_SECURITY_GSS)+=gss

subproject-$(CONFIG_SECURITY_LDAP)+=ldap

empty:=
space:=$(empty) $(empty)
define mainversion
	$(eval versions=$(subst .,$(space),$(1)))
	$(subst $(space),.,$(filter-out $(lastword $(versions)),$(versions)))
endef

gssdp-version=0.14.6
gssdp-mainversion=0.14
subproject-$(CONFIG_SECURITY_GSSDP)+=gssdp
gssdp-url=https://download.gnome.org/sources/gupnp/$(gssdp-mainversion)/gssdp-$(gssdp-version).tar.xz
gssdp-git=git://git.gnome.org/gssdp.git

