#include <am.h>
#include <nemu.h>

#define SYNC_ADDR (VGACTL_ADDR + 4)

void __am_gpu_init() {
}


void __am_gpu_config(AM_GPU_CONFIG_T *cfg) {
	uint32_t screen_HwLh = inl(VGACTL_ADDR);
  *cfg = (AM_GPU_CONFIG_T) {
    .present = true, .has_accel = false,
    .width = (screen_HwLh & 0xFFFF0000) >> 16, .height = screen_HwLh & 0x0000FFFF,
    .vmemsz = 0
  };
}

void __am_gpu_fbdraw(AM_GPU_FBDRAW_T *ctl) {
	int x = ctl->x, y = ctl->y;
	int w = ctl->w, h = ctl->h;
	//Row first
	uint32_t *pixels = ctl->pixels;
	uint32_t screen_width = inl(VGACTL_ADDR) >> 16;
	for (int i = y; i < y+h; i++) {
	     for (int j = x; j < x+w; j++) {
		        outl(FB_ADDR + 4*(i * screen_width + j), pixels[w*(i-y)+(j-x)]);
			    }
	    }
	if (ctl->sync) {
	    outl(SYNC_ADDR, 1);
	}
}

void __am_gpu_status(AM_GPU_STATUS_T *status) {
	status->ready = true;
}

