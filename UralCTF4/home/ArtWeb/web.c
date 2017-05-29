#include <stdio.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <linux/in.h>
#include <string.h>
#include <unistd.h>
#include <signal.h>
#include <fcntl.h>
#include <stdlib.h>
#include <time.h>
#include <sys/stat.h>
#include <dirent.h>
#include <pwd.h>
#include <errno.h>

#define BIND_PORT	12345
#define RUNNING_DIR	"/var/www/web/"
#define LOCK_FILE	"/tmp/ArtWeb.lock"
#define LOG_FILE	"/var/log/ArtWeb.log"
#define PNAME		"ArtWeb"
#define FLAG_DIR	"/var/www/web/flags/"

#define USER		"ArtWeb"

#define	ok		"HTTP/1.0 200 OK\n\
Content-type: text/html\n\
\n"

#define bad_request 	"HTTP/1.0 400 Bad Request\n\
Content-type: text/html\n\
\n\
<html>\n\
	<body>\n\
		<h1>Bad Request</h1>\n\
		<p>This server did not understand your request.</p>\n\
	</body>\n\
</html>\n"

#define not_found  	"HTTP/1.0 404 Not Found\n\
Content-type: text/html\n\
\n\
<html>\n\
	<body>\n\
		<h1>Not Found</h1>\n\
		<p>The requested URL was not found on this server.</p>\n\
	</body>\n\
</html>\n"

#define bad_method  	"HTTP/1.0 501 Method Not Implemented\n\
Content-type: text/html\n\
\n\
<html>\n\
	<body>\n\
		<h1>Method Not Implemented</h1>\n\
		<p>The requested method is not implemented by this server.</p>\n\
	</body>\n\
</html>\n"

#define server_error	"<html>\n\
        <body>\n\
	        <h1>Server Error</h1>\n\
		<p>Server Error.</p>\n\
	</body>\n\
</html>\n"

void log_message(char *filename, char *message){
	FILE *logfile;
	struct tm *tm;
	time_t t;
	char buf[255];

	logfile = fopen(filename, "a");
	if (!logfile) return;
	t = time(NULL);
	tm = localtime(&t);
	strftime(buf, sizeof(buf), "%Y-%m-%d %H:%M:%S", tm);
	fprintf(logfile, "[%s] %s\n", buf, message);
	fclose(logfile);
	chmod(filename, S_IRUSR|S_IWUSR|S_IRGRP|S_IWGRP|S_IROTH|S_IWOTH);
}

void signal_handler(int sig){
	switch (sig){
		case SIGHUP:
			log_message(LOG_FILE, "HUP signal catched");
			break;
		case SIGTERM:
			log_message(LOG_FILE, "TERM signal catched");
			if (unlink(LOCK_FILE) == -1) exit(1);
			exit(0);
			break;
		case SIGCHLD:
			log_message(LOG_FILE, "CHLD signal catched");
			int status;
			wait(&status);
			break;
	}
}

void daemonize(void){
	int i, lfp;
	char str[10];

	if (getppid() == 1) return;

	i = fork();
	if (i == -1) exit(1);
	if (i > 0) exit(0);

	setsid();
	for (i = getdtablesize(); i >= 0; i--) close(i);

	i = open("/dev/null", O_RDWR); dup(i); dup(i);

	umask(027);
	chdir(RUNNING_DIR);

	lfp = open(LOCK_FILE, O_RDWR | O_CREAT, 0640);
	if (lfp < 0) exit(1);
	if (lockf(lfp, F_TLOCK, 0) < 0) exit(0);
	sprintf(str, "%d\n", getpid());
	write(lfp, str, strlen(str));

	signal(SIGTSTP, SIG_IGN);
	signal(SIGTTOU, SIG_IGN);
	signal(SIGTTIN, SIG_IGN);
	signal(SIGHUP, signal_handler);
	signal(SIGTERM, signal_handler);
	signal(SIGCHLD, signal_handler);
}

