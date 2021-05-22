#pragma once

#include <syslog.h>

static inline void log_init(const char *ident)
{
    openlog(ident, LOG_NDELAY | LOG_PID, LOG_USER);
}

#define log_err(fmt, ...) syslog(LOG_ERR, fmt, __VA_ARGS__)
#define log_info(fmt, ...) syslog(LOG_INFO, fmt, __VA_ARGS__)
#define log_dbg(fmt, ...) syslog(LOG_DEBUG, fmt, __VA_ARGS__)
