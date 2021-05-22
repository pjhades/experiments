#define _POSIX_C_SOURCE 200112L

#include "common.h"
#include "config.h"
#include "log.h"
#include <netdb.h>
#include <sys/types.h>
#include <sys/socket.h>

static int udp_listen(struct config *conf)
{
    struct addrinfo *res, hint = {
        .ai_flags = AI_NUMERICSERV | AI_PASSIVE,
        .ai_family = AF_INET,
        .ai_socktype = SOCK_DGRAM,
        .ai_protocol = 0,
    };

    int ret = getaddrinfo(NULL, conf->port, &hint, &res);
    if (ret != 0)
        errx(EXIT_FAILURE, "getaddrinfo: %s", gai_strerror(ret));

    int sock = -1;
    for (struct addrinfo *info = res; info; info = info->ai_next) {
        sock = socket(info->ai_family,
                      info->ai_socktype,
                      info->ai_protocol);
        if (sock == -1)
            err(EXIT_FAILURE, "socket");
        if (bind(sock, info->ai_addr, info->ai_addrlen) == -1) {
            close(sock);
            err(EXIT_FAILURE, "bind");
        }
        break;
    }

    freeaddrinfo(res);
    return sock;
}

void loop(struct config *conf)
{
    int sock = udp_listen(conf);
    log_init(conf->prog);
    log_info("listening on UDP port %s", conf->port);
}
