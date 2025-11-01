///|
/// Foreign function interface for terminal manipulation using ANSI escape codes.
/// 
/// This module provides low-level terminal control functions including cursor movement,
/// screen clearing, character output, and output flushing for responsive TUI applications.
extern "c" fn terminal_clear() -> Unit = "terminal_clear"

///|
/// Moves the terminal cursor to the specified position.
/// 
/// Uses ANSI escape codes to position the cursor at (x, y) coordinates.
/// Coordinates are converted from zero-based to one-based indexing for the escape sequence.
/// 
/// # Parameters
/// * `x`: The zero-based column position (0 = leftmost column)
/// * `y`: The zero-based row position (0 = top row)
/// 
/// @note The escape sequence format is: \033[y+1;x+1H
extern "c" fn terminal_move_cursor(x : Int, y : Int) -> Unit = "terminal_move_cursor"

///|
/// Outputs a single Unicode code point as UTF-8 to the terminal.
/// 
/// This function takes a Unicode code point and encodes it as UTF-8 for output
/// to the terminal. It supports the full Unicode range from U+0000 to U+10FFFF.
/// The function handles encoding for:
/// - ASCII characters (U+0000 to U+007F): 1 byte
/// - Two-byte UTF-8 sequence (U+0080 to U+07FF)
/// - Three-byte UTF-8 sequence (U+0800 to U+FFFF)
/// - Four-byte UTF-8 sequence (U+10000 to U+10FFFF)
/// 
/// # Parameters
/// * `ch`: The Unicode code point to be displayed at the current cursor position.
///          Must be a valid Unicode code point (0 to 0x10FFFF).
/// 
/// @note Invalid code points (negative or above U+10FFFF) are silently ignored.
/// @note The terminal must support UTF-8 encoding for non-ASCII characters to display correctly.
extern "c" fn terminal_put_char(ch : Char) -> Unit = "terminal_put_char"

///|
/// Flushes the output buffer to ensure immediate display.
/// 
/// Forces any buffered output to be written to the terminal immediately.
/// This is essential for real-time TUI applications where timely display updates are critical.
extern "c" fn terminal_flush() -> Unit = "terminal_flush"

///|
/// Moves the cursor to the beginning of the next line.
/// 
/// Sends carriage return and line feed characters (\r\n) to advance to the next line.
/// This is equivalent to pressing Enter in a terminal.
extern "c" fn terminal_newline() -> Unit = "terminal_newline"

///|
/// High-level terminal interface with double buffering for efficient rendering.
/// 
/// The Terminal struct maintains two buffers (last and current) to enable efficient
/// terminal rendering by comparing and updating only the changed portions of the display.
/// This prevents flickering and improves performance by minimizing screen updates.
pub struct Terminal {
  /// The previous frame's buffer content used for change detection.
  mut last : @base.Buffer
  /// The current frame's buffer content containing the latest render state.
  mut cur : @base.Buffer
}

///|
/// Clears the entire terminal screen and homes the cursor.
/// 
/// Sends two ANSI escape sequences:
/// - \033[2J: Clears the entire screen
/// - \033[H: Moves cursor to home position (0,0)
pub fn Terminal::clear() -> Unit {
  terminal_clear()
}

///|
/// Moves the terminal cursor to the specified position.
/// 
/// # Parameters
/// * `x`: The zero-based column position (0 = leftmost column)
/// * `y`: The zero-based row position (0 = top row)
pub fn Terminal::move_cursor(x : Int, y : Int) -> Unit {
  terminal_move_cursor(x, y)
}

///|
/// Outputs a single Unicode character at the current cursor position.
/// 
/// # Parameters
/// * `ch`: The Unicode character to display
pub fn Terminal::put_char(ch : Char) -> Unit {
  terminal_put_char(ch)
}

///|
/// Flushes the output buffer to ensure immediate display.
/// 
/// Essential for real-time TUI applications where timely display updates are critical.
pub fn Terminal::flush() -> Unit {
  terminal_flush()
}

///|
/// Moves the cursor to the beginning of the next line.
pub fn Terminal::newline() -> Unit {
  terminal_newline()
}

///|
/// Creates a new Terminal instance with the specified display area.
/// 
/// # Parameters
/// * `area`: The dimensions of the terminal display area
/// 
/// # Returns
/// A new Terminal instance with initialized double buffers.
pub fn Terminal::new(area : @base.Area) -> Terminal {
  Terminal::{ last: @base.Buffer::new(area), cur: @base.Buffer::new(area) }
}

///|
/// Renders a widget to the terminal using double buffering.
/// 
/// This method renders the widget to the current buffer, applies only the changed
/// characters to the terminal, and then swaps buffers for the next render cycle.
/// 
/// # Parameters
/// * `self`: The Terminal instance
/// * `widget`: The widget to render
/// 
/// # Performance
/// Only changed characters are sent to the terminal, minimizing flickering and
/// improving rendering performance for complex UI updates.
pub fn Terminal::draw(self : Terminal, widget : &@base.Widget) -> Unit {
  let frame = @base.Frame::new(
    self.cur,
    @base.Section::new(
      @base.Area::new(self.cur.width(), self.cur.height()),
      0,
      0,
    ),
  )
  widget.render(frame)
  self.cur = frame.buf
  self.apply()
  self.swap()
}

///|
/// Swaps the current and last buffers for double buffering.
/// 
/// This internal method exchanges the current and previous frame buffers
/// to prepare for the next render cycle.
fn Terminal::swap(self : Terminal) -> Unit {
  let tmp = self.cur
  self.cur = self.last
  self.last = tmp
}

///|
/// Applies only the changed characters to the terminal.
/// 
/// This internal method compares the current and last buffers, and only
/// updates the terminal positions where characters have changed.
/// 
/// # Efficiency
/// By only updating changed characters, this method significantly reduces
/// the amount of data sent to the terminal and improves rendering performance.
fn Terminal::apply(self : Terminal) -> Unit {
  let diff = self.cur.diff(self.last)
  for item in diff {
    let (x, y) = item.0
    let (new, _) = item.1
    Terminal::move_cursor(x, y)
    Terminal::put_char(new.char)
  }
  Terminal::flush()
}
