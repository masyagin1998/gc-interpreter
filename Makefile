SRC_PREFIX=src/
BIN_PREFIX=bin/
LIBS_PREFIX=.libs/
OBJS_PREFIX=.objs/

CC=gcc

CFLAGS=-g -Wall -Wextra -std=c89 -O3 -I$(SRC_PREFIX)macro/

all: $(BIN_PREFIX)interpreter

UTILS_SRC_PREFIX=$(SRC_PREFIX)utils/
UTILS_SRC=$(shell find $(UTILS_SRC_PREFIX) -maxdepth 1 -name '*.c')
UTILS_OBJS_PREFIX=$(OBJS_PREFIX)utils/
UTILS_OBJS=$(patsubst $(UTILS_SRC_PREFIX)%.c,$(UTILS_OBJS_PREFIX)%.o,$(UTILS_SRC))
UTILS_LIB_PREFIX=$(LIBS_PREFIX)utils/
UTILS_LIB=$(UTILS_LIB_PREFIX)utils.a

$(UTILS_LIB): $(UTILS_OBJS)
	mkdir -p $(UTILS_LIB_PREFIX)
	ar rcs $@ $^

$(UTILS_OBJS_PREFIX)%.o: $(UTILS_SRC_PREFIX)%.c $(UTILS_SRC_PREFIX)utils.h
	mkdir -p $(UTILS_OBJS_PREFIX)
	$(CC) $(CFLAGS) -c $< -o $@

LEXER_SRC_PREFIX=$(SRC_PREFIX)lexer/
LEXER_SRC=$(shell find $(LEXER_SRC_PREFIX) -maxdepth 1 -name '*.c')
LEXER_OBJS_PREFIX=$(OBJS_PREFIX)lexer/
LEXER_OBJS=$(patsubst $(LEXER_SRC_PREFIX)%.c,$(LEXER_OBJS_PREFIX)%.o,$(LEXER_SRC))
LEXER_LIB_PREFIX=$(LIBS_PREFIX)lexer/
LEXER_LIB=$(LEXER_LIB_PREFIX)lexer.a

$(LEXER_LIB): $(LEXER_OBJS)
	mkdir -p $(LEXER_LIB_PREFIX)
	ar rcs $@ $^

$(LEXER_OBJS_PREFIX)%.o: $(LEXER_SRC_PREFIX)%.c $(LEXER_SRC_PREFIX)lexer.h $(LEXER_SRC_PREFIX)lexer_priv.h
	mkdir -p $(LEXER_OBJS_PREFIX)
	$(CC) $(CFLAGS) -I$(UTILS_SRC_PREFIX) -c $< -o $@

PARSER_SRC_PREFIX=$(SRC_PREFIX)parser/
PARSER_SRC=$(shell find $(PARSER_SRC_PREFIX) -maxdepth 1 -name '*.c')
PARSER_OBJS_PREFIX=$(OBJS_PREFIX)parser/
PARSER_OBJS=$(patsubst $(PARSER_SRC_PREFIX)%.c,$(PARSER_OBJS_PREFIX)%.o,$(PARSER_SRC))
PARSER_LIB_PREFIX=$(LIBS_PREFIX)parser/
PARSER_LIB=$(PARSER_LIB_PREFIX)parser.a

$(PARSER_LIB): $(PARSER_OBJS)
	mkdir -p $(PARSER_LIB_PREFIX)
	ar rcs $@ $^

$(PARSER_OBJS_PREFIX)%.o: $(PARSER_SRC_PREFIX)%.c $(PARSER_SRC_PREFIX)parser.h
	mkdir -p $(PARSER_OBJS_PREFIX)
	$(CC) $(CFLAGS) -I$(UTILS_SRC_PREFIX) -I$(LEXER_SRC_PREFIX) -c $< -o $@

BYTECODE_GENERATOR_SRC_PREFIX=$(SRC_PREFIX)bytecode-generator/
BYTECODE_GENERATOR_SRC=$(shell find $(BYTECODE_GENERATOR_SRC_PREFIX) -maxdepth 1 -name '*.c')
BYTECODE_GENERATOR_OBJS_PREFIX=$(OBJS_PREFIX)bytecode-generator/
BYTECODE_GENERATOR_OBJS=$(patsubst $(BYTECODE_GENERATOR_SRC_PREFIX)%.c,$(BYTECODE_GENERATOR_OBJS_PREFIX)%.o,$(BYTECODE_GENERATOR_SRC))
BYTECODE_GENERATOR_LIB_PREFIX=$(LIBS_PREFIX)bytecode-generator/
BYTECODE_GENERATOR_LIB=$(BYTECODE_GENERATOR_LIB_PREFIX)bytecode-generator.a

$(BYTECODE_GENERATOR_LIB): $(BYTECODE_GENERATOR_OBJS)
	mkdir -p $(BYTECODE_GENERATOR_LIB_PREFIX)
	ar rcs $@ $^

$(BYTECODE_GENERATOR_OBJS_PREFIX)%.o: $(BYTECODE_GENERATOR_SRC_PREFIX)%.c $(BYTECODE_GENERATOR_SRC_PREFIX)bytecode-generator.h
	mkdir -p $(BYTECODE_GENERATOR_OBJS_PREFIX)
	$(CC) $(CFLAGS) -I$(UTILS_SRC_PREFIX) -I$(LEXER_SRC_PREFIX) -I$(PARSER_SRC_PREFIX) -c $< -o $@

