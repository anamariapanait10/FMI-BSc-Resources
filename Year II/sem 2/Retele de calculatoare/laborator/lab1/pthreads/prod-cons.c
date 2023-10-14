#include <pthread.h>
#include <stdio.h>
#include "prod-cons.h"

void *producer(void *arg)
{
	int i;

	for(i = 0; i < ITEMS; i++)
	{
		pthread_mutex_lock(&buffer_mutex);
		while(spaces == 0)
			pthread_cond_wait(&space, &buffer_mutex);
		buffer[(tail + items) % BUFFER_SIZE] = i;
		items += 1;
		spaces -= 1;
		printf("producer puts %d\n", i);
		pthread_mutex_unlock(&buffer_mutex);
		pthread_cond_signal(&item);
	}
	pthread_exit(0);
	return (void*)0;
}

void *consumer(void *arg)
{
	int i, b;

	for(i = 0; i < ITEMS; i++)
	{
		pthread_mutex_lock(&buffer_mutex);
		while(items == 0)
			pthread_cond_wait(&item, &buffer_mutex);
		b = buffer[tail % BUFFER_SIZE];
		tail += 1;
		items -= 1;
		spaces += 1;
		printf("consumer gets %d\n", b);
		pthread_mutex_unlock(&buffer_mutex);
		pthread_cond_signal(&space);
	}
	pthread_exit(0);
	return (void*)0;
}
