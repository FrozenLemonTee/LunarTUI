///|
pub struct Frame {
  buf : Buffer
}

///|
pub fn Frame::new(buf : Buffer) -> Frame {
  Frame::{ buf, }
}

///|
pub fn Frame::area(self : Frame) -> Area {
  self.buf.area
}
