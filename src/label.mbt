///|
pub struct Label {
  text : String
  pos_x : Int
  pos_y : Int
}

///|
pub fn Label::new(text : String, x? : Int = 0, y? : Int = 0) -> Label {
  Label::{ text, pos_x: x, pos_y: y }
}

///|
pub impl Widget for Label with render(self : Label, frame : Frame) -> Unit {
  let pos = frame.buf.area.pos()
  for i, ch in self.text.iter2() {
    frame.buf.set_chars(pos.0 + self.pos_x + i, self.pos_y + pos.1, ch)
  }
}
