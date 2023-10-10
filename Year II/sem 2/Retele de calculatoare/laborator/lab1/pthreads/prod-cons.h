#define ITEMS		8
#define BUFFER_SIZE	4
extern int buffer[BUFFER_SIZE];

extern int spaces, items, tail;
extern pthread_cond_t space, item;
extern pthread_mutex_t buffer_mutex;
