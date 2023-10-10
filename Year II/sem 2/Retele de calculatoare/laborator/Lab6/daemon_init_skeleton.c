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

	//primul fork	
	

	/* child 1 continues ... */


	// setsid
	

	// signal SIGHUP SIG_IGN
	
	// al doilea fork
	

	/* child 2 continues ... */


	// chdir in /


	// close file descriptors
	

	/* redirect stdin, stdout, and stderr to /dev/null */
	

	// openlog cu LOG_PID
	

	return 0;		
}
