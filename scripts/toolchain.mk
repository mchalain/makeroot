TOOLCHAINDIR=$(CONFIG_TOOLCHAIN:"%"=%)
SYSROOT=
PATH:=$(PATH):$(TOOLCHAINDIR)/bin/
export PATH

#-L$(SYSROOT) -v -march=armv5te -funwind-tables
# /opt/codesourcery/libexec/gcc/arm-none-linux-gnueabi/4.4.1/collect2
# --sysroot=$(SYSROOT) --eh-frame-hdr -dynamic-linker /lib/ld-linux.so.3 -X -m armelf_linux_eabi $(SYSROOT)/usr/lib/crt1.o $(SYSROOT)/usr/lib/crti.o /opt/codesourcery/lib/gcc/arm-none-linux-gnueabi/4.4.1/crtbegin.o -L/usr/arm-unknown-linux-gnueabi/usr/lib -L/opt/codesourcery/lib/gcc/arm-none-linux-gnueabi/4.4.1 -L/opt/codesourcery/lib/gcc/arm-none-linux-gnueabi/4.4.1/../../../../arm-none-linux-gnueabi/lib -L/opt/codesourcery/arm-none-linux-gnueabi/libc/lib -L/opt/codesourcery/arm-none-linux-gnueabi/libc/usr/lib /tmp/ccQTJKJd.o -verbose -lgcc --as-needed -lgcc_s --no-as-needed -lc -lgcc --as-needed -lgcc_s --no-as-needed /opt/codesourcery/lib/gcc/arm-none-linux-gnueabi/4.4.1/crtend.o /opt/codesourcery/arm-none-linux-gnueabi/libc/usr/lib/crtn.o

$(toolchain-y):
	$(if $(wildcard $(src)/$@), ,$(call cmd,download-project))