///|
extern "c" fn terminal_clear() -> Unit = "terminal_clear"

///|
extern "c" fn terminal_move_cursor(x : Int, y : Int) -> Unit = "terminal_move_cursor"

///|
extern "c" fn terminal_put_char(ch : Char) -> Unit = "terminal_put_char"

///|
extern "c" fn terminal_flush() -> Unit = "terminal_flush"

///|
pub struct Terminal {
  mut last : Buffer
  mut cur : Buffer
}

///|
pub fn Terminal::clear() -> Unit {
  terminal_clear()
}

///|
pub fn Terminal::move_cursor(x : Int, y : Int) -> Unit {
  terminal_move_cursor(x, y)
}

///|
pub fn Terminal::put_char(ch : Char) -> Unit {
  terminal_put_char(ch)
}

///|
pub fn Terminal::flush() -> Unit {
  terminal_flush()
}

///|
pub fn Terminal::new(area : Area) -> Terminal {
  Terminal::{ last: Buffer::new(area), cur: Buffer::new(area) }
}

///|
pub fn[T : Widget] Terminal::draw(self : Terminal, widget : T) -> Unit {
  let frame = Frame::new(self.cur)
  widget.render(frame)
  self.apply()
  self.swap()
}

///|
fn Terminal::swap(self : Terminal) -> Unit {
  let tmp = self.cur
  self.cur = self.last
  self.last = tmp
}

///|
fn apply(self : Terminal) -> Unit {
  let diff = self.cur.diff(self.last)
  for item in diff {
    let (x, y) = item.0
    let (_, new) = item.1
    terminal_move_cursor(x, y)
    terminal_put_char(new.char)
  }
  terminal_flush()
}
