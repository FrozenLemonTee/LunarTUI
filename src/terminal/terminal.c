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
 * @brief Outputs a single Unicode code point as UTF-8 to the terminal
 * 
 * @details This function takes a Unicode code point and encodes it as UTF-8 for output
 *          to the terminal. It supports the full Unicode range from U+0000 to U+10FFFF.
 *          The function handles encoding for:
 *          - ASCII characters (U+0000 to U+007F): 1 byte
 *          - Two-byte UTF-8 sequence (U+0080 to U+07FF)
 *          - Three-byte UTF-8 sequence (U+0800 to U+FFFF)
 *          - Four-byte UTF-8 sequence (U+10000 to U+10FFFF)
 * 
 * @param ch The Unicode code point to be displayed at the current cursor position.
 *           Must be a valid Unicode code point (0 to 0x10FFFF).
 * 
 * @note Invalid code points (negative or above U+10FFFF) are silently ignored.
 * @note The terminal must support UTF-8 encoding for non-ASCII characters to display correctly.
 */
void terminal_put_char(int32_t ch) {
    unsigned char buf[5];
    int len = 0;
    if (ch < 0) return;
    if (ch <= 0x7F) {
        buf[0] = (unsigned char)ch;
        len = 1;
    } else if (ch <= 0x7FF) {
        buf[0] = 0xC0 | (unsigned char)(ch >> 6);
        buf[1] = 0x80 | (unsigned char)(ch & 0x3F);
        len = 2;
    } else if (ch <= 0xFFFF) {
        buf[0] = 0xE0 | (unsigned char)(ch >> 12);
        buf[1] = 0x80 | (unsigned char)((ch >> 6) & 0x3F);
        buf[2] = 0x80 | (unsigned char)(ch & 0x3F);
        len = 3;
    } else if (ch <= 0x10FFFF) {
        buf[0] = 0xF0 | (unsigned char)(ch >> 18);
        buf[1] = 0x80 | (unsigned char)((ch >> 12) & 0x3F);
        buf[2] = 0x80 | (unsigned char)((ch >> 6) & 0x3F);
        buf[3] = 0x80 | (unsigned char)(ch & 0x3F);
        len = 4;
    } else {
        return;
    }
    fwrite(buf, 1, len, stdout);
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