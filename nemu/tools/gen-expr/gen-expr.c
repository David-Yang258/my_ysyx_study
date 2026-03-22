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

#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <assert.h>
#include <string.h>

// this should be enough
static char buf[65536] = {};
static char code_buf[65536 + 128] = {}; // a little larger than `buf`
static char *code_format = 
"#include <stdio.h>\n"
"#include <signal.h>\n"
"#include <setjmp.h>\n"
"jmp_buf recovery;\n"
"volatile int exception_occured = 0;\n"
"void handle_overflow_or_divby_0(int sig){\n"
"  signal(SIGFPE,handle_overflow_or_divby_0);\n"
"  exception_occured = 1;\n"
"  longjmp(recovery,1);\n"
"  }\n"
"int main() { \n"
"  int recovery_status;\n"
"  signal(SIGFPE,handle_overflow_or_divby_0);\n"
"  recovery_status = setjmp(recovery);"
"  if(recovery_status == 0){\n"
"  volatile unsigned result = %s; \n"
"  if(exception_occured == 0) printf(\"%%u\", result); \n"
"  }\n"
"  else return -1;\n"
"  return 0; \n"
"}";

#define MAX_LENGTH 800
#define MAX_LOOP   100

int choose(uint32_t n){
	uint32_t num;
	num = rand() % n;
	return num;
}

void gen_num(int n){
	uint32_t num;
	num = rand() % 100;
	if(n == 1) num = num * 2 + 1;
	char str[10];
	sprintf(str,"%u",num);
	if((MAX_LENGTH - strlen(buf)) > strlen(str)) strcat(buf,str);
	//else assert(0);
}

void gen(char c){
	char str[5];
	sprintf(str, "%c",c);
	if((MAX_LENGTH - strlen(buf)) > strlen(str)) strcat(buf,str);
	//else assert(0);
}

void gen_rand_op(){
	char op[4] = {'+','-','*','/'};
	uint32_t index = choose(4);
	char str[5];
	sprintf(str, "%c", op[index]);
	if((MAX_LENGTH - strlen(buf)) > strlen(str)) strcat(buf,str);
	//else assert(0);
}

static void gen_rand_expr(int n) {
	//buf[0] = '\0';
	static int loop_cnt = 0;
	if(n) loop_cnt = 0;
	loop_cnt++;
	switch(choose(3)){
		case 0: {
			gen_num(0);
			break;
		}
		case 1: {
			gen('(');
			if(loop_cnt <= MAX_LOOP)gen_rand_expr(0);
			else gen_num(0);
			gen(')');
			break;
		}
		default: {
		if(loop_cnt <= MAX_LOOP)gen_rand_expr(0);
		else gen_num(0);
		gen_rand_op();
		int index = strlen(buf);
		printf("%c",buf[index]);
		if(buf[index-1] == '/') gen_num(1);
		else if (loop_cnt <= MAX_LOOP) gen_rand_expr(0);
		else gen_num(0);
		break;
		}
	}
}

int main(int argc, char *argv[]) {
  int seed = time(0);
  srand(seed);
  int loop = 1;
  if (argc > 1) {
    sscanf(argv[1], "%d", &loop);
  }
  int i;
  for (i = 0; i < loop; i ++) {
	buf[0] = '\0';
    gen_rand_expr(1);

    sprintf(code_buf, code_format, buf);

    FILE *fp = fopen("/tmp/.code.c", "w");
    assert(fp != NULL);
    fputs(code_buf, fp);
    fclose(fp);

    int ret = system("gcc /tmp/.code.c -o /tmp/.expr");
    if (ret != 0) continue;

    fp = popen("/tmp/.expr", "r");
    assert(fp != NULL);

    int result;
	ret = fscanf(fp, "%d", &result);
    pclose(fp);
	
	if(ret != EOF){
		printf("%d ", result);
		printf("%s\n", buf);
	}
  }
  return 0;
}
