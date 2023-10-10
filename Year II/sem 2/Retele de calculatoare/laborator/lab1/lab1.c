#include <sys/types.h>

int main(int argc, char *argv[]) {

    int pipefd[2];

    if(pipe(pipefd) < 0){
        perror("Nu a functionat pipeul\n");
        exit(-1);
    }

    pid_t pid = fork();

    if(pid < 0){
        perror("Nu a functionat forkul\n");
        exit(-1);
    } else if (pid > 0){ 
        close(pipefd[0]); // inchid capatul de citire al parintelui
        char buf[100] = "Mesaj de la parinte\n";
        write(pipefd[1], &buf, sizeof(buf));
        printf("Parintele cu pidul %d a trimis mesajul %d\n", getpid(), buf);

    } else { 
        close(pipefd[1]); // inchid capatul de scriere de la copil
        char buf2[100];
        read(pipefd[0], &buf2, sizeof(buf2));
        printf("Copilul cu pidul %d a citit %d\n", getpid(), buf);
        exit(0);
    }
    return 0;
}