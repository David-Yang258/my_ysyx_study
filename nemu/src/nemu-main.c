/***************************************************************************************
* Copyright (c) 2014-2024 Zihao Yu, Nanjing University
*
* NEMU is licensed under Mulan PSL v2.
* You can use this software according to the terms and conditions of the Mulan PSL v2.
* You may obtain a copy of Mulan PSL v2 at:
*          http://license.coscl.org.cn/MulanPSL2
*
* THIS SOFTWARE IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
* EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
* MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
*
* See the Mulan PSL v2 for more details.
***************************************************************************************/

#include <common.h>

/*********************/
/*
/define to evaluate expr
*/
#define MAX_LINE_LEN 1024
#define MAX_STR_LEN 512
//#define EVAL_EXPR 1

bool SUCCESS;

word_t expr(char*, bool*);
/*
/
/
/
*/

void init_monitor(int, char *[]);
void am_init_monitor();
void engine_start();
int is_exit_status_bad();

int main(int argc, char *argv[]) {
  /* Initialize the monitor. */
#ifdef CONFIG_TARGET_AM
  am_init_monitor();
#else
  init_monitor(argc, argv);
#endif

  
  /* Start engine. */
  engine_start();

#ifdef EVAL_EXPR
	FILE *file;
    char line[MAX_LINE_LEN];
    char first_part[MAX_STR_LEN];
    char second_part[MAX_STR_LEN];

    file = fopen("/home/daviyang3182/ysyx/ysyx-workbench/nemu/tools/gen-expr/build/input","r");
    if (file == NULL){
        printf("Failed to open the input file!\n");
        return 1;
    }

    while (fgets(line, sizeof(line),file)){
		static int cnt = 0;
        line[strcspn(line, "\n")] = 0;

        char *space_pos = strchr(line, ' ');

        if(space_pos != NULL){
            int first_len = space_pos - line;
            strncpy(first_part, line, first_len);
            first_part[first_len] = '\0';

            strcpy(second_part, space_pos+1);

            printf("Test %d: Expect %s for exprssion %s\n", cnt, first_part, second_part);
			int res = expr(second_part, &SUCCESS);
            printf("returned %d\n", res);
			if(res != atoi(first_part)) panic("wrong result!");
            if(SUCCESS) printf("expr failed\n");
        }
        else printf("Unknown input format!\n");
		cnt++;
    }
    fclose(file);
#endif

  return is_exit_status_bad();
}
