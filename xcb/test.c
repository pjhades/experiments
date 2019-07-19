#include <assert.h>
#include <locale.h>
#include <stdbool.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <xcb/xcb.h>
//#include <xcb/xcb_ewmh.h>

enum {
    _NET_WM_NAME = 0,
    UTF8_STRING,
    SELECTION_CONTENT,
    NR_ATOMS,
};

xcb_atom_t atoms[NR_ATOMS];

#define arraylen(array) \
    (sizeof(array) / sizeof(array[0]))

bool init_atoms(xcb_connection_t *conn) {
    xcb_generic_error_t *error;

#define name_ptr_pair(x) { #x, &atoms[x] }
    struct { const char *name; xcb_atom_t *ptr; } pairs[] = {
        name_ptr_pair(_NET_WM_NAME),
        name_ptr_pair(UTF8_STRING),
        name_ptr_pair(SELECTION_CONTENT),
    };
    for (size_t i = 0; i < arraylen(pairs); i++) {
        xcb_intern_atom_cookie_t ck = xcb_intern_atom(conn, 0, strlen(pairs[i].name), pairs[i].name);
        xcb_intern_atom_reply_t *rep = xcb_intern_atom_reply(conn, ck, &error);
        if (!rep) {
            printf("interm atom error: %d\n", error->error_code);
            return false;
        }
        *pairs[i].ptr = rep->atom;
        free(rep);
        printf("name: %s, atom: %u\n", pairs[i].name, *pairs[i].ptr);
    }
    return true;
}


int main() {
    xcb_generic_error_t *error;

    setlocale(LC_ALL, "");

    //xcb_ewmh_connection_t ewmh = {0};
    xcb_connection_t *conn = NULL;
    conn = xcb_connect(NULL, NULL);
    assert(conn);

    assert(init_atoms(conn));

    //xcb_intern_atom_cookie_t *atom_cookie = xcb_ewmh_init_atoms(conn, &ewmh);
    //error = NULL;
    //xcb_ewmh_init_atoms_replies(&ewmh, atom_cookie, &error);
    //if (error) {
    //    printf("ewmh init atoms error: %d\n", error->error_code);
    //    return 1;
    //}

    xcb_screen_t *screen = xcb_setup_roots_iterator(xcb_get_setup(conn)).data;
    assert(screen);

    uint32_t mask = XCB_CW_BACK_PIXEL |
                    XCB_CW_EVENT_MASK;
    uint32_t values[] = {
        screen->white_pixel,
        XCB_EVENT_MASK_PROPERTY_CHANGE,
    };

    xcb_window_t win = xcb_generate_id(conn);
    xcb_create_window(conn,
                      0,
                      win,
                      screen->root,
                      0, 0,
                      300, 300,
                      0,
                      XCB_WINDOW_CLASS_INPUT_OUTPUT,
                      screen->root_visual,
                      mask,
                      values);
    xcb_map_window(conn, win);
    xcb_flush(conn);

    xcb_get_selection_owner_cookie_t getsel_cookie;
    xcb_get_selection_owner_reply_t *getsel_reply;
    xcb_get_property_cookie_t getprop_cookie;
    xcb_get_property_reply_t *getprop_reply;
    int proplen;
    char *propval;

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
                                      //atoms[_NET_WM_NAME],
                                      //atoms[UTF8_STRING],
                                      0,
                                      32);
    getprop_reply = xcb_get_property_reply(conn, getprop_cookie, &error);
    if (!getprop_reply) {
        printf("get property error: %d\n", error->error_code);
        return 1;
    }

    proplen = xcb_get_property_value_length(getprop_reply);
    propval = xcb_get_property_value(getprop_reply);
    printf("length: %d\n", proplen);
    printf("selection owner: %.*s\n", proplen, propval);

    xcb_convert_selection(conn,
                          win,
                          XCB_ATOM_PRIMARY,
                          //atoms[UTF8_STRING],
                          XCB_ATOM_STRING,
                          atoms[SELECTION_CONTENT],
                          XCB_TIME_CURRENT_TIME);
    xcb_flush(conn);

    xcb_generic_event_t *event;
    while ((event = xcb_wait_for_event(conn))) {
        switch (event->response_type & ~0x80) {
            case XCB_SELECTION_NOTIFY: {
                xcb_selection_notify_event_t *sel_event = (xcb_selection_notify_event_t *)event;
                printf("selection received: ");

                assert(sel_event->requestor == win);
                assert(sel_event->selection == XCB_ATOM_PRIMARY);

                if (sel_event->property != XCB_ATOM_NONE) {
                    getprop_cookie = xcb_get_property(conn,
                                                      0,
                                                      win,
                                                      sel_event->property,
                                                      //atoms[UTF8_STRING],
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
                    printf("%.*s\n", proplen, propval);
                    printf("selection length: %d\n", proplen);
                }
                break;
            }
            default:
                printf("other event\n");
        }
        free(event);
    }

    xcb_disconnect(conn);

    return 0;
}
