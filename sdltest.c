/* Test SDL
 *
 * Compile:
 * clang -lsdl2 sdltest.c && ./a.out
 */
#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <SDL2/SDL.h>
#include <SDL2/SDL_video.h>
#include <SDL2/SDL_render.h>

#define PIXEL_SIZE 2
#define TILE_SIZE (PIXEL_SIZE * 8)
#define N_TILE_X 32
#define N_TILE_Y 30
#define WIN_W (N_TILE_X * TILE_SIZE)
#define WIN_H (N_TILE_Y * TILE_SIZE)

int main(int argc, char *argv[])
{
    srand(time(NULL));

    if (SDL_Init(SDL_INIT_VIDEO) != 0)
        perror("SDL_Init");

    SDL_Window *w = SDL_CreateWindow("test window",
                                     SDL_WINDOWPOS_CENTERED,
                                     SDL_WINDOWPOS_CENTERED,
                                     WIN_W, WIN_H,
                                     SDL_WINDOW_RESIZABLE);
    if (!w)
        perror("SDL_CreateWindow");

    SDL_Renderer *r = SDL_CreateRenderer(w, -1, 0);
    if (!r)
        perror("SDL_Renderer");

    int quit = 0;
    while (!quit) {
        SDL_Event e;
        while (SDL_PollEvent(&e)) {
            if (e.type == SDL_QUIT)
                quit = 1;
        }

        SDL_RenderClear(r);
        unsigned x, y;
        SDL_Color *base;
        for (y = 0; y < N_TILE_Y; y++) {
            for (x = 0; x < N_TILE_X; x++) {
                SDL_Rect rect = {
                    .x = x * TILE_SIZE,
                    .y = y * TILE_SIZE,
                    .w = TILE_SIZE * PIXEL_SIZE,
                    .h = TILE_SIZE * PIXEL_SIZE,
                };
                SDL_SetRenderDrawColor(r,
                                       rand() % 256,
                                       rand() % 256,
                                       rand() % 256,
                                       SDL_ALPHA_OPAQUE);
                SDL_RenderFillRect(r, &rect);
                SDL_RenderDrawRect(r, &rect);
            }
        }
        SDL_RenderPresent(r);
    }

    SDL_DestroyRenderer(r);
    SDL_DestroyWindow(w);
    SDL_Quit();

    return 0;
}
