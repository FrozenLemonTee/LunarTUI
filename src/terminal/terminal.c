/**
 * @file terminal.c
 * @brief Foreign Function Interface file of the terminal layer
 * 
 * @details This file provides low-level terminal manipulation functions using ANSI escape codes.
 *          It includes functionality for cursor movement, screen clearing, character output,
 *          and output flushing to create responsive terminal-based applications.
 */

#include <stdio.h>
#include <stdint.h>

/**
 * @brief Moves the terminal cursor to the specified position
 * 
 * @details Uses ANSI escape codes to position the cursor at (x, y) coordinates.
 *          Coordinates are converted from zero-based to one-based indexing for the escape sequence.
 * 
 * @param x The zero-based column position (0 = leftmost column)
 * @param y The zero-based row position (0 = top row)
 * 
 * @note The escape sequence format is: \033[y+1;x+1H
 */
void terminal_move_cursor(int32_t x, int32_t y) {
    printf("\033[%d;%dH", y + 1, x + 1);
}

/**
 * @brief Clears the entire terminal screen and homes the cursor
 * 
 * @details Sends two ANSI escape sequences:
 *          - \033[2J: Clears the entire screen
 *          - \033[H: Moves cursor to home position (0,0)
 */
void terminal_clear() {
    printf("\033[2J");
    printf("\033[H"); 
}

/**
 * @brief Outputs a single character to the terminal
 * 
 * @param c The character to be displayed at the current cursor position
 */
void terminal_put_char(char c) {
    putchar(c);
}

/**
 * @brief Flushes the output buffer to ensure immediate display
 * 
 * @details Forces any buffered output to be written to the terminal immediately.
 *          This is essential for real-time TUI applications where timely display updates are critical.
 */
void terminal_flush() {
    fflush(stdout);
}

/**
 * @brief Moves the cursor to the beginning of the next line
 * 
 * @details Sends carriage return and line feed characters (\r\n) to advance to the next line.
 *          This is equivalent to pressing Enter in a terminal.
 */
void terminal_newline() {
    printf("\r\n");
}