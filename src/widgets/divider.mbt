///|
pub(all) enum Direction {
  Row
  Column
}

///|
pub struct Divider {
  left : Int
  top : Int
  length : Int
  line : Char
  edge : Char
  direction : Direction
}

///|
pub fn Divider::new(
  length : Int,
  left? : Int = 0,
  top? : Int = 0,
  line? : Char,
  edge? : Char = '+',
  direction? : Direction = Direction::Row,
) -> Divider {
  let ch_line = match line {
    None =>
      match direction {
        Row => '-'
        Column => '|'
      }
    Some(line) => line
  }
  Divider::{ left, top, length, line: ch_line, direction, edge }
}

///|
pub impl @base.Widget for Divider with width(self : Divider) -> Int {
  match self.direction {
    Row => self.length
    Column => 1
  }
}

///|
pub impl @base.Widget for Divider with height(self : Divider) -> Int {
  match self.direction {
    Row => 1
    Column => self.length
  }
}

///|
pub impl @base.Widget for Divider with render(
  self : Divider,
  frame : @base.Frame,
) -> Unit {
  let subframe = frame.subframe(
    self.left,
    self.top,
    self.width(),
    self.height(),
  )
  for i in 0..<self.length {
    let ch = if i == 0 || i == self.length - 1 { self.edge } else { self.line }
    match self.direction {
      Row => subframe.set_chars(i, 0, ch)
      Column => subframe.set_chars(0, i, ch)
    }
  }
}
