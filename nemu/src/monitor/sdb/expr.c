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

#include <isa.h>

/* We use the POSIX regex functions to process regular expressions.
 * Type 'man regex' for more information about POSIX regex functions.
 */
#include <regex.h>

enum {
  TK_NOTYPE = 256, TK_LOGICAND, TK_EQ, TK_NE, TK_DECNUM, TK_HEXNUM, TK_REG, TK_DEREF 

  /* TODO: Add more token types */

};

static struct rule {
  const char *regex;
  int token_type;
} rules[] = {

  /* TODO: Add more rules.
   * Pay attention to the precedence level of different rules.
   */

  {" +", TK_NOTYPE},    			// spaces

  {"==", TK_EQ},        			// equal
  {"!=", TK_NE},					// not equal
  {"&&", TK_LOGICAND},				// logic and

  {"\\$(0|ra|sp|gp|tp|t[0-6]|s[0-9]|s10|s11|a[0-7])", TK_REG},
  {"0[Xx][0-9a-f]+", TK_HEXNUM},		//hexnumber
  {"[0-9]+", TK_DECNUM},            //decnumber


  {"\\+", '+'},         			// plus
  {"-", '-'},						//substract		
  {"\\*", '*'},						//multiply or deref 
  {"/", '/'},						//devide

  {"\\(", '('},						//Left parenthesis
  {"\\)", ')'},						//right parenthesis


};

#define NR_REGEX ARRLEN(rules)

static regex_t re[NR_REGEX] = {};

/* Rules are used for many times.
 * Therefore we compile them only once before any usage.
 */
void init_regex() {
  int i;
  char error_msg[128];
  int ret;

  for (i = 0; i < NR_REGEX; i ++) {
    ret = regcomp(&re[i], rules[i].regex, REG_EXTENDED);
    if (ret != 0) {
      regerror(ret, &re[i], error_msg, 128);
      panic("regex compilation failed: %s\n%s", error_msg, rules[i].regex);
    }
  }
}

typedef struct token {
  int type;
  char str[32];
} Token;

static Token tokens[500] __attribute__((used)) = {};
static int nr_token __attribute__((used))  = 0;

static bool make_token(char *e) {
  int position = 0;
  int i;
  regmatch_t pmatch;

  nr_token = 0;

  while (e[position] != '\0') {
    /* Try all rules one by one. */
    for (i = 0; i < NR_REGEX; i ++) {
      if (regexec(&re[i], e + position, 1, &pmatch, 0) == 0 && pmatch.rm_so == 0) {
        char *substr_start = e + position;
        int substr_len = pmatch.rm_eo;

        //Log("match rules[%d] = \"%s\" at position %d with len %d: %.*s",
          //  i, rules[i].regex, position, substr_len, substr_len, substr_start);

        position += substr_len;

        /* TODO: Now a new token is recognized with rules[i]. Add codes
         * to record the token in the array `tokens'. For certain types
         * of tokens, some extra actions should be performed.
         */

        switch (rules[i].token_type) {
		  case TK_EQ: {tokens[nr_token].type = TK_EQ;break;}  
		  case TK_NE: {tokens[nr_token].type = TK_NE;break;}  
		  case TK_LOGICAND: {tokens[nr_token].type = TK_LOGICAND;break;}  
		  case TK_REG: {
				tokens[nr_token].type = TK_REG;
				snprintf(tokens[nr_token].str, substr_len, "%s", substr_start+1);
				break;
				}  
		  case TK_NOTYPE:{nr_token--;break;}
		  case TK_HEXNUM:
                {
                    tokens[nr_token].type = TK_HEXNUM;
                    snprintf(tokens[nr_token].str, substr_len+1, "%s", substr_start);
					break;
                }
		  case TK_DECNUM:
                {
                    tokens[nr_token].type = TK_DECNUM;
                    snprintf(tokens[nr_token].str, substr_len+1, "%s", substr_start);
					break;
                }
	 	  case '+': {tokens[nr_token].type = '+';break;}
	 	  case '-': {tokens[nr_token].type = '-';break;}
	 	  case '*': {
						if(nr_token == 0 || (tokens[nr_token-1].type!=TK_DECNUM && tokens[nr_token-1].type!=TK_HEXNUM && tokens[nr_token-1].type!=')')) tokens[nr_token].type = TK_DEREF;
						else tokens[nr_token].type = '*';
						break;
					}
	 	  case '/': {tokens[nr_token].type = '/';break;}
	 	  case '(': {tokens[nr_token].type = '(';break;}
	 	  case ')': {tokens[nr_token].type = ')';break;}
          default: ; 
        }
		nr_token++;
        break;
      }
    }

    if (i == NR_REGEX) {
      printf("no match at position %d\n%s\n%*.s^\n", position, e, position, "");
      return false;
    }
  }

  return true;
}