void handle_get(int sd, char *page){
	char msg[1024];
	struct sockaddr_in sa;
	socklen_t address_len;

	address_len = sizeof(sa);
	if (-1 == getpeername(sd, (struct sockaddr *)&sa, &address_len)){
		log_message(LOG_FILE, "Can't getpeername!");
		exit(1);
	}

	if (page != NULL && *page == '/'){
		char path[sizeof(page)];

		snprintf(msg, sizeof(msg), "%s:%d -> GET %s", inet_ntoa(sa.sin_addr), ntohs(sa.sin_port), page);
		log_message(LOG_FILE, msg);
		sscanf(page, "/%s", path);

		if (strlen(path) && path[strlen(path) - 1] != '/'){
			int input_fd;
			struct stat file_info;
			off_t offset = 0;

			input_fd = open(path, O_RDONLY);
			if (-1 == input_fd){
				snprintf(msg, sizeof(msg), "Can't open file %s", path);
				log_message(LOG_FILE, msg);
				send(sd, not_found, sizeof(not_found), 0);
				return;
			}
		
			if (-1 == fstat(input_fd, &file_info)){
				snprintf(msg, sizeof(msg), "Can't fstat file %s", path);
				log_message(LOG_FILE, msg);
				send(sd, not_found, sizeof(not_found), 0);
				return;
			}

			send(sd, ok, sizeof(ok), 0);

			char buf[file_info.st_size];
			if (-1 == read(input_fd, buf, file_info.st_size)){
				snprintf(msg, sizeof(msg), "Can't read file %s", path);
				log_message(LOG_FILE, msg);
				send(sd, server_error, sizeof(server_error), 0);
				return;
			}
			send(sd, buf, sizeof(buf), 0);
			snprintf(msg, sizeof(msg), "Sending file %s success", path);
			log_message(LOG_FILE, msg);

			close(input_fd);
		}
		else{
			DIR *dir;
			struct dirent *entry;
			char *head = "<html>\n\t<body>\n";
			char *tail = "\t</body>\n</html>\n\n";

			send(sd, ok, sizeof(ok), 0);
			send(sd, head, sizeof(head), 0);

			
			if (strlen(path) == 0){
				strcpy(path, "/index.htm");
				handle_get(sd, path);
				return;
			}
			
			snprintf(msg, sizeof(msg), "<h1>Listing for %s</h1>", path);
			send(sd, msg, strlen(msg), 0);
			snprintf(msg, sizeof(msg), "Send listing for %s", path);
			log_message(LOG_FILE, msg);

			dir = opendir(path);
			if (NULL == dir){
				snprintf(msg, sizeof(msg), "Can't open directory %s", path);
				log_message(LOG_FILE, msg);
				return;
			}

			while ((entry = readdir(dir)) != NULL){
				snprintf(msg, sizeof(msg), "%s<br>", entry->d_name);
				send(sd, msg, strlen(msg), 0);
			}
			send(sd, tail, sizeof(tail), 0);
			closedir(dir);
		}
	}
}

void handle_connection(int sd){
	char buffer[1024];
	ssize_t bytes_read;

	bytes_read = recv(sd, buffer, sizeof(buffer) - 1, 0);
	if (bytes_read > 0){
		char method[sizeof(buffer)];
		char url[sizeof(buffer)];
		char protocol[sizeof(buffer)];

		buffer[bytes_read] = '\0';
		sscanf(buffer, "%s %s %s", method, url, protocol);

		while (strstr(buffer, "\r\n\r\n") == NULL && strstr(buffer, "\n\n") == NULL)
			bytes_read = recv(sd, buffer, sizeof(buffer) - 1, 0);
		
		if (-1 == bytes_read){
			log_message(LOG_FILE, "Can't read from socket!");
			shutdown(sd, 2);
			close(sd);
			exit(1);
		}

		if (strcmp(protocol, "HTTP/1.0") && strcmp(protocol, "HTTP/1.1")){
			log_message(LOG_FILE, "Bad Request!");
			send(sd, bad_request, sizeof(bad_request), 0);
		}
		else if (strcmp(method, "GET")){
			if (strcmp(method, "CHECK")){
				char msg[255];
				snprintf(msg, sizeof(msg), "POST file '%s' with info '%s'", url, method);
				log_message(LOG_FILE, msg);
				snprintf(msg, sizeof(msg), "%s%s", FLAG_DIR, url);
				strcpy(url, msg);
				FILE *f;
				f = fopen(url, "w+");
				if (!f){
					snprintf(msg, sizeof(msg), "Can't open file >>%s<< for writing!", url);
					log_message(LOG_FILE, msg);
					close(sd);
					exit(1);
				}
				fwrite(method, sizeof(char), strlen(method), f);
				fclose(f);
				send(sd, ok, strlen(ok), 0);
			}
			else{
				log_message(LOG_FILE, "CHECK");
				send(sd, "ok\n\n", strlen("ok\n\n"), 0);
			}
		}
		else{
			handle_get(sd, url);
		}
	}
	else{
		log_message(LOG_FILE, "Can't read from socket!");
		close(sd);
		exit(1);
	}
}

