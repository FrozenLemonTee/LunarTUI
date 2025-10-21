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
  let subframe = frame.subframe(self.pos_x, self.pos_y, self.text.length(), 1)
  for i, ch in self.text.iter2() {
    subframe.set_chars(i, 0, ch)
  }
}
