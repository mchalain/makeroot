# ==========================================================================
# create directories on the target system

pebsize:=$(shell echo $(mtd-pebsize)' * 1024' | bc)
lebsize:=$(if $(mtd-subpagesize),\
	$(shell echo $(pebsize) - $(mtd-pagesize) | bc),\
	$(shell echo $(pebsize) - $(mtd-pagesize) - $(mtd-pagesize) | bc))

define cmd_mkfs-ubifs
	$(eval fssize:= $(shell echo $($*-size)' * 1024 * 1024'| bc))
	$(eval pebcnt:= $(shell echo $(fssize) / $(pebsize)| bc))
	$(eval maxbadpeb:=$(shell echo $(pebcnt) / 100 + 4 | bc))
	$(eval mingoodped:=$(shell echo $(pebcnt) - $(maxbadpeb) | bc))
	$(eval overhead:=$(shell echo $(maxbadpeb)' * '$(pebsize)  + $(mingoodped)' * ('$(pebsize) - $(lebsize)')' | bc))
	$(eval emptypebcnt:=$(shell echo $(overhead)/$(pebsize)| bc))
	$(eval availablepebcnt:=$(shell echo $(pebcnt) - $(emptypebcnt)| bc))
	$(eval lebcnt=$(shell echo $(availablepebcnt)' * '$(pebsize) / $(lebsize)| bc))
	$(Q)/usr/sbin/mkfs.ubifs -m $(mtd-pagesize) -e $(lebsize) -c $(lebcnt) -r $($*-data) -o $@
endef

%.ubi.cfg: %.fs
	@echo [ubifs] > $@
	@echo mode=ubi >> $@
	@echo image=$< >> $@
	@echo vol_id=$(vol_id) >> $@
	@echo vol_size=$(sizeavailableMb)MiB >> $@
	@echo vol_type=dynamic >> $@
	@echo vol_name=$(imagename)  >> $@
	@echo vol_flags=autoresize >> $@

#*************************************************************
# UBIFS rules

$(imagename).ubi: $(imagename).ubi.cfg
	@ubinize -m $(miniosize) -p $(pebsize) -s $(subpagesize) -o $@ $<

