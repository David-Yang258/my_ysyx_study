#include <am.h>
#include <nemu.h>

#define KEYDOWN_MASK 0x8000

void __am_input_keybrd(AM_INPUT_KEYBRD_T *kbd) {
  int key_code = AM_KEY_NONE;
  key_code = inl(KBD_ADDR);
  kbd->keydown = (key_code & KEYDOWN_MASK) ? true : false;
  kbd->keycode = key_code & ~KEYDOWN_MASK;
}
