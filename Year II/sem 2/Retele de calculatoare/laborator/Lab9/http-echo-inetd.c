#include <sys/types.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <unistd.h>
#include <stdio.h>
#include <string.h>
#include <errno.h>
#include <stdlib.h>
#include <time.h>
#include <syslog.h>


int main(int argc, char *argv[])
{
	char buf[4096];
	int cc, nfds;
	fd_set rfds;
	struct timeval tv = {1, 0};

	openlog(argv[0], LOG_PID, 0);	
	syslog(LOG_USER|LOG_NOTICE,"starting http-echo service on port %d\n", atoi(argv[1]));

	FD_ZERO(&rfds);
	FD_SET(0, &rfds);
	nfds = getdtablesize();

	sprintf(buf, "HTTP/1.1 200 OK\n");
	write(1, buf, strlen(buf));
	sprintf(buf, "Content-Type: text/html; charset=utf-8\n\n");
	write(1, buf, strlen(buf));


	while (1)
	{	
		if (select(nfds, &rfds, (fd_set *)0, (fd_set *)0, &tv) < 0)
			syslog(LOG_USER|LOG_NOTICE,"select failed: %m\n"), exit(1);

		if (FD_ISSET(0, &rfds))
		{
			cc = read(0, buf, sizeof(buf));
			if (cc < 0)
				syslog(LOG_USER|LOG_NOTICE,"http-echo read error: %m\n"), exit(1);
			if (write(1, buf, cc) < 0)
				syslog(LOG_USER|LOG_NOTICE,"http-echo write error: %m\n"), exit(1);
			FD_SET(0, &rfds);
		}
		else
			{
				syslog(LOG_USER|LOG_NOTICE,"http-echo read timeout: %m\n");
				break;	
			}
	}


	close(0);
	close(1);
	close(2);
	exit(0);
}



