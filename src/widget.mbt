///|
pub(open) trait Widget {
  width(self : Self) -> Int
  height(self : Self) -> Int
  render(self : Self, frame : Frame) -> Unit
}
