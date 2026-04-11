#include <readline/readline.h>
#include <readline/history.h>
#include "../../include/utils.h"
#include "sdb.h"
#include "../../include/memory.h"
#include <assert.h>


static int is_batch_mode = 0;
extern char *img_file;
extern char *diff_so_file;
long bin_img_size = 0;
static int difftest_port = 1234;


void init_regex();
void cpu_exec(uint64_t);
void isa_reg_display();
extern "C" int pmem_read(int);
void init_wp_pool();
void init_disasm();
void init_mem();
void init_diff_cpu();
void init_difftest(char*, long, int);
void free_wp(WP*);
void wp_display();
static long load_img();


//read sdb input
static char* rl_gets(){
	static char *line_read = NULL;

	if(line_read){
		free(line_read);
		line_read = NULL;
	}

	line_read = readline("(minirv-npc) ");

	if(line_read && *line_read){
		add_history(line_read);
	}
	
	return line_read;
}

static int cmd_c(char *args){
	cpu_exec(-1);
	return 0;
}

static int cmd_si(char *args){
	if(args == NULL) cpu_exec(1);
	else cpu_exec(atoi(args));
	return 0;
}

static int cmd_info(char *args){
	if(strcmp(args, "r") == 0) isa_reg_display();
	else if(strcmp(args, "w") == 0) wp_display();
	else printf("Unknown arg, use help for more details\n");
	return 0;
}

static int cmd_x(char *args){
	char Nstr[50], Expr_str[50];
    int result = sscanf(args, "%s %[^\n]",Nstr, Expr_str);
    if(!result) printf("Fatal Error\n");
    int N = atoi(Nstr);
    bool success = 1;
    int addr = expr(Expr_str,&success);
    if(!success) printf("Fatal Error\n");
    if(N<=0 && N >64*1024) {
          printf("N must be bigger than 0, smaller than 64KB");
          return 0;
      }
    else if(addr > 0xFFFFFFFF - N){
          printf("addr must be smaller than 0xFFFFFFFF - %d", N);
          return 0;
      }
       for(int i = 0;i < N;i++){
          printf("%x : %x\n",addr+4*i, pmem_read(addr+4*i));
      }
    return 0;	
}

static int cmd_q(char *args){
	npc_state.state = NPC_END;
	return -1;
}

static int cmd_p(char *args){
	if(strlen(args) >= 500) printf("expr too long!\n");
	else {
		bool success = 1;
		int result = expr(args,&success);
		if(success) printf("Result is %d\n", result);
		else printf("Fatal error!\n");
	}
	return 0;
}

static int cmd_w(char *args){
	bool success = 1;
	word_t Eval = expr(args, &success);
	if(success) new_wp(args, Eval);
	else printf("Invalid expression");
	return 0;
}

static int cmd_d(char *args){
	WP *wait2free = find_wp_idx_atwork(atoi(args));
	free_wp(wait2free);
	return 0;
}

static int cmd_help(char *args);

static struct{
	const char *name;
	const char *description;
	int (*handler) (char*);
} cmd_table [] ={
	{"help", "Display info about all supported cmds", cmd_help 	},
	{"c"   , "Continue the execution"  				, cmd_c 	},
	{"q"   , "Quit SDB" 							, cmd_q 	},
	{"si"  , "Continue the execution by step" 		, cmd_si 	},
	{"info", "Check registers -r or watchpoint -w"  , cmd_info  },
	{"x"   , "Scan N continuous memories from dest" , cmd_x 	},
	{"p"   , "Evaluate supported expression"  		, cmd_p 	},
	{"w"   , "Set a watchpoint for an expression"  	, cmd_w 	},
	{"d"   , "delete the watchpoint with index N" 	, cmd_d 	},
};

#define NR_CMD (sizeof(cmd_table) / sizeof(cmd_table[0]))

static int cmd_help(char* args){
	char *arg = strtok(NULL, " ");
	int i;

	if(arg == NULL){
		for (i = 0; i<NR_CMD; i++){
			printf("%s - %s\n", cmd_table[i].name, cmd_table[i].description);
		}
	}
	else{
		for(i = 0; i<NR_CMD; i++){
			if(strcmp(arg, cmd_table[i].name) == 0){
				printf("%s - %s\n", cmd_table[i].name, cmd_table[i].description);
				return 0;
			}
		}
		printf("Uknown cmd '%s'\n", arg);
	}
	return 0;
}

void sdb_set_batch_mode(){
	is_batch_mode = 1;
}

void sdb_mainloop(){
	if(is_batch_mode){
		cmd_c(NULL);
		return;
	}
	for(char *str; (str = rl_gets()) != NULL; ) {
		char *str_end = str + strlen(str);
	
	 	/* extract the first token as the command */
		char *cmd = strtok(str, " ");
		if (cmd == NULL) { continue; }
		/* treat the remaining string as the arguments,
		 *  which may need further parsing
		 */
	 	char *args = cmd + strlen(cmd) + 1;
	 	if (args >= str_end) {
		  args = NULL;
	 	}
#ifdef CONFIG_DEVICE
	 	extern void sdl_clear_event_queue();
	 	sdl_clear_event_queue();
#endif
	 
	 	int i;
	 	for (i = 0; i < NR_CMD; i ++) {
		  if (strcmp(cmd, cmd_table[i].name) == 0) {
			  if (cmd_table[i].handler(args) < 0) { return; }
			   break;
			    }
		    }
	   if (i == NR_CMD) { printf("Unknown command '%s'\n", cmd); }
	}
 }

void init_sdb(){
	init_regex();
    init_wp_pool();
	init_disasm();
	bin_img_size = load_img();
	init_mem();
	init_diff_cpu();
	//init_difftest(diff_so_file, bin_img_size, difftest_port);
}


static long load_img(){
	if(img_file == NULL){
		printf("No image is given.");
		return 4096;
	}	
	printf("loading img\n");
	char bin_img[256];
	char *dot = strrchr(img_file, '.');	
	if(dot && strcmp(dot, ".hex") == 0){
		size_t len = dot - img_file;
		strncpy(bin_img, img_file, len);
		bin_img[len] = '\0';
		strcat(bin_img, ".bin");
	}
	else if(dot && strcmp(dot, ".bin") == 0){
		strcpy(bin_img, img_file);
	}
	else {
		printf("Wrong input format!");
		return 4096;
	}

	FILE *fp = fopen(img_file, "rb");
	assert(fp);

	fseek(fp, 0, SEEK_END);
	long size = ftell(fp);
	printf("Image.bin is %s, size = %ld", bin_img, size);
	fclose(fp);
	return size;

}
