/*
Implementati un program care foloseste fork(2) si testeaza ipoteza Collatz
generand sirul asociat unui numar dat in procesul copil.
*/
#include <stdio.h>
#include <errno.h>
#include <unistd.h>
#include <stdlib.h>
#include <sys/wait.h>

int main(int argc, char **argv){
    if(argc != 2){
        printf("Trebuie introdus un numar si numai unul pentru care se doreste generarea sirului Collatz!\n");
        return -1;
    }
    int n = atoi(argv[1]);

    pid_t pid = fork();
    if(pid < 0)
        return errno;
    else if(pid == 0){
        printf("%d: ", n);
        while (n > 1){
            printf("%d ", n);
            if(n % 2 == 0){
                n = n / 2;
            } else {
                n = 3 * n + 1;
            }
        }
        printf("1.\n");

    } else {
        wait(NULL);
        printf("Child %d finished\n", pid);
    }
    return 0;
}
