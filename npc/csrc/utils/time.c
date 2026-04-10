#include <time.h>
#include <sys/time.h>

long long get_us(){
	static struct timeval start;
	static int first = 1;
	struct timeval now;
	
	gettimeofday(&now, NULL);

	if(first){
		start = now;
		first = 0;
		return 0;
	}
	return (now.tv_sec - start.tv_sec) * 1000000LL + (now.tv_usec - start.tv_usec);
}
