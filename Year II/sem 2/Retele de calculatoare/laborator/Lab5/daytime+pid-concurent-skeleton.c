#include <unistd.h>
#include <stdlib.h>
#include <string.h>
#include <stdio.h>

void TCPdaytime(const char *host, const char *service);
int errexit(const char *format, ...);
int connectTCP(const char *host, const char *service);

#define LINELEN	128
#define N	8

/*------------------------------------------------------------------------
* main - TCP client for DAYTIME service
*------------------------------------------------------------------------
*/

int main(int argc, char *argv[])
{
	char *host = "localhost"; /* host to use if none supplied */
	char *service = "daytime"; /* default service port */
	int i;

	switch (argc) {
		case 1:
			host = "localhost";
			break;
		case 3:
			service = argv[2];
			/* FALL THROUGH */
		case 2:
			host = argv[1];
			break;
		default:
			fprintf(stderr, "usage: TCPdaytime [host [port]]\n");
			exit(1);
	}

	for(i = 0; i < N; i++)
	{
		// if fork
			// then child
				// client code
				// EXIT !!!
				// NB even if you exec the client code, it's still safe to exit,
				// in this case with an error code
			// else parent
				// wait for children termination WITHOUT blocking !
				// blocking stops parent from looping back to create more children
	}
	exit(0);
}

/*------------------------------------------------------------------------
* TCPdaytime - invoke Daytime on specified host and print results
*------------------------------------------------------------------------
*/

void TCPdaytime(const char *host, const char *service)
{
	// modified code
}
