///|
pub struct Cell {
  mut char : Char
} derive(Eq)

///|
fn Cell::new(ch? : Char = ' ') -> Cell {
  Cell::{ char: ch }
}

///|
fn Cell::set(self : Cell, ch : Char) -> Unit {
  self.char = ch
}
