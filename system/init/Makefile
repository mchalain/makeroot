
install-$(CONFIG_INITTAB)+=$(CONFIGDIR)/inittab
$(CONFIGDIR)/inittab: copy:=$(src)/config/$(CONFIG_INITTAB_FILE:"%"=%)
$(CONFIGDIR)/inittab: $(src)/config/$(CONFIG_INITTAB_FILE:"%"=%)

install-$(CONFIG_RCS_FILE)+=$(CONFIGDIR)/init.d/rcS
$(CONFIGDIR)/init.d/rcS: copy:=$(src)/$(CONFIG_RCS_FILENAME:"%"=%)
#$(CONFIGDIR)/init.d/rcS: chown:=root
$(CONFIGDIR)/init.d/rcS: chmod:=744
$(CONFIGDIR)/init.d/rcS: $(src)/$(CONFIG_RCS_FILENAME:"%"=%)

install-$(CONFIG_TMPFS)+=$(CONFIGDIR)/init.d/fsconfig
$(CONFIGDIR)/init.d/fsconfig: copy=$(src)/imrscripts/fsconfig
$(CONFIGDIR)/init.d/fsconfig: chmod:=744

install-$(CONFIG_INIT_MAKEROOT)+=$(CONFIGDIR)/init.d/modprobe
$(CONFIGDIR)/init.d/modprobe: copy=$(src)/imrscripts/modprobe
$(CONFIGDIR)/init.d/modprobe: chmod:=744

install-$(CONFIG_SERVER_RPC)+=$(CONFIGDIR)/init.d/portmap
$(CONFIGDIR)/init.d/portmap: copy=$(src)/imrscripts/portmap
$(CONFIGDIR)/init.d/portmap: chmod:=744

install-$(CONFIG_SERVER_NFS)+=$(CONFIGDIR)/init.d/nfsd
$(CONFIGDIR)/init.d/nfsd: copy=$(src)/imrscripts/nfsd
$(CONFIGDIR)/init.d/nfsd: chmod:=744

install-$(CONFIG_SERVER_USHARE_SP)+=$(CONFIGDIR)/init.d/ushare
$(CONFIGDIR)/init.d/ushare: copy=$(src)/imrscripts/ushare
$(CONFIGDIR)/init.d/ushare: chmod:=744

install-$(CONFIG_SERVER_PROFTP_SP)+=$(CONFIGDIR)/init.d/proftpd
$(CONFIGDIR)/init.d/proftpd: copy=$(src)/imrscripts/proftpd
$(CONFIGDIR)/init.d/proftpd: chmod:=744

install-$(CONFIG_SERVER_LIGHTTPD_SP)+=$(CONFIGDIR)/init.d/lighttpd
$(CONFIGDIR)/init.d/lighttpd: copy=$(src)/imrscripts/lighttpd
$(CONFIGDIR)/init.d/lighttpd: chmod:=744

install-$(CONFIG_INIT_MR_TREE)+=$(CONFIGDIR)/rc.d/01_tree.rc
$(CONFIGDIR)/rc.d/01_tree.rc: link=../init.d/fsconfig
install-$(CONFIG_INIT_MR_UDEVD)+=$(CONFIGDIR)/rc.d/03_udevd.rc
$(CONFIGDIR)/rc.d/03_udevd.rc: link=../../usr/sbin/udevd
install-$(CONFIG_INIT_MR_NETWORK)+=$(CONFIGDIR)/rc.d/05_inet.rc
$(CONFIGDIR)/rc.d/05_inet.rc: link=../init.d/inetconfig
install-$(CONFIG_INIT_MR_NETWORK)+=$(CONFIGDIR)/rc.d/15_inetcheck.rc
$(CONFIGDIR)/rc.d/05_inet.rc: copy=$(src)/imrscripts/15_inetcheck.rc
$(CONFIGDIR)/rc.d/05_inet.rc: chmod:=744
install-$(CONFIG_INIT_MR_TELNET)+=$(CONFIGDIR)/rc.d/20_telnetd.rc
$(CONFIGDIR)/rc.d/20_telnetd.rc: link=../init.d/inetserverconfig
install-$(CONFIG_INIT_MR_FTPD)+=$(CONFIGDIR)/rc.d/20_ftpd.rc
$(CONFIGDIR)/rc.d/20_ftpd.rc: link=../init.d/inetserverconfig
install-$(CONFIG_INIT_MR_HTTPD)+=$(CONFIGDIR)/rc.d/20_httpd.rc
$(CONFIGDIR)/rc.d/20_httpd.rc: link=../init.d/inetserverconfig
install-$(CONFIG_INIT_MR_NTPD)+=$(CONFIGDIR)/rc.d/20_ntpd.rc
$(CONFIGDIR)/rc.d/20_ntpd.rc: link=../init.d/inetserverconfig
install-$(CONFIG_INIT_MR_RPC)+=$(CONFIGDIR)/rc.d/20_portmap.rc
$(CONFIGDIR)/rc.d/20_portmap.rc: link=../init.d/portmap
install-$(CONFIG_INIT_MR_NFSD)+=$(CONFIGDIR)/rc.d/21_nfsd.rc
$(CONFIGDIR)/rc.d/21_nfsd.rc: link=../init.d/nfsd
install-$(CONFIG_INIT_MR_PROFTPD)+=$(CONFIGDIR)/rc.d/22_proftpd.rc
$(CONFIGDIR)/rc.d/22_proftpd.rc: link=../init.d/proftpd
install-$(CONFIG_INIT_MR_LIGHTTPD)+=$(CONFIGDIR)/rc.d/22_lighttpd.rc
$(CONFIGDIR)/rc.d/22_lighttpd.rc: link=../init.d/lighttpd
install-$(CONFIG_INIT_MR_USHARE)+=$(CONFIGDIR)/rc.d/22_ushare.rc
$(CONFIGDIR)/rc.d/22_ushare.rc: link=../init.d/ushare

install-$(CONFIG_INIT_LSB)+=lib/lsb/init-functions 
lib/lsb/init-functions: copy=$(src)/lib/lsb/init-functions
