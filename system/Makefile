#GCC build and link all applications with libgcc_s.so
pre-install-$(CONFIG_TOOLCHAIN_GCC)+=lib/libgcc_s.so lib/libgcc_s.so.1
lib/libgcc_s.so:copy:=$(toolchain_path)/$(CROSS_COMPILE:%-=%)/lib/libgcc_s.so
lib/libgcc_s.so:$(toolchain_path)/$(CROSS_COMPILE:%-=%)/lib/libgcc_s.so
lib/libgcc_s.so:install-sysroot:=y
lib/libgcc_s.so.1:copy:=$(toolchain_path)/$(CROSS_COMPILE:%-=%)/lib/libgcc_s.so.1
lib/libgcc_s.so.1:$(toolchain_path)/$(CROSS_COMPILE:%-=%)/lib/libgcc_s.so.1
lib/libgcc_s.so.1:install-sysroot:=y

subdir-y+=$(src)/tree $(src)/libc $(src)/base

subdir-y+=$(src)/framework/filecompressor
subdir-y+=$(src)/security

subdir-y+=$(src)/framework/fileparser
subdir-y+=$(src)/framework/ipc

subdir-y+=$(src)/database

subdir-y+=$(src)/lowlevel

subdir-y+=$(src)/framework

subdir-y+=$(src)/disk

subdir-y+=$(src)/multimedia

subdir-y+=$(src)/server

subdir-y+=$(src)/lowlevel/graphics

subdir-y+=$(src)/dev

subdir-y+=$(src)/init

