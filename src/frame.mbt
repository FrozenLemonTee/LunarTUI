///|
pub struct Frame {
  buf : Buffer
  section : Section
}

///|
pub fn Frame::new(buf : Buffer, section : Section) -> Frame {
  let (x0, y0) = (
    @cmp.minimum(section.x, buf.area.width),
    @cmp.minimum(section.y, buf.area.height),
  )
  let (x1, y1) = (
    @cmp.minimum(x0 + section.area.width, buf.area.width),
    @cmp.minimum(y0 + section.area.height, buf.area.height),
  )
  let (width, height) = (x1 - x0, y1 - y0)
  Frame::{ buf, section: Section::new(Area::new(width, height), x0, y0) }
}

///|
pub fn Frame::area(self : Frame) -> Area {
  self.buf.area
}

///|
pub fn Frame::set_chars(
  self : Frame,
  offset_x : Int,
  offset_y : Int,
  ch : Char,
) -> Unit {
  if offset_x < 0 || offset_x >= self.section.area.width {
    return
  }
  if offset_y < 0 || offset_y >= self.section.area.height {
    return
  }
  let buf_x = offset_x + self.section.x
  let buf_y = offset_y + self.section.y
  self.buf.set_chars(buf_x, buf_y, ch)
}

///|
pub fn Frame::subframe(
  self : Frame,
  offset_x : Int,
  offset_y : Int,
  width : Int,
  height : Int,
) -> Frame {
  Frame::new(
    self.buf,
    Section::new(
      Area::new(width, height),
      offset_x + self.section.x,
      offset_y + self.section.y,
    ),
  )
}
