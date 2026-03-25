#include <stdio.h>
#include <stdlib.h>
#include <fcntl.h>
#include <unistd.h>
#include <string.h>
#include <elf.h>
#include <assert.h>

typedef struct{
	char *sym_name;
	Elf32_Addr sym_addr;
	int sym_size;
} symbol_t;

symbol_t *symbol_tbl = NULL;
int sym_count = 0;

//read elf header and check if it's a valid elf file
int read_elf_header(int fd, Elf32_Ehdr *ehdr){
	lseek(fd, 0, SEEK_SET);
	//faile reading
	if (read(fd, ehdr, sizeof(Elf32_Ehdr)) != sizeof(Elf32_Ehdr)) return -1;
	
	//ELF MAG doesn't match
	if(ehdr->e_ident[EI_MAG0] != ELFMAG0 || 
	   ehdr->e_ident[EI_MAG1] != ELFMAG1 ||
	   ehdr->e_ident[EI_MAG2] != ELFMAG2 ||
	   ehdr->e_ident[EI_MAG3] != ELFMAG3) return -1;

	return 0;
}

//find specific seciton info in the elf
Elf32_Shdr *find_section(Elf32_Ehdr *ehdr, int fd, const char *target_name){
	//read shstrtab in header
	Elf32_Shdr sh_strtab;
	lseek(fd, ehdr->e_shoff + ehdr->e_shstrndx * ehdr->e_shentsize, SEEK_SET);
	if(read(fd, &sh_strtab, sizeof(Elf32_Shdr)) != sizeof(Elf32_Shdr)){
		return NULL;
	}

	//read content in strtab
	char *strtab = malloc(sh_strtab.sh_size);
	lseek(fd, sh_strtab.sh_offset, SEEK_SET);
	if(read(fd, strtab, sh_strtab.sh_size) != sh_strtab.sh_size){
		printf("Fail to read strtab!\n");
		assert(0);
	}

	//find section with target name
	Elf32_Shdr *shdr = malloc(ehdr->e_shentsize);
	for(int i = 0; i<ehdr->e_shnum; i++){
		lseek(fd, ehdr->e_shoff + i*ehdr->e_shentsize, SEEK_SET);
		if(read(fd, shdr, ehdr->e_shentsize) != ehdr->e_shentsize){
			printf("Fail to read strtab!\n");
			assert(0);
		};

		char *section_name = strtab + shdr->sh_name;
		if(strcmp(section_name, target_name) == 0){
			free(strtab);
			return shdr;
		}
	}

	free(strtab);
	free(shdr);
	return NULL;
}

symbol_t* extract_symbols(int fd, Elf32_Shdr *symtab, Elf32_Shdr *strtab, int *sym_count){
	int num_syms = symtab->sh_size / symtab->sh_entsize;
	Elf32_Sym *syms = malloc(symtab->sh_size);

	//read symbol table
	lseek(fd, symtab->sh_offset, SEEK_SET);
	if(read(fd, syms, symtab->sh_size) != symtab->sh_size){
		printf("Fail to read symtab!\n");
		assert(0);	
	};

	//read strtab
	char *strings = malloc(strtab->sh_size);
	lseek(fd, strtab->sh_offset, SEEK_SET);
	if(read(fd, strings, strtab->sh_size) != strtab->sh_size){
		printf("Fail to read strtab!\n");
		assert(0);	
	};

	//sum up symbols extracted
	*sym_count = 0;
	for(int i = 0; i<num_syms; i++){
		if(ELF32_ST_TYPE(syms[i].st_info) == STT_FUNC &&
			syms[i].st_name != 0 &&
			syms[i].st_size >0) {
			(*sym_count)++;
		}
	}
	
	//allocate symbols array
	symbol_t *symbols = malloc(sizeof(symbol_t)*(*sym_count));

	int idx = 0;
	for(int i = 0; i<num_syms; i++){
		if (ELF32_ST_TYPE(syms[i].st_info) == STT_FUNC &&
			syms[i].st_name != 0 &&
			syms[i].st_size > 0){
			
			symbols[idx].sym_name = strdup(strings + syms[i].st_name);
			symbols[idx].sym_addr = syms[i].st_value;
			symbols[idx].sym_size = syms[i].st_size;
			idx++;
		}
	}

	free(syms);
	free(strings);

	return symbols;
}

char* find_func_name(symbol_t *symbols, Elf32_Addr addr){
	for (int i = 0; i<sym_count; i++){
		if(addr >= symbols[i].sym_addr &&
		   addr <  symbols[i].sym_addr + symbols[i].sym_size){
			
			return symbols[i].sym_name;
		}
	}
	return "unknown";
}

int interpret_elf(const char *elf_file){
	int fd = open(elf_file, O_RDONLY);
	printf("%s\n",elf_file);
	if(fd < 0) {
		printf("Fail to open the file!\n");
		assert(0);
	}

	Elf32_Ehdr ehdr;
	if(read_elf_header(fd, &ehdr) < 0){
		printf("Not an valid ELF file!\n");
		close(fd);
		return 1;	
	}

	Elf32_Shdr *symtab = find_section(&ehdr, fd, ".symtab");
	Elf32_Shdr *strtab = find_section(&ehdr, fd, ".strtab");

	if(!symtab || !strtab){
		printf("fail to load symtab or strtab into memory!\n");
		close(fd);
		return 1;
	}

	symbol_tbl = extract_symbols(fd, symtab, strtab, &sym_count);

	printf("%d functions found\n", sym_count);
	for(int i = 0; i<sym_count; i++){
		printf(" %s at 0x%x (size: %d)\n",
				symbol_tbl[i].sym_name,
				symbol_tbl[i].sym_addr,
				symbol_tbl[i].sym_size);
	}

	return 0;
}

