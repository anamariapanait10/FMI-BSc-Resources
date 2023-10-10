#include <stdlib.h>
#include <stdio.h>
#include <pthread.h>

#define ITEMS		8
#define BUFFER_SIZE	4
int buffer[BUFFER_SIZE];

extern void *producer(void*);
extern void *consumer(void*);

int spaces, items, tail;
pthread_cond_t space, item;
pthread_mutex_t buffer_mutex;

int main()
{
	pthread_t producer_thread, consumer_thread;
	void *thread_return;
	int result;

	spaces = BUFFER_SIZE;
	items = 0;
	tail = 0;
	
	pthread_mutex_init(&buffer_mutex, NULL);
	pthread_cond_init(&space, NULL);
	pthread_cond_init(&item, NULL);

	if(pthread_create(&producer_thread, NULL, producer, NULL) ||
	   pthread_create(&consumer_thread, NULL, consumer, NULL))
		exit(1);
	
	if(pthread_join(producer_thread, &thread_return))
		exit(1);
	else
		printf("producer returns with %d\n", (int)thread_return);

	if(pthread_join(consumer_thread, &thread_return))
		exit(1);
	else
		printf("consumer returns with %d\n", (int)thread_return);
	exit(0);
}

