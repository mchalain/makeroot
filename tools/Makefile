
subproject-$(CONFIG_TOOLS_MTD_UTILS)+=mtd-utils
mtd-utils-git:="git://git.infradead.org/mtd-utils.git"

subproject-$(CONFIG_TOOLS_NOKIA_FLASHER)+=maemo_flasher
maemo_flasher-url:=http://tablets-dev.nokia.com/maemo-dev-env-downloads.php?f=maemo_flasher-3.5_2.5.2.2.tar.gz

subdir-y+=$(src)/flasher

fileutils-verion=4.0
download-y+=fileutils
fileutils-url=ftp://ftp.gnu.org/old-gnu/fileutils/fileutils-$(fileutils-verion).tar.gz

subdir-y+=$(src)/install
subdir-$(CONFIG_SERVER_RPC)+= $(src)/sunrpc-4.0

pkg-config-version:=0.28
download-n+=pkg-config
pkg-config-url:=http://pkgconfig.freedesktop.org/releases/pkg-config-$(pkg-config-version).tar.gz
hostprogs-n+=pkg-config 
pkg-config-directory=$(if $(findstring git,$(pkg-config-version)),pkg-config,pkg-config$(pkg-config-version:%=-%))
pkg-config-objs:=$(pkg-config-directory)/main.o $(pkg-config-directory)/parse.o $(pkg-config-directory)/pkg.o
pkg-config-install:=pkg-config
