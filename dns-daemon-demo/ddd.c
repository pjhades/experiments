#include <getopt.h>
#include <err.h>
#include <stdio.h>
#include <stdlib.h>
#include <error.h>

void usage(void)
{
    errx(EXIT_SUCCESS,
         "ddd - DNS-daemon-demo\n"
         "Usage: ddd [Options]\n"
         "Options:\n"
         "     --help  Print this message");
}

int main(int argc, char **argv)
{
    const struct option long_opts[] = {
        {"help", no_argument, NULL, 'H'},
        {0, 0, 0, 0},
    };

    int val;
    while ((val = getopt_long(argc, argv, "", long_opts, NULL)) != -1) {
        switch (val) {
            case 'H':
                usage();
                break;
            case '?':
            default:
                errx(EXIT_FAILURE,
                     "Use --help to see a full list of options");
        }
    }

    printf("hello\n");
    return 0;
}
