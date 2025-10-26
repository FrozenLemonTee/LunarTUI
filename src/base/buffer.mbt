///|
pub struct Buffer {
  area : Area
  contents : Array[Cell]
} derive(Eq)

///|
pub fn Buffer::new(area : Area) -> Buffer {
  let contents = Array::default()
  for i in 0..<area.size() {
    contents.push(Cell::new())
  }
  Buffer::{ area, contents }
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
  let width = self.width()
  y * width + x
}

///|
pub fn Buffer::get_pos(self : Buffer, index : Int) -> (Int, Int) {
  let width = self.width()
  (index % width, index / width)
}

///|
pub fn Buffer::set_chars(self : Buffer, x : Int, y : Int, char : Char) -> Unit {
  let idx = self.get_index(x, y)
  self.contents[idx].set(char)
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
