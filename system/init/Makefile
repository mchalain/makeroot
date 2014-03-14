
install-$(CONFIG_INITTAB)+=etc/inittab
etc/inittab: copy:=$(srctree)/$(src)/config/$(CONFIG_INITTAB_FILE:"%"=%)
etc/inittab: $(srctree)/$(src)/config/$(CONFIG_INITTAB_FILE:"%"=%)

install-$(CONFIG_RCS_FILE)+=etc/init.d/rcS
etc/init.d/rcS: copy:=$(srctree)/$(src)/$(CONFIG_RCS_FILENAME:"%"=%)
#etc/init.d/rcS: chown:=root
etc/init.d/rcS: chmod:=744
etc/init.d/rcS: $(srctree)/$(src)/$(CONFIG_RCS_FILENAME:"%"=%)

install-$(CONFIG_TMPFS)+=etc/init.d/fsconfig
etc/init.d/fsconfig: copy=$(srctree)/$(src)/imrscripts/fsconfig
etc/init.d/fsconfig: chmod:=744

install-$(INIT_MAKEROOT)+=etc/init.d/modprobe
etc/init.d/modprobe: copy=$(srctree)/$(src)/imrscripts/modprobe
etc/init.d/modprobe: chmod:=744

install-$(SERVER_RCP)+=etc/init.d/portmap
etc/init.d/portmap: copy=$(srctree)/$(src)/imrscripts/portmap
etc/init.d/portmap: chmod:=744

install-$(SERVER_NFS)+=etc/init.d/nfsdconfig
etc/init.d/nfsdconfig: copy=$(srctree)/$(src)/imrscripts/nfsdconfig
etc/init.d/nfsdconfig: chmod:=744

install-$(CONFIG_INIT_MR_TREE)+=etc/rc.d/01_tree.rc
etc/rc.d/01_tree.rc: link=../init.d/fsconfig
install-$(CONFIG_INIT_MR_UDEVD)+=etc/rc.d/03_udevd.rc
etc/rc.d/03_udevd.rc: link=../../usr/sbin/udevd
install-$(CONFIG_INIT_MR_NETWORK)+=etc/rc.d/05_inet.rc
etc/rc.d/05_inet.rc: link=../init.d/inetconfig
install-$(CONFIG_INIT_MR_TELNET)+=etc/rc.d/20_telnetd.rc
etc/rc.d/20_telnetd.rc: link=../init.d/inetserverconfig
install-$(CONFIG_INIT_MR_FTPD)+=etc/rc.d/20_ftpd.rc
etc/rc.d/20_ftpd.rc: link=../init.d/inetserverconfig
install-$(CONFIG_INIT_MR_HTTPD)+=etc/rc.d/20_httpd.rc
etc/rc.d/20_httpd.rc: link=../init.d/inetserverconfig
install-$(CONFIG_INIT_MR_NTPD)+=etc/rc.d/20_ntpd.rc
etc/rc.d/20_ntpd.rc: link=../init.d/inetserverconfig

install-$(CONFIG_INIT_LSB)+=lib/lsb/init-functions 
lib/lsb/init-functions: copy=$(srctree)/$(src)/lib/lsb/init-functions
