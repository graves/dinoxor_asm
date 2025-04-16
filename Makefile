# Makefile to compile and link the dinoxor assembly code with multiple C wrappers for macOS Apple Silicon

# Compiler and assembler definitions
CC = clang
AS = clang
LD = clang

# Targets
TARGETS = dinoxor_exe rc4_exe

# Source files per executable
DINOXOR_SRCS = main.c dinoxor.s
RC4_SRCS     = rc4.c dinoxor.s

# Object files per executable
DINOXOR_OBJS = $(DINOXOR_SRCS:.c=.o)
DINOXOR_OBJS := $(DINOXOR_OBJS:.s=.o)

RC4_OBJS = $(RC4_SRCS:.c=.o)
RC4_OBJS := $(RC4_OBJS:.s=.o)

# Pattern rule to compile C files
%.o: %.c
	$(CC) -c $< -o $@

# Pattern rule to assemble .s files
%.o: %.s
	$(AS) -c $< -o $@

# Targets
dinoxor_exe: $(DINOXOR_OBJS)
	$(LD) $(DINOXOR_OBJS) -o $@

rc4_exe: $(RC4_OBJS)
	$(LD) $(RC4_OBJS) -o $@

# Default target builds both
all: $(TARGETS)

# Clean
clean:
	rm -f *.o $(TARGETS)

.PHONY: all clean
