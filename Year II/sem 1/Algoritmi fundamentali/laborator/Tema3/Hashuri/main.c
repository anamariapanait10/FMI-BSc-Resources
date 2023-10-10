#include <stdio.h>
#include <stdlib.h>


FILE* in = fopen("hashuri.in", "r");
FILE* out = fopen("hashuri.out", "w");

struct fd_node {
    int id, size;
    struct fd_node *next;
};

struct my_map {
    int length;
    struct fd_node **lista;
};


void map_init(struct my_map *m, int n) {
    m->length = n;
    m->lista = (struct fd_node **) malloc(n * sizeof(struct fd_node *));
    for (int i = 0; i < n; ++i)
        m->lista[i] = NULL;
}

struct fd_node *map_find(struct my_map *m, int key) {
    int mod = key % m->length;
    if (m->lista[mod] == NULL)
        return NULL;
    for (struct fd_node *nod = m->lista[mod]; nod != NULL; nod = nod->next) {
        if (nod->id == key)
            return nod;
    }
    return NULL;
}


void map_insert(struct my_map *m, int key, int val) {
    int mod = key % m->length;
    if (m->lista[mod] == NULL) {
        m->lista[mod] = (struct fd_node *) malloc(sizeof(struct fd_node *));
        m->lista[mod]->size = val;
        m->lista[mod]->id = key;
        m->lista[mod]->next = NULL;
    }
    struct fd_node *nod;
    for (nod = m->lista[mod]; nod->next != NULL; nod = nod->next) {
        if (nod->id == key) {
            nod->size = val;
            return;
        }
    }

    nod->next = (struct fd_node *) malloc(sizeof(struct fd_node));
    nod->next->next = NULL;
    nod->next->id = key;
    nod->next->size = val;
}

void map_clear(struct my_map *m){
    for(int i=0;i<m->length;i++)
        free(m->lista[i]);
    free(m->lista);
}

int main()
{
    int n, op, x;
    fscanf(in, "%d", &n);
    for(int i = 0; i < n; i++){
        fscanf(in, "%d %d", &op, &x);
        if(op == 1){

        }
    }

    fclose(in);
    fclose(out);
    return 0;
}
