TOP = ..$(DIR)..
DIR = \ 
OUTDIR = .
INDIR = .
CC = cl
OUTPUT_CMD = -Fo
RUN_TIME = $(TOP)$(DIR)run-time
CFLAGS = -I$(TOP) -I$(LIBDIR) -I$(RUN_TIME) -I$(RUN_TIME)$(DIR)include -I$(TOP)$(DIR)console -I$(LIBIDR)
JCFLAGS = $(CFLAGS) -W4 -D_CRT_SECURE_NO_DEPRECATE -D_CRT_NONSTDC_NO_DEPRECATE -wd4055 -wd4054 -wd4100 -wd4702 -wd4706 -wd4510 -wd4512 -wd4610  -nologo -MT -D_WIN32_WINNT=0x0500 -DWINVER=0x0500 -DWIN32_LEAN_AND_MEAN -O2 -GS- -DEIF_IPC
JMTCFLAGS = $(CFLAGS) -W4 -D_CRT_SECURE_NO_DEPRECATE -D_CRT_NONSTDC_NO_DEPRECATE -wd4055 -wd4054 -wd4100 -wd4702 -wd4706 -wd4510 -wd4512 -wd4610  -nologo -MT -D_WIN32_WINNT=0x0500 -DWINVER=0x0500 -DWIN32_LEAN_AND_MEAN -DEIF_THREADS -O2 -GS- -DEIF_IPC
MAKE = nmake -nologo

# Where shared archive is located (path and name)
LIBDIR = ..$(DIR)shared
LIBIDR = $(TOP)$(DIR)idrs

# Files used to build the ewb
SRC = ewb_proto.c eproto.c eif_in.c eif_out.c ewb_transfer.c ewb_init.c ewb_dumped.c ewb_child.c

# Derived object file names
OBJECTS = \
	ewb_proto.obj \
	ewb_dumped.obj \
	eproto.obj \
	eif_in.obj \
	eif_out.obj \
	ewb_child.obj \
	ewb_transfer.obj \
	ewb_init.obj

WOBJECTS = \
	wewb_dumped.obj \
	wewb_proto.obj \
	weproto.obj \
	weif_in.obj \
	weif_out.obj \
	wewb_child.obj \
	wewb_transfer.obj \
	wewb_init.obj

MT_OBJECTS = \
	MTewb_proto.obj \
	MTewb_dumped.obj \
	MTeproto.obj \
	MTeif_in.obj \
	MTeif_out.obj \
	MTewb_child.obj \
	MTewb_transfer.obj \
	MTewb_init.obj

MT_WOBJECTS = \
	MTwewb_dumped.obj \
	MTwewb_proto.obj \
	MTweproto.obj \
	MTweif_in.obj \
	MTweif_out.obj \
	MTwewb_child.obj \
	MTwewb_transfer.obj \
	MTwewb_init.obj

.c.obj:
	$(CC) -c $(JCFLAGS) $<

all:: standard mtstandard wewb_proto.obj MTwewb_proto.obj

dll: standard
mtdll: mtstandard
standard: ewb.lib wewb.lib
mtstandard: mtewb.lib mtwewb.lib

ewb.lib: $(OBJECTS)
	lib -OUT:$@ $**

mtewb.lib: $(MT_OBJECTS)
	lib -OUT:$@ $**

wewb.lib: $(WOBJECTS)
	lib -OUT:$@ $**

mtwewb.lib: $(MT_WOBJECTS)
	lib -OUT:$@ $**

wewb_dumped.obj: ewb_dumped.c
	$(CC) $(JCFLAGS) -DWORKBENCH $(OUTPUT_CMD)$@ -c $? 

wewb_proto.obj: ewb_proto.c
	$(CC) $(JCFLAGS) -DWORKBENCH $(OUTPUT_CMD)$@ -c $? 

wewb_init.obj: ewb_init.c
	$(CC) $(JCFLAGS) -DWORKBENCH $(OUTPUT_CMD)$@ -c $? 

wewb_transfer.obj: ewb_transfer.c
	$(CC) $(JCFLAGS) -DWORKBENCH $(OUTPUT_CMD)$@ -c $? 

wewb_child.obj: ewb_child.c
	$(CC) $(JCFLAGS) -DWORKBENCH $(OUTPUT_CMD)$@ -c $? 

weproto.obj: eproto.c
	$(CC) $(JCFLAGS) -DWORKBENCH $(OUTPUT_CMD)$@ -c $? 

weif_in.obj: eif_in.c
	$(CC) $(JCFLAGS) -DWORKBENCH $(OUTPUT_CMD)$@ -c $? 

weif_out.obj: eif_out.c
	$(CC) $(JCFLAGS) -DWORKBENCH $(OUTPUT_CMD)$@ -c $? 


MTewb_dumped.obj: ewb_dumped.c
	$(CC) $(JMTCFLAGS) $(OUTPUT_CMD)$@ -c $? 

MTewb_proto.obj: ewb_proto.c
	$(CC) $(JMTCFLAGS) $(OUTPUT_CMD)$@ -c $? 

MTewb_init.obj: ewb_init.c
	$(CC) $(JMTCFLAGS) $(OUTPUT_CMD)$@ -c $? 

MTewb_transfer.obj: ewb_transfer.c
	$(CC) $(JMTCFLAGS) $(OUTPUT_CMD)$@ -c $? 

MTewb_child.obj: ewb_child.c
	$(CC) $(JMTCFLAGS) $(OUTPUT_CMD)$@ -c $? 

MTeproto.obj: eproto.c
	$(CC) $(JMTCFLAGS) $(OUTPUT_CMD)$@ -c $? 

MTeif_in.obj: eif_in.c
	$(CC) $(JMTCFLAGS) $(OUTPUT_CMD)$@ -c $? 

MTeif_out.obj: eif_out.c
	$(CC) $(JMTCFLAGS) $(OUTPUT_CMD)$@ -c $? 


MTwewb_dumped.obj: ewb_dumped.c
	$(CC) $(JMTCFLAGS) -DWORKBENCH $(OUTPUT_CMD)$@ -c $? 

MTwewb_proto.obj: ewb_proto.c
	$(CC) $(JMTCFLAGS) -DWORKBENCH $(OUTPUT_CMD)$@ -c $? 

MTwewb_init.obj: ewb_init.c
	$(CC) $(JMTCFLAGS) -DWORKBENCH $(OUTPUT_CMD)$@ -c $? 

MTwewb_transfer.obj: ewb_transfer.c
	$(CC) $(JMTCFLAGS) -DWORKBENCH $(OUTPUT_CMD)$@ -c $? 

MTwewb_child.obj: ewb_child.c
	$(CC) $(JMTCFLAGS) -DWORKBENCH $(OUTPUT_CMD)$@ -c $? 

MTweproto.obj: eproto.c
	$(CC) $(JMTCFLAGS) -DWORKBENCH $(OUTPUT_CMD)$@ -c $? 

MTweif_in.obj: eif_in.c
	$(CC) $(JMTCFLAGS) -DWORKBENCH $(OUTPUT_CMD)$@ -c $? 

MTweif_out.obj: eif_out.c
	$(CC) $(JMTCFLAGS) -DWORKBENCH $(OUTPUT_CMD)$@ -c $? 


