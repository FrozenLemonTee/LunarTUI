///|
pub struct Block {
  mut title : String
  left : Int
  top : Int
  width : Int
  height : Int
  children : Array[&Widget]
  layout : &Layout?
}

///|
pub fn Block::new(
  left : Int,
  top : Int,
  width : Int,
  height : Int,
  title? : String = "",
  child? : &Widget,
  layout? : &Layout,
) -> Block {
  match child {
    None => Block::{ title, left, top, width, height, children: [], layout }
    Some(widget) =>
      Block::{ title, left, top, width, height, children: [widget], layout }
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
pub fn Block::add_all(self : Block, children : Array[&Widget]) -> Unit {
  self.children.append(children)
}

///|
pub fn Block::draw_border(
  self : Block,
  frame : Frame,
  hor? : Char = '-',
  ver? : Char = '|',
  edge? : Char = '+',
) -> Unit {
  for i in 0..<self.width {
    frame.set_chars(i, 0, hor)
    frame.set_chars(i, self.height - 1, hor)
  }
  for j in 0..<self.height {
    frame.set_chars(0, j, ver)
    frame.set_chars(self.width - 1, j, ver)
  }
  frame.set_chars(0, 0, edge)
  frame.set_chars(self.width - 1, 0, edge)
  frame.set_chars(0, self.height - 1, edge)
  frame.set_chars(self.width - 1, self.height - 1, edge)
}

///|
pub fn Block::draw_title(self : Block, frame : Frame) -> Unit {
  for i, ch in self.title.iter2() {
    frame.set_chars(2 + i, 0, ch)
  }
}

///|
pub fn Block::draw_children(self : Block, frame : Frame) -> Unit {
  guard self.children.length() > 0 else { return }
  match self.layout {
    None =>
      for child in self.children {
        child.render(frame)
      }
    Some(layout) => {
      let sections = layout.split(
        Area::new(self.width, self.height),
        self.children,
      )
      for i, child in self.children.iter2() {
        let sec = sections[i]
        let subframe = frame.subframe(
          sec.left,
          sec.top,
          sec.area.width,
          sec.area.height,
        )
        child.render(subframe)
      }
    }
  }
}

///|
pub impl Widget for Block with width(self : Block) -> Int {
  self.width
}

///|
pub impl Widget for Block with height(self : Block) -> Int {
  self.height
}

///|
pub impl Widget for Block with render(self : Block, frame : Frame) -> Unit {
  let subframe = frame.subframe(self.left, self.top, self.width, self.height)
  self.draw_border(subframe)
  self.draw_title(subframe)
  self.draw_children(subframe)
}
