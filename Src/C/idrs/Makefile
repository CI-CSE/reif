TOP = ..
DIR = \ 
OUTDIR= .
INDIR= .
OUTPUT_CMD= -Fo
CC = cl
JCFLAGS = -W4 -D_CRT_SECURE_NO_DEPRECATE -D_CRT_NONSTDC_NO_DEPRECATE -wd4055 -wd4054 -wd4100 -wd4702 -wd4706 -wd4510 -wd4512 -wd4610  -nologo -MT -D_WIN32_WINNT=0x0500 -DWINVER=0x0500 -DWIN32_LEAN_AND_MEAN -I$(TOP)$(DIR)run-time -I$(TOP)$(DIR)ipc$(DIR)shared -O2 -GS- -I$(TOP)
JMTCFLAGS = -W4 -D_CRT_SECURE_NO_DEPRECATE -D_CRT_NONSTDC_NO_DEPRECATE -wd4055 -wd4054 -wd4100 -wd4702 -wd4706 -wd4510 -wd4512 -wd4610  -nologo -MT -D_WIN32_WINNT=0x0500 -DWINVER=0x0500 -DWIN32_LEAN_AND_MEAN -DEIF_THREADS -I$(TOP)$(DIR)run-time -I$(TOP)$(DIR)ipc$(DIR)shared -O2 -GS- -I$(TOP)

OBJECTS = \
	idrs.obj

MT_OBJECTS = \
	MTidrs.obj

.c.obj:
	$(CC) -c $(JCFLAGS) $<

all:: standard mtstandard

dll: standard
mtdll: mtstandard
standard:: idrs.obj
mtstandard:: MTidrs.obj

MTidrs.obj: idrs.c
	$(CC) $(JMTCFLAGS) $(OUTPUT_CMD)$@ -c $?

