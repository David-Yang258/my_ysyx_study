#include <am.h>

void __am_timer_init() {
}

void __am_timer_uptime(AM_TIMER_UPTIME_T *uptime) {
	uint32_t L32bits;
	asm volatile(
			"lw %0, 0(%1)"
			: "=r"(L32bits)
			: "r" ((uintptr_t)0xa0000048)
			: "memory"
			);
	uint32_t H32bits;
	asm volatile(
			"lw %0, 0(%1)"
			: "=r"(H32bits)
			: "r" ((uintptr_t)0xa000004c)
			: "memory"
			);
  uptime->us = ((uint64_t)H32bits << 32) | L32bits;
}

void __am_timer_rtc(AM_TIMER_RTC_T *rtc) {
  rtc->second = 0;
  rtc->minute = 0;
  rtc->hour   = 0;
  rtc->day    = 0;
  rtc->month  = 0;
  rtc->year   = 1900;
}
