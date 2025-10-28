///|
pub(all) enum Align {
  Left
  Center
  Right
}

///|
pub struct Paragraph {
  text : String
  align : Align
  section : @base.Section
}

///|
pub fn Paragraph::new(
  left : Int,
  top : Int,
  width : Int,
  height : Int,
  text : String,
  align? : Align = Align::Left,
) -> Paragraph {
  let left = @cmp.maximum(0, left)
  let top = @cmp.maximum(0, top)
  let width = @cmp.maximum(0, width)
  let height = @cmp.maximum(0, height)
  let section = @base.Section::new(@base.Area::new(width, height), left, top)
  Paragraph::{ text, align, section }
}

///|
pub fn Paragraph::from_section(
  section : @base.Section,
  text : String,
  align? : Align = Align::Left,
) -> Paragraph {
  Paragraph::{ text, align, section }
}

///|
pub impl @base.Widget for Paragraph with width(self : Paragraph) -> Int {
  self.section.area.width
}

///|
pub impl @base.Widget for Paragraph with height(self : Paragraph) -> Int {
  self.section.area.height
}

///|
fn Paragraph::indices(self : Paragraph) -> Array[Int] {
  let text = self.text
  let width = self.section.area.width
  let line_starts = [0]
  let mut count = 0
  for i in 0..<text.length() {
    let ch = text[i]
    count += 1
    if ch == '\n' {
      line_starts.push(i + 1)
      count = 0
    } else if count >= width {
      line_starts.push(i + 1)
      count = 0
    }
  }
  line_starts
}

///|
fn Paragraph::draw_line(
  self : Paragraph,
  frame : @base.Frame,
  start : Int,
  end : Int,
) -> Unit {
  let text = self.text.view()
  if start >= text.length() {
    return
  }
  let line_len = end - start
  let line = text.iter().drop(start).take(line_len)
  let line_len_max = self.width()
  let space = line_len_max - line_len
  let left = match self.align {
    Center => space / 2
    Left => 0
    Right => line_len_max - line_len
  }
  let subframe = frame.subframe(left, 0, line_len_max, 1)
  for i, ch in line.iter2() {
    subframe.set_chars(i, 0, ch)
  }
}

///|
pub impl @base.Widget for Paragraph with render(
  self : Paragraph,
  frame : @base.Frame,
) -> Unit {
  let subframe = frame.subframe(
    self.section.left,
    self.section.top,
    self.width(),
    self.height(),
  )
  let line_starts = self.indices()
  for i in 0..<line_starts.length() {
    let start = line_starts[i]
    let end = if i + 1 < line_starts.length() {
      line_starts[i + 1]
    } else {
      self.text.length()
    }
    let frame_line = subframe.subframe(0, i, self.width(), 1)
    self.draw_line(frame_line, start, end)
  }
}
