/*
Implementati un program care sa testeze ipoteza Collatz pentru mai
multe numere date folosind memorie partajata. Pornind de la un singur
proces parinte, este creat cate un copil care se ocupa de un singur
numar si scrie seria undeva in memoria partajata.
Parintele va crea obiectul de memorie partajata folosind shmopen(3) si ftruncate(2) si
pe urma va incarca in memorie intreg spatiul pentru citirea rezultatelor cu mmap(2). (lrt)
*/
#include <stdio.h>
#include <errno.h>
#include <unistd.h>
#include <stdlib.h>
#include <sys/wait.h>
#include <sys/mman.h>
#include <fcntl.h>


int main(int argc, char *argv[]){

    printf("Starting parent %d\n", getpid());

    int shm_fd = open("myshm", O_CREAT | O_RDWR, S_IRUSR | S_IWUSR);
    if (shm_fd < 0){
        perror(NULL);
        return errno;
    }

    size_t total_size = (argc-1) * getpagesize();
    if(ftruncate(shm_fd, total_size) == -1){
        perror(NULL);
        shm_unlink("myshm");
        return errno;
    }

    char* shm_ptr;
    shm_ptr = (char*) mmap(0, total_size, PROT_READ, MAP_SHARED, shm_fd, 0);
    if (shm_ptr == MAP_FAILED) {
        perror(NULL);
        shm_unlink("myshm");
        return errno;
    }
    for(int i = 1; i < argc; i++){
        pid_t pid = fork();
        if (pid < 0)
            return errno;
        else if (pid == 0){
            shm_ptr = (char*) mmap(0, total_size, PROT_WRITE, MAP_SHARED, shm_fd, (i-1) * getpagesize());
            if (shm_ptr == MAP_FAILED) {
                perror(NULL);
                shm_unlink("myshm");
                return errno;
            }

            int x = atoi(argv[i]);
            int nr_chs_written = sprintf(shm_ptr, "%d:", x);
            shm_ptr += nr_chs_written;
            while (x > 1){
                nr_chs_written = sprintf(shm_ptr, " %d", x);
                shm_ptr += nr_chs_written;
                if (x % 2 == 0)
                    x = x / 2;
                else
                    x = 3 * x + 1;
            }
            sprintf(shm_ptr, " 1.\n");
            munmap(shm_ptr, total_size);
            return 0;
        }
    }

    for(int i = 1; i < argc; i++){
        pid_t pid = wait(NULL);
        printf("Done Parent %d Me %d\n", getpid(), pid);
    }

    for(int i = 1 ; i < argc; i++){
        printf("%s", shm_ptr + (i-1) * getpagesize());
    }

    munmap(shm_ptr, total_size);
    shm_unlink("myshm");
    printf("Done parent %d Me %d\n", getppid(), getpid());

    return 0;
}
