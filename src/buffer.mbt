///|
pub struct Buffer {
  area : Area
  contents : Array[Cell]
} derive(Eq)

///|
pub fn Buffer::new(area : Area) -> Buffer {
  Buffer::{ area, contents: Array::make(area.size(), Cell::new()) }
}

///|
pub fn Buffer::height(self : Buffer) -> Int {
  self.area.height
}

///|
pub fn Buffer::width(self : Buffer) -> Int {
  self.area.width
}

///|
pub fn Buffer::get_index(self : Buffer, x : Int, y : Int) -> Int {
  let height = self.height()
  let width = self.width()
  if x < 0 || x >= width {
    abort(
      "index out of bounds: x is expected from 0 to \{width} - 1 but got \{x}",
    )
  }
  if y < 0 || y >= height {
    abort(
      "index out of bounds: y is expected from 0 to \{height} - 1 but got \{y}",
    )
  }
  y * width + x
}

///|
pub fn Buffer::get_pos(self : Buffer, index : Int) -> (Int, Int) {
  let height = self.height()
  let width = self.width()
  if index < 0 || index >= width * height {
    abort(
      "index out of bounds: index is expected from 0 to \{width * height - 1}, got \{index}",
    )
  }
  (index % width, index / width)
}

///|
pub fn Buffer::set_chars(self : Buffer, x : Int, y : Int, char : Char) -> Unit {
  let idx = self.get_index(x, y)
  if idx >= self.contents.length() {
    abort(
      "index out of bounds: index is expected from 0 to \{self.contents.length() - 1}, got \{idx}"
    )
  }
  self.contents[idx].char = char
}

///|
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
