ethtool-version=3.13
subproject-$(CONFIG_ETHTOOL)+=ethtool
ethtool-url="https://www.kernel.org/pub/software/network/ethtool/ethtool$(ethtool-version:%=-%).tar.xz"

install-$(CONFIG_INETSCRIPTS)+=$(CONFIGDIR)/init.d/inetconfig $(CONFIGDIR)/init.d/inetserverconfig
install-$(CONFIG_INETSCRIPTS)+=$(CONFIGDIR)/network/eth0.conf
$(CONFIGDIR)/network/eth0.conf: generate=/tmp/eth0.conf
$(CONFIGDIR)/network/eth0.conf: /tmp/eth0.conf
/tmp/eth0.conf: FORCE
	@echo -n > $@
	@echo ip="$(CONFIG_IPADDRESS)" >> $@
	@echo subnet="$(CONFIG_NETMASK)" >> $@
	@echo hostname="$(CONFIG_CONFIGNAME)" >> $@
	@echo router="$(CONFIG_GATEWAY)" >> $@
	@echo dns="$(CONFIG_NAMESERVER1)" "$(CONFIG_NAMESERVER2)" >> $@
$(CONFIGDIR)/init.d/inetconfig: copy=$(src)/inetscripts/inetconfig
$(CONFIGDIR)/init.d/inetconfig: chmod:=744
$(CONFIGDIR)/init.d/inetserverconfig: copy=$(src)/inetscripts/inetserverconfig
$(CONFIGDIR)/init.d/inetserverconfig: chmod:=744

install-$(CONFIG_TMPFS)+=$(CONFIGDIR)/hosts $(CONFIGDIR)/resolv.conf
$(CONFIGDIR)/hosts: link=../tmp/hosts
$(CONFIGDIR)/resolv.conf: link=../tmp/resolv.conf
