TOP = ..
DIR = \ 
OUTDIR = .
INDIR = .
CC = cl
OUTPUT_CMD = -Fo
JCFLAGS = $(CFLAGS) -W4 -D_CRT_SECURE_NO_DEPRECATE -D_CRT_NONSTDC_NO_DEPRECATE -wd4055 -wd4054 -wd4100 -wd4702 -wd4706 -wd4510 -wd4512 -wd4610  -nologo -MT -D_WIN32_WINNT=0x0500 -DWINVER=0x0500 -DWIN32_LEAN_AND_MEAN -O2 -GS-
JMTCFLAGS = $(CFLAGS) -W4 -D_CRT_SECURE_NO_DEPRECATE -D_CRT_NONSTDC_NO_DEPRECATE -wd4055 -wd4054 -wd4100 -wd4702 -wd4706 -wd4510 -wd4512 -wd4610  -nologo -MT -D_WIN32_WINNT=0x0500 -DWINVER=0x0500 -DWIN32_LEAN_AND_MEAN -DEIF_THREADS -O2 -GS-
CFLAGS = -I$(TOP) -I$(TOP)$(DIR)run-time -I$(TOP)$(DIR)run-time$(DIR)include -I$(TOP)$(DIR)ipc$(DIR)shared
MAKE = nmake -nologo

OBJECTS = names.obj commands.obj

MT_OBJECTS = MTnames.obj MTcommands.obj

.c.obj:
	$(CC) -c $(JCFLAGS) $<

all:: standard mtstandard

dll: standard
mtdll: mtstandard
standard: platform.lib
mtstandard: mtplatform.lib

platform.lib: $(OBJECTS)
	lib -OUT:$@ $**

mtplatform.lib: $(MT_OBJECTS)
	lib -OUT:$@ $**

MTnames.obj: names.c
	$(CC) $(JMTCFLAGS) $(OUTPUT_CMD)$@ -c $? 

MTcommands.obj: commands.c
	$(CC) $(JMTCFLAGS) $(OUTPUT_CMD)$@ -c $? 
