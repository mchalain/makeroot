cups-version=1.7.0
subproject-$(CONFIG_CUPS)+=cups
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
subproject-$(CONFIG_PROFTP)+=proftpd
proftpd-url=ftp://ftp.proftpd.org/distrib/source/proftpd-$(proftpd-version).tar.gz

pupnp-version=git
subproject-$(CONFIG_LIBUPNP)+=pupnp
pupnp-git= git://gitorious.org/pupnp/pupnp.git

libdlna-version=0.2.4
subproject-$(CONFIG_LIBUPNP)+=libdlna
libdlna-url= http://libdlna.geexbox.org/releases/libdlna-$(libdlna-version).tar.bz2
libdlna-hg=http://hg.geexbox.org/libdlna

ushare-version=1.1a
subproject-$(CONFIG_USHARE)+=ushare
ushare-url=http://ushare.geexbox.org/releases/ushare-$(ushare-version).tar.bz2
ushare-hg=http://hg.geexbox.org/ushare

mediatomb-version=0.12.1
subproject-$(CONFIG_MEDIATOMB)+=mediatomb
mediatomb-url=http://downloads.sourceforge.net/mediatomb/mediatomb-$(mediatomb-version).tar.gz
mediatomb-git=git://mediatomb.git.sourceforge.net/gitroot/mediatomb/mediatomb

libsoup-version=2.45.3
libsoup-mainversion=2.45
#libsoup-version=git
subproject-$(CONFIG_LIBSOUP)+=libsoup
libsoup-url=https://download.gnome.org/sources/libsoup/$(libsoup-mainversion)/libsoup-$(libsoup-version).tar.xz
libsoup-git=git://git.gnome.org/libsoup

gssdp-version=0.14.6
gssdp-mainversion=0.14
subproject-$(CONFIG_GUPNP)+=gssdp
gssdp-url=https://download.gnome.org/sources/gupnp/$(gssdp-mainversion)/gssdp-$(gssdp-version).tar.xz
gssdp-git="git://git.gnome.org/gssdp.git"

gupnp-version=0.20.9
gupnp-mainversion=0.20
subproject-$(CONFIG_GUPNP)+=gupnp
gupnp-url=https://download.gnome.org/sources/gupnp/$(gupnp-mainversion)/gupnp-$(gupnp-version).tar.xz
gupnp-git="git://git.gnome.org/gupnp.git"

gupnp-dlna-version=0.10.2
gupnp-dlna-mainversion=0.10
subproject-$(CONFIG_GUPNP)+=gupnp-dlna
gupnp-dlna-url=https://download.gnome.org/sources/gupnp/$(gupnp-dlna-mainversion)/gupnp-dlna-$(gupnp-dlna-version).tar.xz
gupnp-dlna-git="git://git.gnome.org/gupnp-dlna.git"

