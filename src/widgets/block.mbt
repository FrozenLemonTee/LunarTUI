///|
pub struct Block {
  mut title : String
  section : @base.Section
  container : Container
}

///|
pub fn Block::new(
  left : Int,
  top : Int,
  width : Int,
  height : Int,
  title? : String = "",
  child? : &@base.Widget,
  layout? : &@base.Layout,
) -> Block {
  let left = @cmp.maximum(0, left)
  let top = @cmp.maximum(0, top)
  let width = @cmp.maximum(0, width)
  let height = @cmp.maximum(0, height)
  let section = @base.Section::new(@base.Area::new(width, height), left, top)
  let block = match layout {
    None => Block::{ title, section, container: Container::new(section) }
    Some(layout) =>
      Block::{ title, section, container: Container::new(layout~, section) }
  }
  match child {
    Some(child) => block.container.add(child)
    None => block.container.add_all([])
  }
  block
}

///|
pub fn Block::set_title(self : Block, title : String) -> Unit {
  self.title = title
}

///|
pub fn Block::add(self : Block, child : &@base.Widget) -> Unit {
  self.container.add(child)
}

///|
pub fn Block::add_all(self : Block, children : Array[&@base.Widget]) -> Unit {
  self.container.add_all(children)
}

///|
pub fn Block::draw_border(
  self : Block,
  frame : @base.Frame,
  hor? : Char = '-',
  ver? : Char = '|',
  edge? : Char = '+',
) -> Unit {
  for i in 0..<self.width() {
    frame.set_chars(i, 0, hor)
    frame.set_chars(i, self.height() - 1, hor)
  }
  for j in 0..<self.height() {
    frame.set_chars(0, j, ver)
    frame.set_chars(self.width() - 1, j, ver)
  }
  frame.set_chars(0, 0, edge)
  frame.set_chars(self.width() - 1, 0, edge)
  frame.set_chars(0, self.height() - 1, edge)
  frame.set_chars(self.width() - 1, self.height() - 1, edge)
}

///|
pub fn Block::draw_title(self : Block, frame : @base.Frame) -> Unit {
  for i, ch in self.title.iter2() {
    frame.set_chars(2 + i, 0, ch)
  }
}

///|
pub fn Block::draw_children(self : Block, frame : @base.Frame) -> Unit {
  self.container.render(frame)
}

///|
pub impl @base.Widget for Block with width(self : Block) -> Int {
  self.section.area.width
}

///|
pub impl @base.Widget for Block with height(self : Block) -> Int {
  self.section.area.height
}

///|
pub impl @base.Widget for Block with render(self : Block, frame : @base.Frame) -> Unit {
  let subframe = frame.subframe(
    self.section.left,
    self.section.top,
    self.width(),
    self.height(),
  )
  self.draw_border(subframe)
  self.draw_title(subframe)
  self.draw_children(subframe)
}
