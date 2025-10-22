///|
pub struct Frame {
  buf : Buffer
  section : Section
}

///|
pub fn Frame::new(buf : Buffer, section : Section) -> Frame {
  let (left, top) = (
    @cmp.minimum(section.left, buf.area.width),
    @cmp.minimum(section.top, buf.area.height),
  )
  let (right, bottom) = (
    @cmp.minimum(left + section.area.width, buf.area.width),
    @cmp.minimum(top + section.area.height, buf.area.height),
  )
  let (width, height) = (right - left, bottom - top)
  Frame::{ buf, section: Section::new(Area::new(width, height), left, top) }
}

///|
pub fn Frame::area(self : Frame) -> Area {
  self.buf.area
}

///|
pub fn Frame::set_chars(self : Frame, left : Int, top : Int, ch : Char) -> Unit {
  if left < 0 || left >= self.section.area.width {
    return
  }
  if top < 0 || top >= self.section.area.height {
    return
  }
  let buf_x = left + self.section.left
  let buf_y = top + self.section.top
  self.buf.set_chars(buf_x, buf_y, ch)
}

///|
pub fn Frame::subframe(
  self : Frame,
  left : Int,
  top : Int,
  width : Int,
  height : Int,
) -> Frame {
  Frame::new(
    self.buf,
    Section::new(
      Area::new(width, height),
      left + self.section.left,
      top + self.section.top,
    ),
  )
}
