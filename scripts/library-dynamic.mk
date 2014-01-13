
cobjs:= $(sort $(foreach m,$(lib-y),$($(m)-objs)))

cshlib	:= $(sort $(filter %.so, $(cobjs)))
cshobjs	:= $(sort $(foreach m,$(cshlib),$($(m:.so=-objs))))
cshobjs		:= $(addprefix $(obj)/,$(cshobjs))

# Create .o file from a multi .c file
# host-cobjs -> .o
quiet_cmd_cshobjs	= CC  $@
      cmd_cshobjs	= CFLAGS= \
		$(CC) $(c_flags) -fPIC -c -o $@ $<
$(cshobjs): $(objdirs)
$(cshobjs): $(obj)/%.o: $(src)/%.c
	$(call if_changed_dep,cshobjs)

# Link Shared Library
# ---------------------------------------------------------------------------
quiet_cmd_link_so_target = LDSO     $@
cmd_link_so_target = $(LD) $(LDFLAGS) $(EXTRA_LDFLAGS) $(LDFLAGS_$(@F)) \
		-shared -o $@ \
		$(addprefix $(obj)/,$(filter %.o, $($(@F:.so=-objs)))) \
		$(filter -l%, $($(@F:.so=-objs)))


$(cshlib): $(cshobjs) FORCE
	$(call if_changed,link_so_target)

