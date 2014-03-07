WLD:=/usr

include $(CONFIG)

all: configure

.PHONY+=clean
clean: FORCE
	$(MAKE) clean


.PHONY+=build
build: FORCE
	$(MAKE)  CC=$(CROSS_COMPILE:%-=%)-gcc

FORCE:;
