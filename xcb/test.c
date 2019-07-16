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
    xcb_screen_iterator_t iter;
    int screennum;
    uint32_t mask = 0;
    uint32_t values[2] = {0};

    xcb_rectangle_t rectangles[] = {
        {10, 50, 40, 20},
        {80, 50, 10, 40},
    };

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

    foreground = xcb_generate_id(conn);
    mask = XCB_GC_FOREGROUND | XCB_GC_GRAPHICS_EXPOSURES;
    values[0] = screen->black_pixel;
    values[1] = 0;
    xcb_create_gc(conn, foreground, win, mask, values);

    /* create new window */
    win = xcb_generate_id(conn);
    mask = XCB_CW_BACK_PIXEL | XCB_CW_EVENT_MASK;
    values[0] = screen->white_pixel;
    values[1] = XCB_EVENT_MASK_EXPOSURE;
    xcb_create_window(conn,
                      XCB_COPY_FROM_PARENT,
                      win,
                      screen->root,
                      0, 0,
                      300, 300,
                      10,
                      XCB_WINDOW_CLASS_INPUT_OUTPUT,
                      screen->root_visual,
                      mask,
                      values);
    xcb_map_window(conn, win);
    xcb_flush(conn);

    while (event = xcb_wait_for_event(conn)) {
        switch (event->response_type & ~0x80) {
            case XCB_EXPOSE:
                xcb_poly_rectangle(conn, win, foreground, 2, rectangles);
                xcb_flush(conn);
                break;
            default:
                break;
        }
    }

    xcb_disconnect(conn);

    return 0;
}
