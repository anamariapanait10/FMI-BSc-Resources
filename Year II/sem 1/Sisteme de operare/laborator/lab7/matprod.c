/*
Scrieti un program care sa calculeze produsul a doua matrice date de dimensiuni
compatibile unde fiecare element al matricei rezultate este calculat de catre
un thread distinct.
*/
#include <stdio.h>
#include <stdlib.h>
#include <errno.h>
#include <pthread.h>

int l, p, c;
int **matrix1, **matrix2, **result_matrix;

struct pos{
    int i, j;
};

void* compute(void* position){
    struct pos * index = (struct pos *)position;
    int i = index->i;
    int j = index->j;
    free(position);
    int *suma = (int*)malloc(sizeof(int));
    *suma = 0;
    for(int k = 0; k < p; k++)
        *suma += matrix1[i][k] * matrix2[k][j];
    return suma;
}

void citire(){
    printf("Introduceti l, p, c = ");
    scanf("%d %d %d", &l, &p, &c);

    matrix1 = (int**)malloc(l*sizeof(int*));
    for(int i = 0; i < l; i++)
        matrix1[i] = (int*)malloc(p*sizeof(int));

    matrix2 = (int**)malloc(p*sizeof(int*));
    for(int i = 0; i < p; i++)
        matrix2[i] = (int*)malloc(c*sizeof(int));

    result_matrix = (int**)malloc(l*sizeof(int*));
    for(int i = 0; i < l; i++)
        result_matrix[i] = (int*)malloc(c*sizeof(int));

    printf("Introduceti prima matrice:\n");
    for (int i = 0; i < l; i++)
		for (int j = 0; j < p; j++)
			scanf("%d", &matrix1[i][j]);
    printf("Introduceti a doua matrice:\n");
    for (int i = 0; i < p; i++)
		for (int j = 0; j < c; j++)
			scanf("%d", &matrix2[i][j]);
}

int main(){

    citire();
    pthread_t thrs[l*c];
    int thr_id = 0;
    for(int i = 0; i < l; i++)
        for(int j = 0; j < c; j++){
            struct pos* index = (struct pos*)malloc(sizeof(struct pos));
            index->i = i;
            index->j = j;
            if(pthread_create(&thrs[thr_id++], NULL, compute, index)){
                perror(NULL);
                return errno;
            }
        }

    void *rez;
    thr_id = 0;
    for(int i = 0; i < l; i++){
        for(int j = 0; j < c; j++){
            if(pthread_join(thrs[thr_id++], &rez)){
                perror(NULL);
                return errno;
            } else {
                result_matrix[i][j] = *((int*) rez);
            }
        }
    }

    printf("Result matrix:\n");
    for(int i = 0; i < l; i++){
        for(int j = 0; j < c; j++)
            printf("%d ", result_matrix[i][j]);
        printf("\n");
    }
    return 0;
}
