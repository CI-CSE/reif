TOP = ..$(DIR)..
DIR = \ 
OUTDIR = .
INDIR = .
CC = cl
OUTPUT_CMD = -Fo
CFLAGS = -I$(TOP) -I..$(DIR)shared -I$(LIBRUN) -I$(LIBIDR) -I$(LIBRUN)$(DIR)include
JCFLAGS = $(CFLAGS) -W4 -D_CRT_SECURE_NO_DEPRECATE -D_CRT_NONSTDC_NO_DEPRECATE -wd4055 -wd4054 -wd4100 -wd4702 -wd4706 -wd4510 -wd4512 -wd4610  -nologo -MT -D_WIN32_WINNT=0x0500 -DWINVER=0x0500 -DWIN32_LEAN_AND_MEAN -O2 -GS- -DWORKBENCH -DEIF_IPC
JMTCFLAGS = $(CFLAGS) -W4 -D_CRT_SECURE_NO_DEPRECATE -D_CRT_NONSTDC_NO_DEPRECATE -wd4055 -wd4054 -wd4100 -wd4702 -wd4706 -wd4510 -wd4512 -wd4610  -nologo -MT -D_WIN32_WINNT=0x0500 -DWINVER=0x0500 -DWIN32_LEAN_AND_MEAN -DEIF_THREADS -O2 -GS- -DWORKBENCH -DEIF_IPC
MAKE = nmake -nologo
# Where shared archive is located (path and name)
LIBDIR = ..$(DIR)shared
LIBRUN = $(TOP)$(DIR)run-time
LIBIDR = $(TOP)$(DIR)idrs
LIBNAME = ipc.lib
LIBMTNAME = mtipc.lib

.c.obj:
	$(CC) -c $(JCFLAGS) $<

# Derived library object file names
OBJECTS = \
	app_listen.obj \
	app_proto.obj \
	app_server.obj \
	app_transfer.obj \
	$(LIBDIR)$(DIR)$(LIBNAME)

MT_OBJECTS = \
	MTapp_listen.obj \
	MTapp_proto.obj \
	MTapp_server.obj \
	MTapp_transfer.obj \
	$(LIBDIR)$(DIR)$(LIBMTNAME)

all:: standard mtstandard

dll: standard
mtdll: mtstandard
standard: network.lib
mtstandard: mtnetwork.lib

network.lib: $(OBJECTS) $(LIBDIR)$(DIR)$(LIBNAME)
	lib -OUT:$@ $**

mtnetwork.lib: $(MT_OBJECTS) $(LIBDIR)$(DIR)$(LIBMTNAME)
	lib -OUT:$@ $**

MTapp_listen.obj: app_listen.c
	$(CC) $(JMTCFLAGS) $(OUTPUT_CMD)$@ -c $? 

MTapp_proto.obj: app_proto.c
	$(CC) $(JMTCFLAGS) $(OUTPUT_CMD)$@ -c $? 

MTapp_server.obj: app_server.c
	$(CC) $(JMTCFLAGS) $(OUTPUT_CMD)$@ -c $? 

MTapp_transfer.obj: app_transfer.c
	$(CC) $(JMTCFLAGS) $(OUTPUT_CMD)$@ -c $? 

