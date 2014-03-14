ethtool-version=3.13
subproject-$(CONFIG_ETHTOOL)+=ethtool
ethtool-url="https://www.kernel.org/pub/software/network/ethtool/ethtool$(ethtool-version:%=-%).tar.xz"

install-$(CONFIG_INETSCRIPTS)+=etc/init.d/inetconfig etc/init.d/inetserverconfig
install-$(CONFIG_INETSCRIPTS)+=etc/network/eth0.conf
etc/network/eth0.conf: generate=/tmp/eth0.conf
etc/network/eth0.conf: /tmp/eth0.conf
/tmp/eth0.conf: FORCE
	@echo -n > $@
	@echo ip="$(CONFIG_IPADDRESS)" >> $@
	@echo subnet="$(CONFIG_NETMASK)" >> $@
	@echo hostname="$(CONFIG_CONFIGNAME)" >> $@
	@echo router="$(CONFIG_GATEWAY)" >> $@
	@echo dns="$(CONFIG_NAMESERVER1)" "$(CONFIG_NAMESERVER2)" >> $@
etc/init.d/inetconfig: copy=$(srctree)/$(src)/inetscripts/inetconfig
etc/init.d/inetconfig: chmod:=744
etc/init.d/inetserverconfig: copy=$(srctree)/$(src)/inetscripts/inetserverconfig
etc/init.d/inetserverconfig: chmod:=744

install-$(CONFIG_TMPFS)+=etc/hosts etc/resolv.conf
etc/hosts: link=../tmp/hosts
etc/resolv.conf: link=../tmp/resolv.conf
