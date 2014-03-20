download-copy= | tee $(addprefix $(BUILD_DOWNLOAD_PATH)/, $(notdir $(1)))
download-wget=wget -O - $(1) $(if $(findstring y,$(BUILD_DOWNLOAD_KEEP_COPY)), $(download-copy))
download-directory= cat $(addprefix $(BUILD_DOWNLOAD_PATH)/, $(notdir $(1)))

download-short=$(if $(wildcard $(addprefix $(BUILD_DOWNLOAD_PATH)/, $(notdir $(1)))), $(download-directory), $(download-wget))
quiet_cmd_download-url = DOWNLOAD $* from $(dwl-url:"%"=%)
cmd_download-url = \
	$(if $(strip $(findstring .gz, $(suffix $(dwl-url))) $(findstring .tgz, $(suffix $(dwl-url)))), \
		$(call download-short, $(dwl-url)) | tar -xzf - -C $(src), \
	$(if $(findstring .bz2, $(suffix $(v))), \
		$(call download-short, $(dwl-url)) | tar -xjf - -C $(src), \
	$(if $(findstring .xz, $(suffix $(dwl-url))), \
		$(call download-short, $(dwl-url)) | tar -xJf - -C $(src), \
	$(if $($(notdir $*)-git),$(call cmd_download-git),$(error set $($(notdir $*)-url))))))

quiet_cmd_download-cvs = DOWNLOAD $* from $(dwl-url:"%"=%)
cmd_download-cvs = \
	git clone $(url) $(src)/$*

quiet_cmd_download-git = DOWNLOAD $* from $(dwl-url:"%"=%)
cmd_download-git = \
	cvs -z 9 -d $(dwl-url) co $(dwl-target)

quiet_cmd_download-hg = DOWNLOAD $* from $(dwl-url:"%"=%)
cmd_download-hg = \
	hg clone $(dwl-url) $(src)/$*

cmd_download = \
	$(eval dwl-target=$(1)) \
	$(eval dwl-version=$(2)) \
	$(if $(findstring hg,$(dwl-version)), \
		$(eval download-cmd=download-hg) \
		$(eval dwl-url=$($(dwl-target)-hg)) , \
		$(if $(findstring git,$(dwl-version)), \
			$(eval download-cmd=download-git) \
			$(eval dwl-url=$($(dwl-target)-git)) , \
			$(if $(findstring :pserver:,$(dwl-url)), \
				$(eval download-cmd=download-cvs) \
				$(eval dwl-url=$($(dwl-target)-url)) , \
				$(eval download-cmd=download-url) \
				$(eval dwl-url=$($(dwl-target)-url))))) \
	$(call cmd,$(download-cmd))
				
$(download-target): $(obj)/.%.dwl:
	$(eval sprj-src = $(addprefix $(src)/,$*$(if $(sprj-version),-$(sprj-version)))) \
	$(if $(wildcard  $(sprj-src)), ,$(call cmd_download,$*,$($(notdir $*)-version)))
	@touch $@
