pub struct Label {
  text : String
}

pub fn Label::new(text : String) -> Label {
  Label::{ text }
}

pub impl Widget for Label with render(self : Label, frame : Frame) -> Unit {
  for i, ch in self.text.iter2() {
    let pos = frame.buf.area.pos()
    frame.buf.set_chars(pos.0 + i, pos.1, ch)
  }
}