DATA_TYPES_SRC_PREFIX=$(SRC_PREFIX)data-types/

GARBAGE_COLLECTOR_SRC_PREFIX=$(SRC_PREFIX)garbage-collector/
GARBAGE_COLLECTOR_SRC=$(shell find $(GARBAGE_COLLECTOR_SRC_PREFIX) -maxdepth 1 -name '*.c')
GARBAGE_COLLECTOR_OBJS_PREFIX=$(OBJS_PREFIX)garbage-collector/
GARBAGE_COLLECTOR_OBJS=$(patsubst $(GARBAGE_COLLECTOR_SRC_PREFIX)%.c,$(GARBAGE_COLLECTOR_OBJS_PREFIX)%.o,$(GARBAGE_COLLECTOR_SRC))
GARBAGE_COLLECTOR_LIB_PREFIX=$(LIBS_PREFIX)garbage-collector/
GARBAGE_COLLECTOR_LIB=$(GARBAGE_COLLECTOR_LIB_PREFIX)garbage-collector.a

$(GARBAGE_COLLECTOR_LIB): $(GARBAGE_COLLECTOR_OBJS)
	mkdir -p $(GARBAGE_COLLECTOR_LIB_PREFIX)
	ar rcs $@ $^

$(GARBAGE_COLLECTOR_OBJS_PREFIX)%.o: $(GARBAGE_COLLECTOR_SRC_PREFIX)%.c
	mkdir -p $(GARBAGE_COLLECTOR_OBJS_PREFIX)
	$(CC) $(CFLAGS) -I$(UTILS_SRC_PREFIX) -I$(LEXER_SRC_PREFIX) -I$(PARSER_SRC_PREFIX) -I$(BYTECODE_GENERATOR_SRC_PREFIX) -I$(DATA_TYPES_SRC_PREFIX) -I$(GARBAGE_COLLECTOR_SRC_PREFIX) -c $< -o $@

VIRTUAL_MACHINE_SRC_PREFIX=$(SRC_PREFIX)virtual-machine/
VIRTUAL_MACHINE_SRC=$(shell find $(VIRTUAL_MACHINE_SRC_PREFIX) -maxdepth 1 -name '*.c')
VIRTUAL_MACHINE_OBJS_PREFIX=$(OBJS_PREFIX)virtual-machine/
VIRTUAL_MACHINE_OBJS=$(patsubst $(VIRTUAL_MACHINE_SRC_PREFIX)%.c,$(VIRTUAL_MACHINE_OBJS_PREFIX)%.o,$(VIRTUAL_MACHINE_SRC))
VIRTUAL_MACHINE_LIB_PREFIX=$(LIBS_PREFIX)virtual-machine/
VIRTUAL_MACHINE_LIB=$(VIRTUAL_MACHINE_LIB_PREFIX)virtual-machine.a

$(VIRTUAL_MACHINE_LIB): $(VIRTUAL_MACHINE_OBJS)
	mkdir -p $(VIRTUAL_MACHINE_LIB_PREFIX)
	ar rcs $@ $^

$(VIRTUAL_MACHINE_OBJS_PREFIX)%.o: $(VIRTUAL_MACHINE_SRC_PREFIX)%.c $(VIRTUAL_MACHINE_SRC_PREFIX)virtual-machine.h
	mkdir -p $(VIRTUAL_MACHINE_OBJS_PREFIX)
	$(CC) $(CFLAGS) -I$(UTILS_SRC_PREFIX) -I$(LEXER_SRC_PREFIX) -I$(PARSER_SRC_PREFIX) -I$(BYTECODE_GENERATOR_SRC_PREFIX) -I$(DATA_TYPES_SRC_PREFIX) -I$(GARBAGE_COLLECTOR_SRC_PREFIX) -c $< -o $@

INTERPETER_SRC_PREFIX=$(SRC_PREFIX)
INTERPETER_SRC=$(shell find $(INTERPETER_SRC_PREFIX) -maxdepth 1 -name '*.c')
INTERPETER_OBJS_PREFIX=$(OBJS_PREFIX)
INTERPETER_OBJS=$(patsubst $(INTERPETER_SRC_PREFIX)%.c,$(INTERPETER_OBJS_PREFIX)%.o,$(INTERPETER_SRC))

$(INTERPETER_OBJS_PREFIX)%.o: $(INTERPETER_SRC_PREFIX)%.c
	mkdir -p $(INTERPETER_OBJS_PREFIX)
	$(CC) $(CFLAGS) -I$(UTILS_SRC_PREFIX) -I$(LEXER_SRC_PREFIX) -I$(PARSER_SRC_PREFIX) -I$(BYTECODE_GENERATOR_SRC_PREFIX) -I$(DATA_TYPES_SRC_PREFIX) -I$(GARBAGE_COLLECTOR_SRC_PREFIX) -I$(VIRTUAL_MACHINE_SRC_PREFIX)  -c $< -o $@

$(BIN_PREFIX)interpreter: $(INTERPETER_OBJS) $(UTILS_LIB) $(LEXER_LIB) $(PARSER_LIB) $(BYTECODE_GENERATOR_LIB) $(VIRTUAL_MACHINE_LIB) $(GARBAGE_COLLECTOR_LIB)
	mkdir -p $(BIN_PREFIX)
	$(CC) $(CFLAGS) $^ -o $@

.PHONY: clean

clean:
	rm -rf $(BIN_PREFIX) $(OBJS_PREFIX) $(LIBS_PREFIX)
