///|
/// Represents a single character cell in the terminal interface.
///
/// A Cell contains a character and its display attributes, serving as the
/// fundamental building block for terminal rendering.
pub struct Cell {
  /// The character displayed in this cell.
  ///
  /// Stores the Unicode character to be rendered at this cell's position.
  /// Defaults to space character when not specified.
  mut char : Char
} derive(Eq)

///|
/// Creates a new Cell with the specified character.
///
/// # Parameters
/// * `ch`: The character to display in the cell (optional, defaults to space)
///
/// # Returns
/// A new Cell instance containing the specified character.
fn Cell::new(ch? : Char = ' ') -> Cell {
  Cell::{ char: ch }
}

///|
/// Updates the character in the cell.
///
/// # Parameters
/// * `self`: The cell to modify
/// * `ch`: The new character to set in the cell
///
/// # Returns
/// Unit, indicating the operation is performed for side effects.
fn Cell::set(self : Cell, ch : Char) -> Unit {
  self.char = ch
}
