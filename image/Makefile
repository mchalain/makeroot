
subdir-$(CONFIG_IMAGE_MMC)=image/mmc
subdir-$(CONFIG_IMAGE_QEMU)=image/mmc

imagename=$(UBIFS_IMAGE_NAME)
vol_id=0
miniosize = $(CONFIG_MTD_PAGESIZE)
subpagesize = $(CONFIG_MTD_SUBPAGESIZE)
imagesize=$(shell echo $(CONFIG_UBIFS_SIZE)' * 1024 * 1024'| bc)
pebsize=$(shell echo $(CONFIG_MTD_PEB)' * 1024' | bc)
lebsize=$(shell echo $(CONFIG_UBIFS_LEB)' * 1024'| bc)
pebcnt=$(shell echo $(imagesize) / $(pebsize)| bc)
maxbadpeb=$(shell echo $(pebcnt) / 100 + 4 | bc)
cal_o=$(shell echo $(pebsize) - $(lebsize) | bc)
mingoodped=$(shell echo $(pebcnt) - $(maxbadpeb) | bc)
badpebsize=$(shell echo $(maxbadpeb)' * '$(pebsize)  + $(cal_o)' * ' $(mingoodped) | bc)
sizeavailable=$(shell echo $(imagesize) - $(badpebsize) | bc)
lebcnt=$(shell echo $(sizeavailable) / $(lebsize)| bc)
sizeavailableMb=$(shell echo $(sizeavailable) / 1024 / 1024| bc)

$(imagename).ubifs:
	@echo CREATE IMAGE of $(sizeavailableMb)MiB for $(CONFIG_UBIFS_SIZE)MiB
	@mkfs.ubifs -m $(miniosize) -e $(lebsize) -c $(lebcnt) -F -r $(objtree) -o $@

$(imagename).ubi.cfg: $(imagename).ubifs
	@echo [ubifs] > $@
	@echo mode=ubi >> $@
	@echo image=$< >> $@
	@echo vol_id=$(vol_id) >> $@
	@echo vol_size=$(sizeavailableMb)MiB >> $@
	@echo vol_type=dynamic >> $@
	@echo vol_name=$(imagename)  >> $@
	@echo vol_flags=autoresize >> $@

$(imagename).ubi: $(imagename).ubi.cfg
	@ubinize -m $(miniosize) -p $(pebsize) -s $(subpagesize) -o $@ $<

ifeq ("y", "$(CONFIG_UBIFS)")
targets+=$(imagename).ubi
endif
ifeq ("y", "$(CONFIG_IMAGE_MMC)")
targets+=$(CONFIG_MMC_ROOT_PATH:"%"=%)
endif


#	qflasher -w -m rx51 -x $QBOOTDIR/xloader-qemu.bin -s $QBOOTDIR/secondary-qemu.bin -k $KERNEL -r /tmp/nemo.ubi.img -o $QEMUDATADIR/$IMAGE -p k=3072 -p i=1024 -p r=257278 -v

