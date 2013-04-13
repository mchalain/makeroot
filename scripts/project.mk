# ==========================================================================
# create directories on the target system

download-copy= | tee $(addprefix $(BUILD_DOWNLOAD_PATH), $(notdir $(1)))
download-wget=wget -O - $(1) $(if $(findstring y,$(BUILD_DOWNLOAD_KEEP_COPY)), $(download-copy))
download-directory= cat $(1)

download=$(if $(wildcard $(addprefix $(BUILD_DOWNLOAD_PATH), $(notdir $(1)))), $(download-directory), $(download-wget))
quiet_cmd_download-project = DOWNLOAD $@ from $($@-url)
cmd_download-project = \
	$(eval url = $($(notdir $@)-url)) \
	$(if $(filter $(suffix $(url)), .gz), \
		$(call download, $(url)) | tar -xzf - -C $(src), \
	$(if $(filter $(suffix $(url)), .bz2), \
		$(call download, $(url)) tar -xjf - -C $(src), \
	$(if $(filter $(suffix $(url)), .xz), \
		$(call download, $(url)) tar -xJf - -C $(src), \
	$(if $(findstring :pserver:,$(url)), \
		cvs -z 9 -d $(url) co $(notdir $@), \
	$(if $(filter $(suffix $(url)), .git), \
		git clone $(url) $(src)/$@)))))

quiet_cmd_configure-project = CONFIGURE $@
cmd_configure-project = \
	$(eval sprj-defconfig = $($(notdir $@)-defconfig)) \
	$(eval sprj-config = $($(notdir $@)-config)) \
        $(eval sprj-makeflags = $($(notdir $@)-makeflags)) \
	$(if $(sprj-config), $(sprj-config), \
	$(if $(sprj-defconfig), cp $(sprj-defconfig) $(sprj-src)/.config; $(MAKE) $(sprj-makeflags) -C $(sprj-src) MAKEFLAGS= silentoldconfig))

quiet_cmd_build-project = BUILD $@
cmd_build-project = \
	$(eval sprj-build = $($(notdir $@)-build)) \
	$(eval sprj-makeflags = $($(notdir $@)-makeflags)) \
	$(if $(sprj-build), $(sprj-build), $(MAKE) $(sprj-makeflags) MAKEFLAGS= -C $(sprj-src) $(target); )

quiet_cmd_install-project = INSTALL $@
cmd_install-project = \
	$(eval sprj-install = $($(notdir $@)-install)) \
	$(eval sprj-makeflags = $($(notdir $@)-makeflags)) \
	$(if $(sprj-install), $(sprj-install), $(MAKE)  $(sprj-makeflags) MAKEFLAGS= PREFIX=$(objtree) -C $(sprj-src) install)

$(sort $(subproject-y)): $($(notdir $@)-defconfig) FORCE
	@$(eval sprj-src =  $(addprefix $(src)/,$@)) \
	$(if $(wildcard  $(sprj-src)), ,$(call cmd,download-project))
	@$(eval sprj-src =  $(addprefix $(src)/,$@)) \
	$(call cmd,configure-project)
        
	@$(eval sprj-targets = $($(notdir $@)-build-target)) \
	$(eval sprj-src =  $(addprefix $(src)/,$@)) \
	$(if $(sprj-targets), \
		$(foreach target, $(sprj-targets), $(call cmd,build-project)), \
		$(call cmd,build-project))
	@$(call cmd,install-project)

FORCE: ;
