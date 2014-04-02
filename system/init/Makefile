
install-$(CONFIG_INITTAB)+=etc/inittab
etc/inittab: copy:=$(src)/config/$(CONFIG_INITTAB_FILE:"%"=%)
etc/inittab: $(src)/config/$(CONFIG_INITTAB_FILE:"%"=%)

install-$(CONFIG_RCS_FILE)+=etc/init.d/rcS
etc/init.d/rcS: copy:=$(src)/$(CONFIG_RCS_FILENAME:"%"=%)
#etc/init.d/rcS: chown:=root
etc/init.d/rcS: chmod:=744
etc/init.d/rcS: $(src)/$(CONFIG_RCS_FILENAME:"%"=%)

install-$(CONFIG_TMPFS)+=etc/init.d/fsconfig
etc/init.d/fsconfig: copy=$(src)/imrscripts/fsconfig
etc/init.d/fsconfig: chmod:=744

install-$(CONFIG_INIT_MAKEROOT)+=etc/init.d/modprobe
etc/init.d/modprobe: copy=$(src)/imrscripts/modprobe
etc/init.d/modprobe: chmod:=744

install-$(CONFIG_SERVER_RCP)+=etc/init.d/portmap
etc/init.d/portmap: copy=$(src)/imrscripts/portmap
etc/init.d/portmap: chmod:=744

install-$(CONFIG_SERVER_NFS)+=etc/init.d/nfsd
etc/init.d/nfsd: copy=$(src)/imrscripts/nfsd
etc/init.d/nfsd: chmod:=744

install-$(CONFIG_SERVER_USHARE)+=etc/init.d/ushare
etc/init.d/ushare: copy=$(src)/imrscripts/ushare
etc/init.d/ushare: chmod:=744

install-$(CONFIG_SERVER_PROFTPD)+=etc/init.d/proftpd
etc/init.d/proftpd: copy=$(src)/imrscripts/proftpd
etc/init.d/proftpd: chmod:=744

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
install-$(CONFIG_INIT_MR_PROFTPD)+=etc/rc.d/22_proftpd.rc
etc/rc.d/22_proftpd.rc: link=../init.d/proftpd
install-$(CONFIG_INIT_MR_RPC)+=etc/rc.d/20_portmap.rc
etc/rc.d/20_portmap.rc: link=../init.d/portmap
install-$(CONFIG_INIT_MR_NFSD)+=etc/rc.d/21_nfsd.rc
etc/rc.d/21_nfsd.rc: link=../init.d/nfsd
install-$(CONFIG_INIT_MR_USHARE)+=etc/rc.d/22_ushare.rc
etc/rc.d/22_ushare.rc: link=../init.d/ushare

install-$(CONFIG_INIT_LSB)+=lib/lsb/init-functions 
lib/lsb/init-functions: copy=$(src)/lib/lsb/init-functions
