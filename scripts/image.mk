ifeq ($(CONFIG_BOARD_NAND_PAGE_SIZE),)
CONFIG_BOARD_NAND_PAGE_SIZE := 2048
endif
ifeq ($(CONFIG_BOARD_NAND_SPARE_SIZE),)
CONFIG_BOARD_NAND_SPARE_SIZE := 64
endif


ifdef CONFIG_FS_YAFFS2
MKYAFFS2:=mkyaffs2

mkyaffs2_extra_flags += -c $(CONFIG_BOARD_NAND_PAGE_SIZE)
mkyaffs2_extra_flags += -s $(CONFIG_BOARD_NAND_SPARE_SIZE)

ifneq ($(TARGET_OUT),)
define build-systemfs-target
	$(MKYAFFS2) -f $(mkyaffs2_extra_flags) $(TARGET_OUT) $(1)
endef
else
define build-systemimage-target
	echo define TARGET_OUT
endef
endif
endif

ifdef CONFIG_FS_UBIFS
MKUBIFS:=mkfs.ubifs
UBI_SIZE_PEB:=128
UBI_SIZE_LEB:=124
UBI_NB_PEB:=$(CONFIG_FS_ROOTSIZE) * 1024 / $(UBI_SIZE_PEB)
UBI_NB_BADPEB:=$(UBI_NB_PEB) / 100
UBI_OVERHEAD:=($(UBI_NB_BADPEB) + 4) * $(UBI_SIZE_PEB) + ($(UBI_SIZE_PEB) - $(UBI_SIZE_LEB)) * ($(UBI_NB_PEB) - $(UBI_NB_BADPEB) - 4)
UBI_NB_LEB:=($(UBI_NB_PEB) - $(UBI_OVERHEAD)) * $(UBI_SIZE_PEB) / $(UBI_SIZE_LEB)
mkubifs_extra_flags:= -e $(UBI_SIZE_LEB)KiB -c $(UBI_NB_LEB) -F
mkubifs_extra_flags += -m $(CONFIG_BOARD_NAND_PAGE_SIZE)
ifneq ($(TARGET_OUT),)
define build-systemfs-target
	$(MKUBIFS) $(mkubifs_extra_flags) -r  $(TARGET_OUT) $(1)
endef
else
define build-systemimage-target
	echo define TARGET_OUT
endef
endif
endif

ifdef CONFIG_IMG_UBI
endif

ifdef CONFIG_IMG_TOC
endif
