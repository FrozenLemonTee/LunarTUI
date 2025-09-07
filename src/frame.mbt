pub struct Frame {
  buf : Buffer
} derive(Default)

pub fn Frame::new(buf : Buffer) -> Frame {
  Frame::{ buf, }
}