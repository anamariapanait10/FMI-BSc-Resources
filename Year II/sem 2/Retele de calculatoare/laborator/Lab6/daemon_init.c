#include <syslog.h>
#include <stdlib.h>
#include <signal.h>
#include <unistd.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>

int daemon_init(const char *pname, int facility)
{
	int i, n;
	pid_t pid;

	if((pid = fork()) < 0)
		exit(1);
	else if(pid)
		_exit(0);	// parent terminates

	/* child 1 continues ... */

	if(setsid() < 0)	// become session leader
		exit(1);

	signal(SIGHUP, SIG_IGN);
	if((pid = fork()) < 0)
		exit(1);
	else if(pid)
		_exit(0);	// child 1 terminates

	/* child 2 continues ... */

	chdir("/");		/* change working directory */

	// close file descriptors
	n = getdtablesize();
	for(i = 0; i < n; i++)
		close(i);

	/* redirect stdin, stdout, and stderr to /dev/null */
	open("/dev/null", O_RDONLY);
	open("/dev/null", O_RDWR);
	open("/dev/null", O_RDWR);

	openlog(pname, LOG_PID, facility);

	return 0;		
}
