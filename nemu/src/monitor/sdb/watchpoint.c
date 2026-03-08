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

#include "sdb.h"
#include "watchpoint.h"

#define NR_WP 32


static WP wp_pool[NR_WP] = {};
static WP *head = NULL, *free_ = NULL;

void init_wp_pool() {
  int i;
  for (i = 0; i < NR_WP; i ++) {
    wp_pool[i].NO = i;
	wp_pool[i].exp[0] = '\0';
	wp_pool[i].old_value = 0;
    wp_pool[i].next = (i == NR_WP - 1 ? NULL : &wp_pool[i + 1]);
  }

  head = NULL;
  free_ = wp_pool;
}

/* TODO: Implement the functionality of watchpoint */

WP* new_wp(const char *exp, word_t result){
	WP* wp = free_;
	if(wp != NULL){
		free_ = wp->next;
		wp->next = head;
		head = wp;
		strcat(wp->exp, exp);
		wp->old_value = result;
	}
	else panic("No more free wp to use!");
	return wp;
}

WP* find_wp_idx_atwork(word_t idx){
	if(idx >= NR_WP) panic("%d is bigger than NR_WP", idx);
	if(head == NULL){
		printf("no watchpoint at work\n");
		return 0;
	}
	else {
		WP *tmp = head;
		while(tmp != NULL){
			if(tmp->NO == idx) break;
			tmp = tmp->next;
		}
		if(tmp->NO != idx) {
			printf("watchpoint %d is not at work\n", idx);
			return 0;
		}
		else return tmp;
	}
}

void free_wp(WP *wp){
	if(wp != NULL){
		if(head == wp){
			head = wp->next;
			wp->next=free_;
			free_= wp;
		}
		else {
			WP *tmp = head;
			while(tmp->next != NULL){
				if(tmp->next == wp)break;
				else tmp = tmp->next;
			}
			if(tmp->next == NULL) panic("wp is not in use!");
			tmp->next = wp->next;
			wp->next = free_;
			free_ = wp;
		}
		free_->exp[0] = '\0';
		free_->old_value = 0;
	}
	else panic("NULL ptr cannot be freed!");
}

word_t ReEvalWPs(){
	WP *wp2check = head;
	bool success = 0, Expr_refresh = 0;
	while(wp2check != NULL){
		word_t new_value = expr(wp2check->exp, &success);
		if(!success) panic("ReEval fatal error!");
		if(new_value != wp2check->old_value){
			printf("Watchpoint trapped, value %u changed for %s; Prev: %u\n",new_value, wp2check->exp, wp2check->old_value);
			wp2check->old_value = new_value;
			Expr_refresh = 1;			
		}
		wp2check = wp2check->next;
	}
	if(Expr_refresh) return 1;
	return 0;
}
