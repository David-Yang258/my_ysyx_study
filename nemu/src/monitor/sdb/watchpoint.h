#ifndef __WATCHPOINT_H__
#define __WATCHPOINT_H__
#define NR_WP 32

typedef struct watchpoint {
  int NO;
  struct watchpoint *next;
  char exp[500];
  word_t old_value;

  /* TODO: Add more members if necessary */

} WP;
WP* new_wp(const char *exp, word_t eval);
void free_wp(WP *wp);
WP* find_wp_idx_atwork(word_t idx);
word_t ReEvalWPs();


#endif
