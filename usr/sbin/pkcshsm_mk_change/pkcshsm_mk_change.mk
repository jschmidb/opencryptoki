sbin_PROGRAMS += usr/sbin/pkcshsm_mk_change/pkcshsm_mk_change

usr_sbin_pkcshsm_mk_change_pkcshsm_mk_change_LDFLAGS = -lcrypto -ldl -lrt

if AIX
usr_sbin_pkcshsm_mk_change_pkcshsm_mk_change_LDFLAGS += -lbsd -Wl,-blibpath:$(libdir)/opencryptoki:$(libdir)/opencryptoki/stdll:/usr/lib:/usr/lib64
endif

usr_sbin_pkcshsm_mk_change_pkcshsm_mk_change_CFLAGS  =	\
	-DOCK_TOOL					\
	-DSTDLL_NAME=\"pkcshsm_mk_change\"		\
	-I${srcdir}/usr/include				\
	-I${srcdir}/usr/lib/common			\
	-I${srcdir}/usr/lib/api				\
	-I${top_builddir}/usr/lib/api			\
	-I${srcdir}/usr/lib/hsm_mk_change

usr_sbin_pkcshsm_mk_change_pkcshsm_mk_change_SOURCES =	\
	usr/sbin/pkcshsm_mk_change/pkcshsm_mk_change.c	\
	usr/lib/common/p11util.c			\
	usr/lib/common/pkcs_utils.c			\
	usr/lib/common/event_client.c			\
	usr/lib/common/pin_prompt.c			\
	usr/lib/hsm_mk_change/hsm_mk_change.c

if AIX
usr_sbin_pkcshsm_mk_change_pkcshsm_mk_change_SOURCES += \
	usr/lib/common/aix/err.c usr/lib/common/aix/getopt_long.c
endif
