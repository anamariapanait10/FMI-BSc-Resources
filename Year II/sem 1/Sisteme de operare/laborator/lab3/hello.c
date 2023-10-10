/*
Rescrieti programul HelloWorld de data trecuta folosind numai functii de sistem.
*/
#include <stdio.h>
#include <unistd.h>


int main(){
    write(1, "Hello world!", 12);
    return 0;
}
