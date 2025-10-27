pub(all) enum Align {
  Left
  Center
  Right
}

pub struct Paragraph {
  text : String
  align : Align
  section : @base.Section
}

pub fn Paragraph::new(
  left : Int,
  top : Int,
  width : Int,
  height : Int,
  text : String,
  align? : Align = Align::Left
) -> Paragraph {
  let left = @cmp.maximum(0, left)
  let top = @cmp.maximum(0, top)
  let width = @cmp.maximum(0, width)
  let height = @cmp.maximum(0, height)
  let section = @base.Section::new(@base.Area::new(width, height), left, top)
  Paragraph::{ text, align, section }
}

pub fn Paragraph::fromSection(
  section : @base.Section,
  text : String,
  align? : Align = Align::Left
) -> Paragraph {
  Paragraph::{ text, align, section }
}

pub impl @base.Widget for Paragraph with width(self : Paragraph) -> Int {
  self.section.area.width
}

pub impl @base.Widget for Paragraph with height(self : Paragraph) -> Int {
  self.section.area.height
}

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

pub impl @base.Widget for Paragraph with render(
  self : Paragraph,
  frame : @base.Frame
) -> Unit {
  // todo
}