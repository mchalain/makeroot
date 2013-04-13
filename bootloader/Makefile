
subproject-$(CONFIG_U_BOOT_UX500)+=u-boot-ux500
u-boot-ux500-url:=git://igloocommunity.org/git/boot/u-boot-ux500.git
u-boot-ux500-config:=$(MAKE) -C $(src)/u-boot snowball_config
u-boot-ux500-build:=$(MAKE) -C $(src)/u-boot
u-boot-ux500-install:=$(INSTALL) $(src)/u-boot/u-boot $(objtree)/boot

subproject-$(CONFIG_U_BOOT)+=u-boot
u-boot-url:=git://www.denx.de/git/u-boot.git
u-boot-config:=$(MAKE) -C $(src)/u-boot $(CONFIG_BOARD)_config
u-boot-build:=$(MAKE) -C $(src)/u-boot
u-boot-install:=$(INSTALL) $(src)/u-boot/u-boot $(objtree)/boot

