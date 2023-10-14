/*
Creati un proces nou folosind fork(2) si afisati fisierele din directorul
curent cu ajutorul execve(2). Din procesul initial afisati pid-ul propriu
si pid-ul copilului.
*/
#include <unistd.h>
#include <errno.h>
#include <stdio.h>
#include <sys/wait.h>


int main()
{
    pid_t pid = fork();
    if (pid < 0)
        return errno;
    else if (pid == 0){
        char *argv[] = {"ls", NULL};
        execve("/bin/ls", argv, NULL);
    } else {
        printf("My PID = %d Child PID = %d\n", getpid(), pid);
        wait(NULL);
        printf("Child %d finished\n", pid);
    }
}
