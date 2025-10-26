///|
extern "c" fn terminal_clear() -> Unit = "terminal_clear"

///|
extern "c" fn terminal_move_cursor(x : Int, y : Int) -> Unit = "terminal_move_cursor"

///|
extern "c" fn terminal_put_char(ch : Char) -> Unit = "terminal_put_char"

///|
extern "c" fn terminal_flush() -> Unit = "terminal_flush"

///|
extern "c" fn terminal_newline() -> Unit = "terminal_newline"

///|
pub struct Terminal {
  mut last : @base.Buffer
  mut cur : @base.Buffer
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
pub fn Terminal::newline() -> Unit {
  terminal_newline()
}

///|
pub fn Terminal::new(area : @base.Area) -> Terminal {
  Terminal::{ last: @base.Buffer::new(area), cur: @base.Buffer::new(area) }
}

///|
pub fn[T : @base.Widget] Terminal::draw(self : Terminal, widget : T) -> Unit {
  let frame = @base.Frame::new(
    self.cur,
    @base.Section::new(
      @base.Area::new(self.cur.width(), self.cur.height()),
      0,
      0,
    ),
  )
  widget.render(frame)
  self.cur = frame.buf
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
    let (new, _) = item.1
    Terminal::move_cursor(x, y)
    Terminal::put_char(new.char)
  }
  Terminal::flush()
}
