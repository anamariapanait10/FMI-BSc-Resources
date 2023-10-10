/*
Scrieti un program mycp care sa primeasca la intrare in primul argument un fisier
sursa pe care sa-l copieze intr-un alt fisier cu numele primit in al doilea argument.
Exemplu apel: ./mycp foo bar
*/
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <fcntl.h>
#include <errno.h>
#include <sys/stat.h>

int copyFile(int fromFile, int copyTo){
    const int MAX_SIZE = 1024;
    char* content = malloc(sizeof(char) * MAX_SIZE);

    int readResult = read(fromFile, content, MAX_SIZE);
    if(readResult == -1){
        perror("Cannot read content :(");
        return errno;
    }
    while(readResult > 0){
        int writeResult = write(copyTo, content, readResult);
        if(writeResult < 0){
            perror("Cannot write content :(");
            return errno;
        }
        readResult = read(fromFile, content, MAX_SIZE);
    }

    return 0;
}

int main(int argc, char* argv[]){

    if(argc != 3){
        printf("Invalid format, use ./mycp <src_file> <dest_file>\n");
        return -1;
    }

    char* file_name_src = argv[1], *file_name_dest = argv[2];
    int file_descriptor_src = open(file_name_src, O_RDONLY);
    if(file_descriptor_src < 0){
        printf("Cannot open file %s, file may not exist\n", file_name_src);
        return errno;
    }

    int file_descriptor_dest = open(file_name_dest, O_WRONLY | O_CREAT | O_TRUNC, S_IWUSR);
    if(file_descriptor_dest < 0){
        printf("Cannot open file %s\n", file_name_dest);
        return errno;
    }

    int ret = copyFile(file_descriptor_src, file_descriptor_dest);

    if(close(file_descriptor_src) < 0){
        printf("Error at closing the src file!");
        return errno;
    }
     if(close(file_descriptor_dest) < 0){
        printf("Error at closing the dest file!");
        return errno;
    }

    return ret;
}
