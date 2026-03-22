#include <am.h>
#include <nemu.h>

void __am_timer_init() {
	outl(RTC_ADDR, 0);
	outl(RTC_ADDR + 4, 0);
}

void __am_timer_uptime(AM_TIMER_UPTIME_T *uptime) {
  //uptime->us = 0;
  uint32_t H32bits = inl(RTC_ADDR + 4);
  uint32_t L32bits = inl(RTC_ADDR);
  uptime->us = ((uint64_t)H32bits << 32 | L32bits);
}

void __am_timer_rtc(AM_TIMER_RTC_T *rtc) {
  rtc->second = 0;
  rtc->minute = 0;
  rtc->hour   = 0;
  rtc->day    = 0;
  rtc->month  = 0;
  rtc->year   = 1900;
}
