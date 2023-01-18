TOP = ..
DIR = \ 
OUTDIR= .
INDIR= .
CC = cl
OUTPUT_CMD = -Fo
CFLAGS = -I$(TOP)$(DIR)run-time -I$(TOP)$(DIR)run-time$(DIR)include -I$(TOP) -I$(TOP)$(DIR)ipc$(DIR)app -I$(TOP)$(DIR)idrs
DPFLAGS = -I$(TOP)
JCFLAGS = $(CFLAGS) -W4 -D_CRT_SECURE_NO_DEPRECATE -D_CRT_NONSTDC_NO_DEPRECATE -wd4055 -wd4054 -wd4100 -wd4702 -wd4706 -wd4510 -wd4512 -wd4610  -nologo -MT -D_WIN32_WINNT=0x0500 -DWINVER=0x0500 -DWIN32_LEAN_AND_MEAN -O2 -GS-
JMTCFLAGS = $(CFLAGS) -W4 -D_CRT_SECURE_NO_DEPRECATE -D_CRT_NONSTDC_NO_DEPRECATE -wd4055 -wd4054 -wd4100 -wd4702 -wd4706 -wd4510 -wd4512 -wd4610  -nologo -MT -D_WIN32_WINNT=0x0500 -DWINVER=0x0500 -DWIN32_LEAN_AND_MEAN -DEIF_THREADS -O2 -GS-
OBJECTS = argcargv.obj econsole.obj
MT_OBJECTS = MTargcargv.obj MTeconsole.obj
WOBJECTS = argcargv.obj weconsole.obj
MT_WOBJECTS = MTargcargv.obj MTweconsole.obj

.c.obj:
	$(CC) -c $(JCFLAGS) $<

all:: standard mtstandard

dll: standard
mtdll: mtstandard
standard:: winconsole.lib wwinconsole.lib
mtstandard:: mtwinconsole.lib mtwwinconsole.lib

winconsole.lib: $(OBJECTS)
	lib -OUT:$@ $**

mtwinconsole.lib: $(MT_OBJECTS)
	lib -OUT:$@ $**

wwinconsole.lib: $(WOBJECTS)
	lib -OUT:$@ $**

mtwwinconsole.lib: $(MT_WOBJECTS)
	lib -OUT:$@ $**

weconsole.obj: econsole.c
	$(CC) $(JCFLAGS) -DWORKBENCH $(OUTPUT_CMD)$@ -c $?

MTargcargv.obj: argcargv.c
	$(CC) $(JMTCFLAGS) $(OUTPUT_CMD)$@ -c $?

MTeconsole.obj: econsole.c
	$(CC) $(JMTCFLAGS) $(OUTPUT_CMD)$@ -c $?

MTweconsole.obj: econsole.c
	$(CC) $(JMTCFLAGS) -DWORKBENCH $(OUTPUT_CMD)$@ -c $?
