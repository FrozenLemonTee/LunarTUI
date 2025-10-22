///|
pub struct Label {
  text : String
  left : Int
  top : Int
}

///|
pub fn Label::new(text : String, left? : Int = 0, top? : Int = 0) -> Label {
  Label::{ text, left, top }
}

///|
pub impl Widget for Label with width(self : Label) -> Int {
  self.text.length()
}

///|
pub impl Widget for Label with height(self : Label) -> Int {
  ignore(self) // NOLINT
  1
}

///|
pub impl Widget for Label with render(self : Label, frame : Frame) -> Unit {
  let subframe = frame.subframe(self.left, self.top, self.text.length(), 1)
  for i, ch in self.text.iter2() {
    subframe.set_chars(i, 0, ch)
  }
}
