CC=gcc
LINKER=gcc
CFLAGS = -std=gnu11 -Wall
LDFLAGS = -lm -llolie

BINDIR=bin
OBJDIR=obj
SRCDIR=src
GENDIR=gen
OUT=tcalc

OUTPREFIX=
OUTPOSTFIX=
OBJPOSTFIX=
SRCPOSTFIX=.c

ifeq ($(OS),Windows_NT)
	OUTPOSTFIX=.exe
	OBJPOSTFIX=.obj
else
	UNAME_S := $(shell uname -s)
	ifneq "$(or ($(UNAME_S),Linux),($(UNAME_S),Darwin))" ""
		OBJPOSTFIX=.o
	endif
endif

vpath %$(SRCPOSTFIX) $(SRCDIR)
vpath %$(SRCPOSTFIX) $(GENDIR)

rwildcard=$(foreach d,$(wildcard $1*),$(call rwildcard,$d/,$2) $(filter $(subst *,%,$2),$d))

SOURCES=$(call rwildcard,./$(SRCDIR),*$(SRCPOSTFIX))
SOURCES_GEN=$(call rwildcard,./$(GENDIR),*$(SRCPOSTFIX))
OBJECTS=$(SOURCES:./$(SRCDIR)/%$(SRCPOSTFIX)=$(OBJDIR)/%$(OBJPOSTFIX)) $(SOURCES_GEN:./$(GENDIR)/%$(SRCPOSTFIX)=$(OBJDIR)/%$(OBJPOSTFIX)) 

all: CFLAGS+= -O3
all: $(GENDIR)/calc_rules.h $(GENDIR)/calc_tokens$(SRCPOSTFIX) $(OUT)

debug: CFLAGS+= -g -ftrapv -Wundef -Wpointer-arith -Wcast-align -Wwrite-strings -Wcast-qual -Wswitch-default -Wunreachable-code -Wfloat-equal -Wuninitialized -Wignored-qualifiers
debug: $(GENDIR)/calc_rules.h $(GENDIR)/calc_tokens$(SRCPOSTFIX) $(OUT)

clean:
	$(RM) -rf $(GENDIR)/* $(OBJECTS) $(BINDIR)/$(OUT)

run:
	./$(BINDIR)/$(OUT)

$(GENDIR)/calc_rules$(SRCPOSTFIX): $(SRCDIR)/calc_rules.y
	$(OUTPREFIX)bison$(OUTPOSTFIX) -d -o $@ $^

$(GENDIR)/calc_rules.h: $(GENDIR)/calc_rules$(SRCPOSTFIX)

$(GENDIR)/calc_tokens$(SRCPOSTFIX): $(SRCDIR)/calc_tokens.l $(GENDIR)/calc_rules.h
	$(OUTPREFIX)flex$(OUTPOSTFIX) -o $@ $^

$(OBJDIR)/%$(OBJPOSTFIX): %$(SRCPOSTFIX)
	$(CC) -I$(SRCDIR) -I$(GENDIR) $(CFLAGS) -o $@ -c $<

$(OUT): $(OBJECTS)
	$(LINKER) $^ -o $(BINDIR)/$(OUTPREFIX)$@$(OUTPOSTFIX) $(LDFLAGS)
