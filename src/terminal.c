#include <stdio.h>
#include <stdint.h>


void terminal_move_cursor(int32_t x, int32_t y) {
    printf("\033[%d;%dH", y + 1, x + 1);
}

void terminal_clear() {
    printf("\033[2J");
}

void terminal_put_char(char c) {
    putchar(c);
}

void terminal_flush() {
    fflush(stdout);
}
