/*
Scrieti un program care sa sincronizeze executia a n fire de executie
construind un obiect de tip bariera. Bariera va fii initializata folosind
init(n) si fiecare thread va apela barrierpoint() cand va ajunge
in dreptul barierei.
Cand functia este apelata a n-a oara, aceasta porneste executia
tuturor firelor in asteptare.
Verificati rezultatele dumneavoastra cu ajutorul unui program care porneste
mai multe thread-uri ce se folosesc de bariera pentru a-si sincroniza executia.
*/
#include <stdio.h>
#include <pthread.h>
#include <errno.h>
#include <stdlib.h>
#include <semaphore.h>

#define NUM_THREADS 5

int nr = 0;
pthread_mutex_t mtx;
sem_t sem;


void barrier_point(){
    pthread_mutex_lock(&mtx);
    nr++;
    pthread_mutex_unlock(&mtx);

    if (nr < NUM_THREADS)
        sem_wait(&sem);
    if(nr == NUM_THREADS)
        sem_post(&sem);
}

void *tfun(void *v){
    int *tid = (int *)v;
    printf("%d reached the barrier\n", *tid);
    barrier_point();
    printf("%d passed the barrier\n", *tid);

    free(tid);
    return NULL;
}

int main()
{
    pthread_t ths[NUM_THREADS];

    if (pthread_mutex_init(&mtx, NULL)){
        perror(NULL);
        return errno;
    }

    if (sem_init(&sem, 0, 0)){
        perror(NULL);
        return errno;
    }

    for (int i = 0; i < NUM_THREADS; i++){
        int *id = (int*) malloc(sizeof(int));
        *id = i;
        if (pthread_create(&ths[i], NULL, tfun, id)){
            perror(NULL);
            return errno;
        }
    }

    for (int i = 0; i < NUM_THREADS; i++)
        if (pthread_join(ths[i], NULL)){
            perror(NULL);
            return errno;
        }

    pthread_mutex_destroy(&mtx);
    sem_destroy(&sem);

    return 0;
}
