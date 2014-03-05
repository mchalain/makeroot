
quiet_cmd-link-lib-static = LINK $*
cmd-link-lib-static = \
	$(RM) $@ && \
	$(AR) -cvq $@ $^ && \
	$(RANLIB) $@

lib-objs:=$(sort $(foreach m, $(lib-y), $($(m)-objs)))

.SECONDEXPANSION:
$(lib-target): lib%.a: $$(%-objs)
	@$(call if_changed,link-lib-static)

FORCE:
