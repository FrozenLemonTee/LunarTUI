///|
/// Represents a character buffer for terminal display.
///
/// A Buffer maintains a 2D grid of cells within a defined area, providing
/// efficient manipulation and comparison of terminal content.
pub struct Buffer {
  /// The dimensions of the buffer area.
  area : Area
  /// The array of cells storing the buffer content in row-major order.
  contents : Array[Cell]
} derive(Eq)

///|
/// Creates a new Buffer with the specified area dimensions.
///
/// # Parameters
/// * `area`: The dimensions of the buffer area
///
/// # Returns
/// A new Buffer instance filled with space characters.
///
/// # Examples
/// ```moonbit
/// let area = Area::new(10, 5)
/// let buffer = Buffer::new(area)  // Creates a 10x5 buffer
/// ```
pub fn Buffer::new(area : Area) -> Buffer {
  let contents = Array::default()
  for i in 0..<area.size() {
    contents.push(Cell::new())
  }
  Buffer::{ area, contents }
}

///|
/// Gets the height of the buffer.
///
/// # Parameters
/// * `self`: The Buffer instance
///
/// # Returns
/// The height of the buffer in character rows.
pub fn Buffer::height(self : Buffer) -> Int {
  self.area.height
}

///|
/// Gets the width of the buffer.
///
/// # Parameters
/// * `self`: The Buffer instance
///
/// # Returns
/// The width of the buffer in character columns.
pub fn Buffer::width(self : Buffer) -> Int {
  self.area.width
}

///|
/// Converts 2D coordinates to a 1D array index.
///
/// # Parameters
/// * `self`: The Buffer instance
/// * `x`: The column coordinate (0-based)
/// * `y`: The row coordinate (0-based)
///
/// # Returns
/// The corresponding index in the contents array.
///
/// # Panics
/// May panic if coordinates are outside buffer bounds.
pub fn Buffer::get_index(self : Buffer, x : Int, y : Int) -> Int {
  let width = self.width()
  y * width + x
}

///|
/// Converts a 1D array index to 2D coordinates.
///
/// # Parameters
/// * `self`: The Buffer instance
/// * `index`: The index in the contents array
///
/// # Returns
/// A tuple (x, y) representing the column and row coordinates.
pub fn Buffer::get_pos(self : Buffer, index : Int) -> (Int, Int) {
  let width = self.width()
  (index % width, index / width)
}

///|
/// Sets a character at the specified position in the buffer.
///
/// # Parameters
/// * `self`: The Buffer instance
/// * `x`: The column coordinate
/// * `y`: The row coordinate
/// * `char`: The character to set
///
/// # Returns
/// Unit, indicating the operation is performed for side effects.
///
/// # Examples
/// ```moonbit
/// let buffer = Buffer::new(Area::new(10, 5))
/// buffer.set_chars(2, 3, 'A')  // Sets 'A' at position (2,3)
/// ```
pub fn Buffer::set_chars(self : Buffer, x : Int, y : Int, char : Char) -> Unit {
  let idx = self.get_index(x, y)
  self.contents[idx].set(char)
}

///|
/// Compares two buffers and returns the differences.
///
/// # Parameters
/// * `self`: The current buffer
/// * `other`: The buffer to compare against
///
/// # Returns
/// An iterator over position and cell pairs that differ between buffers.
/// Each element is of the form ((x, y), (current_cell, other_cell)).
///
/// # Examples
/// ```moonbit
/// let buf1 = Buffer::new(Area::new(3, 2))
/// let buf2 = Buffer::new(Area::new(3, 2))
/// buf1.set_chars(1, 1, 'X')
/// let changes = buf1.diff(buf2)  // Returns differences at position (1,1)
/// ```
pub fn Buffer::diff(
  self : Buffer,
  other : Buffer,
) -> Iter[((Int, Int), (Cell, Cell))] {
  self.contents
  .zip_to_iter2(other.contents)
  .iter()
  .iter2()
  .iter()
  .filter(fn(cur) { cur.1.0 != cur.1.1 })
  .map(fn(cur) { (self.get_pos(cur.0), cur.1) })
}
