pub struct Terminal {
  last : Buffer
  cur : Buffer
} derive(Default)

fn Terminal::new(area : Area) -> Terminal {
  Terminal::{
    last: Buffer::new(area, Array::default()),
    cur: Buffer::new(area, Array::default()),
  }
}

fn Terminal::draw(callback : (Frame) -> Unit) -> Unit {
  // todo
}
