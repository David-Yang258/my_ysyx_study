#include <klib.h>
#include <klib-macros.h>
#include <stdint.h>

#if !defined(__ISA_NATIVE__) || defined(__NATIVE_USE_KLIB__)

size_t strlen(const char *s) {
	if(s == NULL) return -1;
	size_t len = 0;
	while (*s++ != '\0') len++;
	return len;
}

char *strcpy(char *dst, const char *src) {
	char *dst_start = dst;
	//Check if there's NULL ptr
	if(dst == NULL || src == NULL) return NULL;
	while((*dst++ = *src++) != '\0');
	return dst_start;
}

char *strncpy(char *dst, const char *src, size_t n) {
	if(dst == NULL || src == NULL) return NULL;
	if(n == 0) return dst;
	char *dst_start = dst;
	size_t len = n - 1;
	while(len-- && *src != '\0'){
		*dst++ = *src++;
	}
	*dst = '\0';
	return dst_start;
}

char *strcat(char *dst, const char *src) {
	if(dst == NULL || src == NULL) return NULL;
	char *dst_start = dst;
	while(*dst++ != '\0');
	dst--;
	while((*dst++ = *src++) != '\0');
	return dst_start;
}

int strcmp(const char *s1, const char *s2) {
	if(s1 == NULL || s2 == NULL) return -2;
	while(*s1 != '\0' && *s2 != '\0'){
		if(*s1 != *s2) break;
		s1++;
		s2++;
	}
	if(*s1 == *s2) return 0;
	else if(*s1 > *s2) return 1;
	else return -1;
}

int strncmp(const char *s1, const char *s2, size_t n) {
	if(s1 == NULL || s2 == NULL) return -2;
	if(n == 0) return 0;
	size_t len = n - 1;
	while(len--){
		if(*s1 == '\0' || *s2 == '\0')break;
		if(*s1 != *s2) break;
		s1++;
		s2++;
	}
	if(*s1 == *s2) return 0;
	else if(*s1 > *s2) return 1;
	else return -1;
}

void *memset(void *s, int c, size_t n) {
	unsigned char * sp = s;
	unsigned char uc = (unsigned char)c;
	while(n--) *sp++ = uc;
	return s;
}

void *memmove(void *dst, const void *src, size_t n) {
	unsigned char *d = dst;
	const unsigned char *s = src;
	if(d < s){
		while(n--){
			*d++ = *s++;
		}
	}
	else {
		d += n;
		s += n;
		while(n--){
			*--d = *--s;
		}
	}
	return dst;
}

void *memcpy(void *out, const void *in, size_t n) {
	unsigned char *outp = out;
	const unsigned char *inp  = in ;
	while(n--) *outp++ = *inp++;
	return out;
}

int memcmp(const void *s1, const void *s2, size_t n) {
	const unsigned char *s1_ptr = s1;
	const unsigned char *s2_ptr = s2;
	for (size_t i = 0;i < n;i++){
		if(s1_ptr[i] != s2_ptr[i])
			return (s1_ptr[i] > s2_ptr[i]) ? 1 : -1;
	}
	return 0;
}

#endif
