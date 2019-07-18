#include <assert.h>
#include <stdio.h>
#include <unistd.h>
#include <stdint.h>
#include <xcb/xcb.h>

int main() {
    xcb_connection_t *conn = NULL;
    xcb_screen_t *screen = NULL;
    xcb_window_t win;
    xcb_gcontext_t foreground;
    xcb_generic_event_t *event;
    xcb_generic_error_t *error;
    xcb_screen_iterator_t iter;
    xcb_get_selection_owner_cookie_t getsel_cookie;
    xcb_get_selection_owner_reply_t *getsel_reply;
    xcb_get_property_cookie_t getprop_cookie;
    xcb_get_property_reply_t *getprop_reply;
    int proplen;
    char *propval;
    int screennum;
    uint32_t mask = 0;
    uint32_t values[2] = {0};

    conn = xcb_connect(NULL, &screennum);
    assert(conn);

    iter = xcb_setup_roots_iterator(xcb_get_setup(conn));
    for (; iter.rem; --screennum, xcb_screen_next(&iter)) {
        if (screennum == 0) {
            screen = iter.data;
            break;
        }
    }

    assert(screen);

    printf("screen %ld info:\n", screen->root);
    printf("wxd: %dx%d\n", screen->width_in_pixels, screen->height_in_pixels);
    printf("white: %ld\n", screen->white_pixel);
    printf("black: %ld\n", screen->black_pixel);

    getsel_cookie = xcb_get_selection_owner(conn, XCB_ATOM_PRIMARY);
    getsel_reply = xcb_get_selection_owner_reply(conn, getsel_cookie, &error);
    if (!getsel_reply) {
        printf("get selection error: %d\n", error->error_code);
        return 1;
    }

    getprop_cookie = xcb_get_property(conn,
                                      0,
                                      getsel_reply->owner,
                                      XCB_ATOM_WM_NAME,
                                      XCB_ATOM_STRING,
                                      0,
                                      32);
    getprop_reply = xcb_get_property_reply(conn, getprop_cookie, &error);
    if (!getprop_reply) {
        printf("get property error: %d\n", error->error_code);
        return 1;
    }

    proplen = xcb_get_property_value_length(getprop_reply);
    propval = xcb_get_property_value(getprop_reply);
    printf("window title: %.*s\n", proplen, propval);

    xcb_disconnect(conn);

    return 0;
}
