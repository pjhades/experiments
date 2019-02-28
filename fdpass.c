/* This fd passing must be performed with:
 *   - unix domain socket   unix(7)
 *   - sendmsg/recvmsg      sendmsg(2) recvmsg(2)
 *   - cmsg ancillary data  cmsg(3)
 *
 * Kernel call path on sending:
 *
 *   unix_dgram_sendmsg
 *   scm_send
 *   __scm_send
 *   scm_fp_copy
 *
 *   In __scm_send kernel traverses each cmsghdr. If the
 *   cmsg_type is SCM_RIGHTS, it calls scm_fp_copy to copy
 *   all the struct file associated to each given fd. Thus
 *   it is the struct file that gets copied actually, not
 *   the fd itself.
 *
 * Kernel call path on receiving:
 *
 *   unix_dgram_recvmsg
 *   scm_recv
 *   scm_detach_fds
 *
 *   scm_detach_fds will only be called if there's passed
 *   struct files. There kernel then:
 *     - traverses all the struct file
 *     - call get_unused_fd_flags to allocate an unused fd for each file
 *     - call put_user to store the allocated fd in user space,
 *       in the cmsghdr data field
 *     - call fd_install to link the allocated fd to the struct file in the receiving
 *       process's fd table
 *
 *
 * Run this code:
 *
 *   $ ./fdpass recv ./sock
 *   $ # in other shell session
 *   $ ./fdpass send ./sock ./textfile
 *
 * Uncomment the two while (true); statements and
 * check the open files with
 *
 *   $ lsof -p PID          # both processes will have ./textfile opened
 *   $ lsof +fG ./textfile  # both processes will have the same open flags
 * */

#include <err.h>
#include <fcntl.h>
#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <string.h>
#include <stdbool.h>
#include <sys/socket.h>
#include <sys/un.h>
#include <unistd.h>

enum {
    BUFLEN = 1024
};

int main(int argc, char *argv[]) {
    int sockfd;
    int filefd;
    int commlen;
    char buf[BUFLEN];
    struct sockaddr_un addr;
    struct iovec iov;
	struct msghdr msg;
    struct cmsghdr *cmsg;
    union {
        struct cmsghdr hdr;
        uint8_t buf[CMSG_SPACE(sizeof(int))];
    } ctrl;

    if ((argc != 3 && argc != 4)
            || (argc == 3 && strcmp(argv[1], "send") == 0)
            || (argc == 4 && strcmp(argv[1], "recv") == 0))
    {
        errx(1, "usage: `fdpass send sock file` or `fdpass recv sock`");
    }

    sockfd = socket(AF_UNIX, SOCK_DGRAM, 0);
    if (sockfd == -1)
        err(1, "socket");

    addr.sun_family = AF_UNIX;
    strncpy(addr.sun_path, argv[2], strlen(argv[2]) + 1);

    msg.msg_name = NULL;
    msg.msg_namelen = 0;
    msg.msg_control = ctrl.buf;
    msg.msg_controllen = sizeof(ctrl.buf);

    printf("pid %d\n", getpid());

    if (strcmp(argv[1], "send") == 0) {
        if (connect(sockfd, (struct sockaddr *)&addr, sizeof(addr)) == -1)
            err(1, "bind");

        // the two processes will have the same open flags
        filefd = open(argv[3], O_RDWR);
        if (filefd == -1)
            err(1, "open");
        printf("sender opens fd %d\n", filefd);

        cmsg = CMSG_FIRSTHDR(&msg);
        cmsg->cmsg_len = CMSG_LEN(sizeof(int));
        cmsg->cmsg_level = SOL_SOCKET;
        cmsg->cmsg_type = SCM_RIGHTS;
        *((int *)CMSG_DATA(cmsg)) = filefd;

        iov.iov_base = argv[3];
        iov.iov_len = strlen(argv[3]);
        msg.msg_iov = &iov;
        msg.msg_iovlen = 1;

        if (sendmsg(sockfd, &msg, 0) == -1)
            err(1, "sendmsg");

        //while (true);
        close(filefd);
    }
    else if (strcmp(argv[1], "recv") == 0) {
        if (bind(sockfd, (struct sockaddr *)&addr, sizeof(addr)) == -1)
            err(1, "bind");

        iov.iov_base = buf;
        iov.iov_len = BUFLEN;
        msg.msg_iov = &iov;
        msg.msg_iovlen = 1;

        commlen = recvmsg(sockfd, &msg, 0);
        if (commlen == -1)
            err(1, "recvmsg");

        cmsg = CMSG_FIRSTHDR(&msg);
        if (!cmsg)
            err(1, "recv null data");
        if (cmsg->cmsg_len != CMSG_LEN(sizeof(int)))
            err(1, "data recved has bad length");
        if (cmsg->cmsg_level != SOL_SOCKET)
            err(1, "data recved has bad level");
        if (cmsg->cmsg_type != SCM_RIGHTS)
            err(1, "data recved has bad type");

        filefd = *((int *)CMSG_DATA(cmsg));
        printf("recved msg %.*s\n", commlen, buf);
        printf("recved fd %d\n", filefd);

        commlen = read(filefd, buf, BUFLEN);
        if (commlen == -1)
            err(1, "write to filefd");
        printf("file content: %.*s\n", commlen, buf);

        if (write(filefd, "haha", 4) == -1)
            err(1, "write");
        printf("write to file\n");

        //while (true);
        close(filefd);
    }

    return 0;
}
