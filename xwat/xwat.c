#include <assert.h>
#include <err.h>
#include <locale.h>
#include <stdarg.h>
#include <stdbool.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <xcb/xcb.h>
#include <xcb/xcb_icccm.h>

#define die(fmt, ...) errx(EXIT_FAILURE, fmt, ##__VA_ARGS__)

struct xcbinfo {
    xcb_connection_t *conn;
    xcb_screen_t *screen;
    xcb_window_t win;
} xcb;

struct selection {
    size_t len;
    char buf[0];
};

enum {
    UTF8_STRING,
    SELECTION_DATA,
    NR_ATOMS,
};

xcb_atom_t atoms[NR_ATOMS];

#define arraylen(array) \
    (sizeof(array) / sizeof(array[0]))

bool init_atoms(xcb_connection_t *conn) {
    xcb_generic_error_t *error;

#define name_ptr_pair(x) { #x, &atoms[x] }
    struct { const char *name; xcb_atom_t *ptr; } pairs[] = {
        name_ptr_pair(UTF8_STRING),
        name_ptr_pair(SELECTION_DATA),
    };

    for (size_t i = 0; i < arraylen(pairs); i++) {
        xcb_intern_atom_cookie_t ck = xcb_intern_atom(conn, 0, strlen(pairs[i].name), pairs[i].name);
        xcb_intern_atom_reply_t *rep = xcb_intern_atom_reply(conn, ck, &error);
        if (!rep) {
            die("intern atom error: %d\n", error->error_code);
            return false;
        }
        *pairs[i].ptr = rep->atom;
        free(rep);
    }

    return true;
}

struct selection *get_selection(xcb_selection_notify_event_t *se,
        uint32_t *offset, uint32_t *left)
{
    xcb_get_property_cookie_t ck = xcb_get_property(xcb.conn, 0,
            se->requestor, se->property, se->target, *offset, 1024);
    xcb_get_property_reply_t *reply = xcb_get_property_reply(xcb.conn, ck, NULL);
    if (!reply)
        return NULL;

    uint32_t len = xcb_get_property_value_length(reply);
    struct selection *sel = malloc(sizeof(*sel) + len);
    if (!sel)
        return NULL;
    sel->len = len;
    strncpy(sel->buf, (char *)xcb_get_property_value(reply), sel->len);

    *offset += sel->len;
    *left = reply->bytes_after;

    free(reply);
    xcb_delete_property(xcb.conn, se->requestor, se->property);
    return sel;
}

int main() {
    xcb.conn = xcb_connect(NULL, NULL);
    if (!xcb.conn)
        die("failed to connect display");

    if (!init_atoms(xcb.conn))
        die("failed to initialize atoms");

    xcb.screen = xcb_setup_roots_iterator(xcb_get_setup(xcb.conn)).data;
    if (!xcb.screen)
        die("failed to get default screen");

    uint32_t mask = XCB_CW_BACK_PIXEL |
                    XCB_CW_OVERRIDE_REDIRECT |
                    XCB_CW_EVENT_MASK;
    uint32_t values[] = {
        xcb.screen->white_pixel,
        1,
        XCB_EVENT_MASK_PROPERTY_CHANGE,
    };

    xcb.win = xcb_generate_id(xcb.conn);
    xcb_create_window(xcb.conn, 0, xcb.win, xcb.screen->root,
            0, 0, 1, 1, 0, XCB_WINDOW_CLASS_INPUT_OUTPUT,
            xcb.screen->root_visual, mask, values);
    xcb_convert_selection(xcb.conn, xcb.win, XCB_ATOM_PRIMARY,
            atoms[UTF8_STRING], atoms[SELECTION_DATA],
            XCB_TIME_CURRENT_TIME);
    xcb_flush(xcb.conn);

    xcb_generic_event_t *event;
    while ((event = xcb_wait_for_event(xcb.conn))) {
        if ((event->response_type & ~0x80) != XCB_SELECTION_NOTIFY)
            continue;

        xcb_selection_notify_event_t *se = (xcb_selection_notify_event_t *)event;
        if (se->requestor != xcb.win ||
                se->selection != XCB_ATOM_PRIMARY ||
                se->property == XCB_ATOM_NONE)
            break;

        uint32_t offset = 0, left = 0;
        do {
            struct selection *sel = get_selection(se, &offset, &left);
            printf("%.*s\n", sel->len, sel->buf);
            free(sel);
        }
        while (left > 0);
        free(event);
        break;
    }

    xcb_disconnect(xcb.conn);

    return 0;
}
