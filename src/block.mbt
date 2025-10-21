///|
pub struct Block {
  mut title : String
  pos_x : Int
  pos_y : Int
  width : Int
  height : Int
  children : Array[&Widget]
}

///|
pub fn Block::new(
  x : Int,
  y : Int,
  width : Int,
  height : Int,
  title? : String = "",
  child? : &Widget,
) -> Block {
  match child {
    None => Block::{ title, pos_x: x, pos_y: y, width, height, children: [] }
    Some(widget) =>
      Block::{ title, pos_x: x, pos_y: y, width, height, children: [widget] }
  }
}

///|
pub fn Block::set_title(self : Block, title : String) -> Unit {
  self.title = title
}

///|
pub fn Block::add(self : Block, child : &Widget) -> Unit {
  self.children.push(child)
}

///|
pub impl Widget for Block with render(self : Block, frame : Frame) -> Unit {
  let subframe = frame.subframe(self.pos_x, self.pos_y, self.width, self.height)
  for i in 0..<self.width {
    subframe.set_chars(i, 0, '-')
    subframe.set_chars(i, self.height - 1, '-')
  }
  for j in 0..<self.height {
    subframe.set_chars(0, j, '|')
    subframe.set_chars(self.width - 1, j, '|')
  }
  subframe.set_chars(0, 0, '+')
  subframe.set_chars(self.width - 1, 0, '+')
  subframe.set_chars(0, self.height - 1, '+')
  subframe.set_chars(self.width - 1, self.height - 1, '+')
  for i, ch in self.title.iter2() {
    subframe.set_chars(2 + i, 0, ch)
  }
  for child in self.children {
    child.render(subframe)
  }
}
