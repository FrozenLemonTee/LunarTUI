pub struct Block {
  mut title : String
  pos_x : Int
  pos_y : Int
  width : Int
  height : Int
  children : Array[&Widget]
}

pub fn Block::new(x : Int, y : Int, width : Int, height : Int, title? : String = "", child? : &Widget) -> Block {
  match child {
    None => Block::{ title, pos_x: x, pos_y: y, width, height, children: [] }
    Some(widget) => Block::{ title, pos_x: x, pos_y: y, width, height, children: [widget] }
  }
}

pub fn Block::set_title(self : Block, title : String) -> Unit {
  self.title = title
}

pub fn Block::add(self : Block, child : &Widget) -> Unit {
  self.children.push(child)
}

pub impl Widget for Block with render(self : Block, frame : Frame) -> Unit {
  let pos = frame.buf.area.pos()
  for i in 0..<self.width {
    frame.buf.set_chars(pos.0 + self.pos_x + i, pos.1 + self.pos_y, '-')
    frame.buf.set_chars(pos.0 + self.pos_x + i, pos.1 + self.pos_y + self.height - 1, '-')
  }
  for j in 0..<self.height {
    frame.buf.set_chars(pos.0 + self.pos_x, pos.1 + self.pos_y + j, '|')
    frame.buf.set_chars(pos.0 + self.pos_x + self.width - 1, pos.1 + self.pos_y + j, '|')
  }

  frame.buf.set_chars(pos.0 + self.pos_x, pos.1 + self.pos_y, '+')
  frame.buf.set_chars(pos.0 + self.pos_x + self.width - 1, pos.1 + self.pos_y, '+')
  frame.buf.set_chars(pos.0 + self.pos_x, pos.1 + self.pos_y + self.height - 1, '+')
  frame.buf.set_chars(pos.0 + self.pos_x + self.width - 1, pos.1 + self.pos_y + self.height - 1, '+')

  for i, ch in self.title.iter2() {
    frame.buf.set_chars(pos.0 + self.pos_x + 2 + i, pos.1 + self.pos_y, ch)
  }

  for child in self.children {
    child.render(frame)
  }
}