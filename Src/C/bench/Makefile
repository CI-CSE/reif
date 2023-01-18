TOP = ..
DIR = \ 
OUTDIR = .$(DIR)LIB
INDIR = .$(DIR)OBJDIR
RTSRC = .
CC = cl
LIB_EXE = lib_exe
MAKE = nmake -nologo
LINK32 = link
DLLFLAGS = $dllflags
OUTPUT_CMD = -Fo
CFLAGS = -I. -I$(TOP) -I$(TOP)$(DIR)run-time -I$(TOP)$(DIR)run-time$(DIR)include -I$(TOP)$(DIR)minilzo -I$(TOP)$(DIR)idrs
JCFLAGS = $(CFLAGS) -W4 -D_CRT_SECURE_NO_DEPRECATE -D_CRT_NONSTDC_NO_DEPRECATE -wd4055 -wd4054 -wd4100 -wd4702 -wd4706 -wd4510 -wd4512 -wd4610  -nologo -MT -D_WIN32_WINNT=0x0500 -DWINVER=0x0500 -DWIN32_LEAN_AND_MEAN -O2 -GS-
JMTCFLAGS = $(CFLAGS) -W4 -D_CRT_SECURE_NO_DEPRECATE -D_CRT_NONSTDC_NO_DEPRECATE -wd4055 -wd4054 -wd4100 -wd4702 -wd4706 -wd4510 -wd4512 -wd4610  -nologo -MT -D_WIN32_WINNT=0x0500 -DWINVER=0x0500 -DWIN32_LEAN_AND_MEAN -DEIF_THREADS -O2 -GS-

.c.obj:
	$(CC) -c $(JCFLAGS) $<

.c.exe:
	$(CC) $(JCFLAGS) $<

OBJECTS = pretrieve.obj pstore.obj \
			byte.obj minilzo.obj

WOBJECTS = pretrieve.obj wpstore.obj \
			byte.obj minilzo.obj

MT_OBJECTS = MTpretrieve.obj MTpstore.obj \
			MTbyte.obj MTminilzo.obj

MT_WOBJECTS = MTwpretrieve.obj MTwpstore.obj \
			MTbyte.obj MTminilzo.obj

all:: standard mtstandard

dll: standard
mtdll: mtstandard
standard: compiler.lib wcompiler.lib meltdump.exe bytedump.exe
mtstandard: mtcompiler.lib mtwcompiler.lib meltdump.exe bytedump.exe

meltdump.exe: ..$(DIR)run-time$(DIR)eif_interp.h
bytedump.exe: ..$(DIR)run-time$(DIR)eif_interp.h

compiler.lib: $(OBJECTS)
	lib -OUT:$@ $**

wcompiler.lib: $(WOBJECTS)
	lib -OUT:$@ $**

mtcompiler.lib: $(MT_OBJECTS)
	lib -OUT:$@ $**

mtwcompiler.lib: $(MT_WOBJECTS)
	lib -OUT:$@ $**

wpstore.obj: pstore.c
	$(CC) $(JCFLAGS) -DWORKBENCH $(OUTPUT_CMD)$@ -c $?

MTpretrieve.obj: pretrieve.c
	$(CC) $(JMTCFLAGS) $(OUTPUT_CMD)$@ -c $? 

MTbyte.obj: byte.c
	$(CC) $(JMTCFLAGS) $(OUTPUT_CMD)$@ -c $? 

MTpstore.obj: pstore.c
	$(CC) $(JMTCFLAGS) $(OUTPUT_CMD)$@ -c $? 

MTwpstore.obj: pstore.c
	$(CC) $(JMTCFLAGS) -DWORKBENCH $(OUTPUT_CMD)$@ -c $? 

MTwpretrieve.obj: pretrieve.c
	$(CC) $(JMTCFLAGS) -DWORKBENCH $(OUTPUT_CMD)$@ -c $? 

MTminilzo.obj: minilzo.c
	$(CC) $(JMTCFLAGS) $(OUTPUT_CMD)$@ -c $? 


