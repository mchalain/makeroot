sysroot=$(objtree)
PATH:=$(PATH):$(join $(hostobjtree), bin):$(join $(hostobjtree), toolchain/bin)
float-abi=soft
arch=armv4t
#CROSS_COMPILE:= defined in $(src)/Makefile
CFLAGS:=--sysroot=$(sysroot) $(if $(filter armv4t,$(SUBARCH)), -marm -march=$(arch) -mfloat-abi=$(float-abi))
LDFLAGS:=--sysroot=$(sysroot) -Wl,-rpath=$(sysroot)/lib
export PATH CFLAGS LDFLAGS

#-L$(sysroot) -v -march=armv5te -funwind-tables
# /opt/codesourcery/libexec/gcc/arm-none-linux-gnueabi/4.4.1/collect2
# --sysroot=$(sysroot) --eh-frame-hdr -dynamic-linker /lib/ld-linux.so.3 -X -m armelf_linux_eabi $(SYSROOT)/usr/lib/crt1.o $(SYSROOT)/usr/lib/crti.o /opt/codesourcery/lib/gcc/arm-none-linux-gnueabi/4.4.1/crtbegin.o -L/usr/arm-unknown-linux-gnueabi/usr/lib -L/opt/codesourcery/lib/gcc/arm-none-linux-gnueabi/4.4.1 -L/opt/codesourcery/lib/gcc/arm-none-linux-gnueabi/4.4.1/../../../../arm-none-linux-gnueabi/lib -L/opt/codesourcery/arm-none-linux-gnueabi/libc/lib -L/opt/codesourcery/arm-none-linux-gnueabi/libc/usr/lib /tmp/ccQTJKJd.o -verbose -lgcc --as-needed -lgcc_s --no-as-needed -lc -lgcc --as-needed -lgcc_s --no-as-needed /opt/codesourcery/lib/gcc/arm-none-linux-gnueabi/4.4.1/crtend.o /opt/codesourcery/arm-none-linux-gnueabi/libc/usr/lib/crtn.o

$(toolchain-y): $(hostobjtree)/toolchain

$(hostobjtree):
	mkdir -p $@

$(hostobjtree)/toolchain: $(hostobjtree)
	$(eval install-target = $@) \
	$(eval tc=$(toolchain-y)) \
	$(eval link = $(addprefix $(srctree)/$(src)/,$(tc)$(if $($(notdir $(tc))-version),-$($(notdir $(tc))-version:"%"=%)))) \
	$(if $(wildcard $(install-target)), , $(if $(wildcard $(link)), $(call cmd,link)))