#define OP_CLEAR false
#define OP_CHECK true

enum 
{
	PR_LGCAND=1, PR_EQ_NE, PR_PS, PR_MD, PR_DEREF, PR_MAX
};

word_t eval(int,int,bool*);
bool check_parentheses(int,int);
int sep_op(int,bool);
void find_sep_op(int, int, int*, int*);
word_t calculate(int, int, int*, bool*);
word_t vaddr_read(vaddr_t, int len);


word_t expr(char *e, bool *success) {
  if (!make_token(e)) {
    *success = false;
    return 0;
  }

  /* TODO: Insert codes to evaluate the expression. */
  int result = eval(0, nr_token-1, success);
  if(!(*success)) panic("func eval is wrong!");
  return result;
}

word_t eval(int p, int q, bool* success){
  Log("Now in eval, p = %d, q = %d", p, q);
  if(tokens[p].type == TK_NOTYPE) p++;
  if(tokens[q].type == TK_NOTYPE) q--;

  if(p > q) {
    *success = false;
    panic("Bad expression in expr func!\n");
    return 0;
  }

  else if(p == q) {
	//printf("Type: %d", tokens[p].type);
    if(tokens[p].type == TK_DECNUM) {
		return atoi(tokens[p].str);
	}
	else if(tokens[p].type == TK_HEXNUM){
		return strtol(tokens[p].str, NULL, 16);
	}
	else if(tokens[p].type == TK_REG){
		word_t res = isa_reg_str2val(tokens[p].str, success);
		if(*success) return res;
		else panic("Invalid Reg to search!");
	}
	else{
        panic("1 token parsed but is not a valid number!\n");
        return 0;
    }
  }

  else if(check_parentheses(p, q) == true) return eval(p+1, q-1,success);

  else {
	int op_check = 0, op_sep = -1;
	sep_op(PR_MAX,OP_CLEAR);
	op_check = p;
	while(op_check <= q){
		find_sep_op(p, q, &op_check, &op_sep);
		op_check++;
	}
	return calculate(p, q, &op_sep, success);
  }
  return 0;
}

bool check_parentheses(int p, int q){
	if(tokens[p].type != '(' || tokens[q].type != ')') return false;
	int pt_check = p+1, pr_layer = 0;
	while(pt_check < q){
		if(tokens[pt_check].type == ')') {
			if(pr_layer==0) return false;
			else pr_layer--;
		}
		else if(tokens[pt_check].type == '(') pr_layer++;
		else ;
		pt_check++;
	}
	if(pr_layer != 0)
	panic("Unmatched left parenth!(called from check_pr)\n");
	else return true;
}	


int sep_op(int this_op, bool SEP_OP_FLAG){
	static int lowest_op_pr;
	int this_prior;
	if(!SEP_OP_FLAG) lowest_op_pr = PR_MAX;
	switch(this_op){
		case TK_LOGICAND :
			this_prior = PR_LGCAND;break;
		case TK_EQ:case TK_NE:
			this_prior = PR_EQ_NE;break;
		case '+':case '-':
			this_prior = PR_PS;break;
		case '*':case '/':
			this_prior = PR_MD;break;
		case TK_DEREF:
			this_prior = PR_DEREF;break;
		default:
			this_prior = PR_MAX;
	}
	if(this_prior <= lowest_op_pr) {
		lowest_op_pr = this_prior;
		return true;
	}
	else return false;
}

