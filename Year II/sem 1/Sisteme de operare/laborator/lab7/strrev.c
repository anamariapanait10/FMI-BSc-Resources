/*
Scrieti un program care primeste un sir de caractere la intrare ale carui caractere
le copiaza in ordine inversa si le salveaza intr-un sir separat. Operatie de inversare
va avea loc intr-un thread separat.Rezultatul va fi obtinut cu ajutorul functiei pthread_join
*/
#include <stdio.h>
#include <stdlib.h>
#include <errno.h>
#include <pthread.h>
#include <string.h>

void* inverseaza(void *arg){
    char *sir = (char*) arg;
    int len = strlen(sir);
    char *sir_invers = (char*) malloc(sizeof(char) * len);

    for(int i = 0; i < len; i++)
        sir_invers[i] = sir[len-i-1];
    return sir_invers;
}

int main(int argc, char *argv[]){
    if(argc != 2){
        printf("Trebuie sa introduceti un cuvant de inversat si numai unul!");
        return -1;
    }

    pthread_t thr;
    if (pthread_create(&thr, NULL, inverseaza, argv[1])) {
        perror(NULL);
        return errno;
    }

    void *sir_invers;
    if(pthread_join(thr, &sir_invers)){
        perror(NULL);
        return errno;
    }
    printf("%s\n", (char*)sir_invers);
    free(sir_invers);

    return 0;
}