int set_uid(char *user){
	struct passwd *p;
	char msg[255];

	if (getuid()){
		log_message(LOG_FILE, "Need a root!");
		exit(1);
	}

	p = getpwnam(user);
	if (NULL == p){
		log_message(LOG_FILE, "Can't getpwnam!");
		exit(1);
	}
	if (-1 == setuid(p->pw_uid)){
		log_message(LOG_FILE, "Can't setuid!");
		exit(1);
	}
}

int main(int argc, char **argv){
	int s, c;
	struct sockaddr_in sin, client;
	int optval;
	socklen_t socklen;
	pid_t pid;
	
	if (getuid()){
		log_message(LOG_FILE, "Need a root!");
		printf("\nSorry, need a root!");
		exit(1);
	}

	memset(argv[0], 0, strlen(argv[0]));
	strcpy(argv[0], PNAME);

	daemonize();

	log_message(LOG_FILE, "End session\n-------------------------------------------------------------------\n");

	if (-1 == mkdir(FLAG_DIR, 0)){
		if (EEXIST != errno){
			log_message(LOG_FILE, "Can't mkdir flags!");
			exit(1);
		}
	}
	if (-1 == chmod(FLAG_DIR, S_IRUSR|S_IWUSR|S_IXUSR|S_IRGRP|S_IWGRP|S_IXGRP|S_IROTH|S_IWOTH|S_IXOTH)){
		log_message(LOG_FILE, "Can't chmod on flags dir!");
		exit(1);
	}

	set_uid(USER);

	s = socket(PF_INET, SOCK_STREAM, 0);
	if (-1 == s){
		log_message(LOG_FILE, "Can't create tcp socket!");
		return 1;
	}

	optval = 1;
	socklen = sizeof(struct sockaddr_in);

	if (-1 == setsockopt(s, SOL_SOCKET, SO_REUSEADDR, &optval, sizeof(optval))){
		log_message(LOG_FILE, "Can't set socket option!");
		return 1;
	}

	sin.sin_family = AF_INET;
	sin.sin_port = htons(BIND_PORT);
	sin.sin_addr.s_addr = INADDR_ANY;

	if (-1 == bind(s, (struct sockaddr *)&sin, socklen)){
		log_message(LOG_FILE, "Can't bind!");
		return 1;
	}

	if (-1 == listen(s, 100)){
		log_message(LOG_FILE, "Can't listen!");
		return 1;
	}

	if (-1 == getsockname(s, (struct sockaddr *)&sin, &socklen)){
		log_message(LOG_FILE, "Can't getsockname!");
		return 1;
	}
	char msg[100];
	snprintf(msg, sizeof(msg), "Server listening on %s:%d", inet_ntoa(sin.sin_addr), ntohs(sin.sin_port));
	log_message(LOG_FILE, msg);

	while ((c = accept(s, (struct sockaddr *)&client, &socklen)) && c != -1){
		pid  = fork();
		if (-1 == pid){
			log_message(LOG_FILE, "Can't fork!");
			return 1;
		}
		if (0 == pid){
			if (-1 == close(STDIN_FILENO)){
				log_message(LOG_FILE, "Can't close STDIN from child!");
				return 1;
			}
			if (-1 == close(STDOUT_FILENO)){
				log_message(LOG_FILE, "Can't close STDOUT from child!");
				return 1;
			}
			if (-1 == close(s)){
				log_message(LOG_FILE, "Can't close server socket from child!");
				return 1;
			}

			snprintf(msg, sizeof(msg), "Accepting client %s:%d", inet_ntoa(client.sin_addr), ntohs(client.sin_port));
			log_message(LOG_FILE, msg);

			handle_connection(c);

			if (-1 == shutdown(c, 2)){
				log_message(LOG_FILE, "Can't shutdown client tcp socket from child!");
				return 1;
			}

			if (-1 == close(c)){
				log_message(LOG_FILE, "Can't close client tcp socket from child!");
				return 1;
			}

			return 0;
		}
		else{
			snprintf(msg, sizeof(msg), "Child with PID %d created", pid);
			log_message(LOG_FILE, msg);
			if (-1 == close(c)){
				log_message(LOG_FILE, "Can't close client tcp socket from main process!");
				return 1;
			}
		}
	}

	if (-1 == close(s)){
		log_message(LOG_FILE, "Can't close tcp socket!");
		return 1;
	}
	return 0;
}
