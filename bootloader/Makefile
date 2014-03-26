
u-boot-dir=u-boot

u-boot-version=$(CONFIG_U_BOOT_VERSION:"%"=%)
subproject-$(CONFIG_U_BOOT)+=u-boot
ifeq ($(findstring ux500,$(u-boot-version)),ux500)
u-boot-git:=https://github.com/igloocommunity/u-boot-ux500.git
else
u-boot-git:=git://www.denx.de/git/u-boot.git
endif
u-boot:=$(CONFIG_U_BOOT_TARGET:"%"=%)_config
u-boot-config:=make $(CONFIG_U_BOOT_TARGET:"%"=%)_config
u-boot-hostbin:=dumpimage img2brec.sh img2srec jtagconsole mkenvimage mkimage netconsole proftool reformat.py
u-boot-hostbin:=$(addprefix tools/,$(u-boot-hostbin))
u-boot-install:= \
	cp $(u-boot-hostbin) $(hostbin)
