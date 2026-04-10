#include <am.h>
#include <klib.h>
#include <klib-macros.h>
#include <stdarg.h>

#if !defined(__ISA_NATIVE__) || defined(__NATIVE_USE_KLIB__)

typedef void (*output_char_func)(char c, void *context);

typedef struct{
	char *buffer;
	int position;
} sprintf_context;

extern void putch(char c);

typedef struct{
	void (*putch_func)(char);
}printf_context;

static void int2str(char **buf, int num);
static int vxprintf_core(output_char_func , void* , const char*, va_list);

void sprintf_output (char c, void *context){
	sprintf_context *ctx = (sprintf_context *)context;
	ctx->buffer[ctx->position++] = c;
	ctx->buffer[ctx->position] = '\0'; 
}

void printf_output(char c, void *context){
	printf_context *ctx = (printf_context *)context;
	ctx->putch_func(c);
}
int printf(const char *fmt, ...) {
	if(fmt == NULL) return -1;

	printf_context ctx = {putch};
	va_list args;

	va_start(args, fmt);
	int result = vxprintf_core(printf_output, &ctx, fmt, args);

	return result;
}

int vsprintf(char *out, const char *fmt, va_list ap) {
  panic("Not implemented");
}

int vxprintf_core(output_char_func output, void* context, const char *fmt, va_list args) {
	int count = 0;
	char buffer[64];

	while(*fmt){
		//Before %
		if(*fmt != '%'){
			output(*fmt, context);
			count++;
			fmt++;
			continue;	
		}
		//Reach %,skip
		fmt++;

		switch (*fmt) {
			case 'd':{
					int num = va_arg(args,int);
					char *p = buffer;
					int2str(&p, num);
					*p = '\0';
					for (char *s = buffer; *s; s++){
						output(*s, context);
						count++;
					}
					fmt++;
					break;
				}
			case 's':{
					const char *str = va_arg(args,const char*);
					if(str == NULL){
						str = "(null)";
					}
					while(*str){
						output(*str, context);
						count++;
						str++;
					}
					fmt++;
					break;
		   		}
			default:{
					output('%', context);
					output(*fmt, context);
					count += 2;
					fmt++;
					break;	
				}
			}
		}

	return count; 
}


int sprintf(char *out, const char *fmt, ...) {
	if(out == NULL || fmt == NULL) return -1;

	sprintf_context ctx = {out, 0};
	va_list args;

	va_start(args, fmt);
	int result = vxprintf_core(sprintf_output, &ctx, fmt, args);
	va_end(args);

	return result;
}

int snprintf(char *out, size_t n, const char *fmt, ...) {
  panic("Not implemented");
}

int vsnprintf(char *out, size_t n, const char *fmt, va_list ap) {
  panic("Not implemented");
}

static void int2str(char **buf, int num){
	//Handle num below zero
	if(num < 0){
		*(*buf)++ = '-';
		num = -num;
	}
	//if zero
	if(num == 0){
		*(*buf)++ = '0';
		return;
	}
	//handling part 4 numbers
	char temp[12];
	int i = 0;
	
	while(num > 0){
		//get num from LSB 2 MSB
		temp[i++] = '0' + (num % 10);//ASCII
		num /= 10;
		//num(<10) / 10 = 0;pinch-off
	}
	//reverse temp and concat 2 buf
	while(i > 0){
		*(*buf)++ = temp[--i];
	}
}


#endif
