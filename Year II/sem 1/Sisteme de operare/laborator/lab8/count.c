/*
Scrieti un program care gestioneaza accesul la un numar finit de resurse.
Mai multe fire de executie pot cere concomitent o parte din resurse pe
care le vor da inapoi o data ce nu le mai sunt utile.
*/
#include <stdio.h>
#include <pthread.h>
#include <errno.h>
#include <stdlib.h>

#define MAX_RESOURCES 5
#define MAX_THREADS 7

int available_resources = MAX_RESOURCES;
pthread_mutex_t mutex;


int decrease_count(int count){

    int available_resources_locked;
    while(1){
        pthread_mutex_lock(&mutex);
        if (available_resources >= count){
            available_resources -= count;
            available_resources_locked = available_resources;
            pthread_mutex_unlock(&mutex);
            return available_resources_locked;
        } else {
            pthread_mutex_unlock(&mutex);
        }
    }

}

int increase_count(int count){
    int available_resources_locked;

    pthread_mutex_lock(&mutex);
    available_resources += count;
    available_resources_locked = available_resources;
    pthread_mutex_unlock(&mutex);

    return available_resources_locked;
}

void* my_thread(void* x){
    int count = *((int*)x);
    int available_resources_locked = decrease_count(count);
    printf("Got %d resources %d remaining\n", count, available_resources_locked);
    available_resources_locked = increase_count(count);
    printf("Released %d resources %d remaining\n", count, available_resources_locked);

    return NULL;
}

int main(){
    if (pthread_mutex_init(&mutex, NULL)) {
        perror(NULL);
        return errno;
    }

    printf("MAX_RESOURCES = %d\n", MAX_RESOURCES);

    pthread_t* ths = (pthread_t*)malloc(MAX_THREADS * sizeof(pthread_t));
    for(int i = 0; i < MAX_THREADS; i++){
        int *nr =(int*) malloc(sizeof(int));
        *nr = rand() % MAX_RESOURCES + 1;
        if(pthread_create(&ths[i], NULL, my_thread, nr)){
            perror(NULL);
            return errno;
        }
    }

    for(int i = 0; i < MAX_THREADS; i++)
        if(pthread_join(ths[i], NULL)){
            perror(NULL);
            return errno;
        }

    pthread_mutex_destroy(&mutex);
    return 0;
}
