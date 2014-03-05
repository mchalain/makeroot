
install-$(CONFIG_INITTAB)+=etc/inittab
etc/inittab: copy:=$(srctree)/$(src)/config/$(CONFIG_INITTAB_FILE:"%"=%)
etc/inittab: $(srctree)/$(src)/config/$(CONFIG_INITTAB_FILE:"%"=%)

install-$(CONFIG_INIT_SYSTEMV)+=etc/init.d/rcS
etc/init.d/rcS: copy:=$(srctree)/$(src)/config/$(CONFIG_RCS_FILE:"%"=%)
#etc/init.d/rcS: chown:=root
etc/init.d/rcS: chmod:=744
etc/init.d/rcS: $(srctree)/$(src)/config/$(CONFIG_RCS_FILE:"%"=%)

install-$(CONFIG_INIT_LSB)+=lib/lsb/init-functions 
lib/lsb/init-functions: copy=$(srctree)/$(src)/lib/lsb/init-functions
