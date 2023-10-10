/*
Implementati un program care sa testeze ipoteza Collatz pentru mai multe numere date.
Pornind de la un singur proces parinte, este creat cate un copil care se ocupa de
un singur numar. Parintele va astepta sa termine executia fiecare copil.
Se vor folosi getpid(2) si getppid(2).
*/
#include <sys/types.h>
#include <unistd.h>
#include <errno.h>
#include <stdio.h>
#include <sys/wait.h>
#include <stdlib.h>

int main(int argc, char *argv[])
{

    if (argc < 2){
        printf("Nu ati introdus niciun numar pentru care se doreste generarea sirului Collatz!\n");
        return -1;
    }

    printf("Starting parent %d\n", getpid());
    for (int i = 1; i < argc; i++){
        pid_t pid = fork();
        if(pid < 0)
            return errno;
        else if(pid == 0){
            int n = atoi(argv[i]);
            printf("%d: ", n);
            while (n > 1){
                printf("%d ", n);
                if (n % 2 == 0)
                    n = n / 2;
                else
                    n = 3 * n + 1;
            }
            printf("1.\n");
            return 0;
        }
    }
    for (int i = 1; i < argc; i++){
        pid_t pid = wait(NULL);
        printf("Done Parent %d Me %d\n", getpid(), pid);
    }
    printf("Done Parent %d Me %d\n", getppid(), getpid());
    return 0;
}