void find_sep_op(int p, int q, int *op_check, int *op_sep){
	if(tokens[*op_check].type == '+'){
		if(sep_op('+',OP_CHECK) == true) *op_sep = *op_check;
		Log("+ found at %d", *op_check);
	}
	else if(tokens[*op_check].type == '-'){
		if(sep_op('-',OP_CHECK) == true) *op_sep = *op_check;
		Log("- found at %d", *op_check);
	}
	else if(tokens[*op_check].type == '*'){
		if(sep_op('*',OP_CHECK) == true) *op_sep = *op_check;
		Log("* found at %d", *op_check);
	}
	else if(tokens[*op_check].type == '/'){
		if(sep_op('/',OP_CHECK) == true) *op_sep = *op_check;
		Log("/ found at %d", *op_check);
	}
	else if(tokens[*op_check].type == TK_DEREF){
		if(sep_op(TK_DEREF,OP_CHECK) == true) *op_sep = *op_check;
		Log("Deref * found at %d", *op_check);
	}
	else if(tokens[*op_check].type == TK_EQ){
		if(sep_op(TK_EQ,OP_CHECK) == true) *op_sep = *op_check;
		Log("== found at %d", *op_check);
	}
	else if(tokens[*op_check].type == TK_NE){
		if(sep_op(TK_NE,OP_CHECK) == true) *op_sep = *op_check;
		Log("!= found at %d", *op_check);
	}
	else if(tokens[*op_check].type == TK_LOGICAND){
		if(sep_op(TK_LOGICAND,OP_CHECK) == true) *op_sep = *op_check;
		Log("&& found at %d", *op_check);
	}
	else if(tokens[*op_check].type == '('){
		int pr_layers = 0;
		(*op_check)++;
		while(*op_check < q){
			if(tokens[*op_check].type == '(') pr_layers++;//another layer
			else if(tokens[*op_check].type == ')'){
				if(!pr_layers) break;//no more layer
				else pr_layers--;//an inner layer is sealed
			}
			(*op_check)++;
		}
		//reached the end but there is no right parenthese
		if(tokens[*op_check].type != ')') panic("Unmatched left parenth at %d! type: %d\n", *op_check,tokens[*op_check].type);
	}
	else if(tokens[*op_check].type == ')') panic("Unmatched right parenth\n");
	else ;
}

word_t calculate(int p, int q, int *op_sep, bool *success){
		if(tokens[*op_sep].type == '+') {
			word_t add1 = eval(p, *op_sep-1,success);
			word_t add2 = eval(*op_sep+1,q,success);
			Log("returning %d + %d", add1, add2);
			return add1 + add2;
		}
		else if(tokens[*op_sep].type == '-') {
			word_t sub1 = eval(p, *op_sep-1,success);
			word_t sub2 = eval(*op_sep+1,q,success);
			Log("returning %d - %d", sub1, sub2);
			return sub1 - sub2;
		}
	//'+' or '-' found!
		else if(tokens[*op_sep].type == '*') {
			word_t mul1 = eval(p,*op_sep-1,success);
			word_t mul2 = eval(*op_sep+1,q,success);
			Log("returning %d * %d", mul1, mul2);
			return mul1 * mul2;
		}
		else if(tokens[*op_sep].type == '/'){
			word_t div1 = eval(p,*op_sep-1,success);
			word_t div2 = eval(*op_sep+1,q,success);
			Log("returning %d / %d", div1, div2);
			return div1 / div2;
		}
	//'*' or '/' found!
		else if(tokens[*op_sep].type == TK_EQ){
			word_t LHE = eval(p,*op_sep-1,success);
			word_t RHE = eval(*op_sep+1,q,success);
			Log("returning %d == %d", LHE, RHE);
			return LHE == RHE;
		}
		else if(tokens[*op_sep].type == TK_NE){
			word_t LHE = eval(p,*op_sep-1,success);
			word_t RHE = eval(*op_sep+1,q,success);
			Log("returning %d != %d", LHE, RHE);
			return LHE != RHE;
		}
	//"==" or "!=" found!
		else if(tokens[*op_sep].type == TK_LOGICAND){
			word_t LHE = eval(p,*op_sep-1,success);
			word_t RHE = eval(*op_sep+1,q,success);
			Log("returning %d && %d", LHE, RHE);
			return LHE && RHE;
		}
	//"&&" found!
		else if(tokens[*op_sep].type == TK_DEREF){
			word_t RHE = eval(q,*op_sep+1,success);
			Log("returning *RHE=%d", RHE);
			return vaddr_read(RHE, 4);
		}
	//"*" deref found
		else panic("no operand in expr!\n");	
}
