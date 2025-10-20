test "ffi test" {
  Terminal::clear()
  Terminal::move_cursor(0, 0)
  for i in 0..<10 {
    Terminal::move_cursor(i, i)
    Terminal::put_char('*')
  }
  Terminal::flush()
}

test "terminal test - init" {
    let area = Area::new(pos_x=0, pos_y=0, 20, 1)
    let ter = Terminal::new(area)
    assert_eq(ter.cur.contents.length(), area.size())
    assert_eq(ter.last.contents.length(), area.size())
}

test "buffer init" {
  let area = Area::new(pos_x=0, pos_y=0, 4, 2)
  let buf = Buffer::new(area)
  assert_eq(buf.contents.length(), 8)
  for i in 0..<8 {
    assert_eq(buf.contents[i].char, '-')
  }
  assert_eq(buf.height(), 2)
  assert_eq(buf.width(), 4)
  assert_eq(buf.get_index(3, 1), 7)
}

test "label test - render" {
    let area = Area::new(pos_x=0, pos_y=0, 40, 1)
    let ter = Terminal::new(area)
    let label = Label::new("Hello tui-rabbit!")
    terminal_clear()
    ter.draw(label)
    println("\n--End Print-")
}
