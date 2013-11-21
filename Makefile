CC=gcc
CFLAGS = -std=gnu11
LDFLAGS = -lm -llolie

BINDIR=bin
OBJDIR=obj
SRCDIR=src
GENDIR=gen
OUT=tcalc

vpath %.c $(SRCDIR)
vpath %.c $(GENDIR)

SOURCES=$(shell find ./src -name *.c)
SOURCES_GEN=./$(GENDIR)/calc_rules.c ./$(GENDIR)/calc_tokens.c
OBJECTS=$(SOURCES:./$(SRCDIR)/%.c=$(OBJDIR)/%.o) $(SOURCES_GEN:./$(GENDIR)/%.c=$(OBJDIR)/%.o) 

all: $(GENDIR)/calc_rules.h $(GENDIR)/calc_tokens.c $(OUT)

clean:
	$(RM) -rf $(GENDIR)/* $(OBJECTS) $(BINDIR)/$(OUT)

run:
	./$(BINDIR)/$(OUT)

$(GENDIR)/calc_rules.c: $(SRCDIR)/calc_rules.y
	bison -d -o $@ $^

$(GENDIR)/calc_rules.h: $(GENDIR)/calc_rules.c

$(GENDIR)/calc_tokens.c: $(SRCDIR)/calc_tokens.l $(GENDIR)/calc_rules.h
	flex -o $@ $^

$(OBJDIR)/%.o: %.c
	$(CC) -I$(SRCDIR) -I$(GENDIR) $(CFLAGS) -o $@ -c $<

$(OUT): $(OBJECTS)
	$(CC) -o $(BINDIR)/$@ $^ $(LIBS) $(LDFLAGS)
