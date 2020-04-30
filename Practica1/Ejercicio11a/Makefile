CC=gcc
C_FLAGS=-no-pie -m64 -g
C_CODE_MAIN= Ejercicio11a.c
C_EJEC= Ejercicio11a
C_OBJS_ASM= Ejercicio11aFun.o

ASM=nasm
ASM_FLAGS= -f elf64 -g -F DWARF
ASM_CODE= Ejercicio11aFun.asm

main: $(C_CODE_MAIN) $(C_OBJS_ASM)
	$(CC) $(C_FLAGS) -o $(C_EJEC) $(C_CODE_MAIN) $(C_OBJS_ASM)

$(C_OBJS_ASM): $(ASM_CODE)
	$(ASM) $(ASM_FLAGS) $(ASM_CODE)

.PHONY: clean
clean:
	rm -rf *.o
	rm -rf $(C_EJEC)
