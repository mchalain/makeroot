#-L$(sysroot) -v -march=armv5te -funwind-tables
# /opt/codesourcery/libexec/gcc/arm-none-linux-gnueabi/4.4.1/collect2
#toolchain_path=/opt/codesourcery
#libgcc_path=$(toolchain_path)/lib/gcc/arm-none-linux-gnueabi/4.4.1
#crtend=$(libgcc_path)/crtend.o
#crtbegin=$(libgcc_path)/crtbegin.o
#crtn=$(sysroot)/usr/lib/crtn.o
#crt1=$(sysroot)/usr/lib/crt1.o
#crti=$(sysroot)/usr/lib/crti.o
#dynamic_linker=-dynamic-linker /lib/ld-linux.so.3
# --sysroot=$(sysroot) --eh-frame-hdr $(dynamic_linker) -X -m armelf_linux_eabi $(crt1) $(crti) $(crtbegin) -L$(libgcc_path) /tmp/ccQTJKJd.o -verbose -lgcc --as-needed -lgcc_s --no-as-needed -lc $(crtend) $(crtn)

$(toolchain-y): $(hostobjtree)/toolchain

$(hostobjtree):
	mkdir -p $@

$(hostobjtree)/toolchain: $(hostobjtree)
	@$(eval install-target = $@) \
	$(eval tc=$(toolchain-y)) \
	$(eval link = $(addprefix $(srctree)/$(src)/,$(tc)$(if $($(notdir $(tc))-version),-$($(notdir $(tc))-version:"%"=%)))) \
	$(if $(wildcard $(install-target)), , $(if $(wildcard $(link)), $(call cmd,link)))
