///|
test "ffi test" {
  Terminal::clear()
  Terminal::move_cursor(0, 0)
  for i in 0..<10 {
    Terminal::move_cursor(i, i)
    Terminal::put_char('*')
  }
  Terminal::flush()
}

///|
test "terminal test - init" {
  let area = Area::new(20, 1)
  let ter = Terminal::new(area)
  assert_eq(ter.cur.contents.length(), area.size())
  assert_eq(ter.last.contents.length(), area.size())
}

///|
test "buffer init" {
  let area = Area::new(4, 2)
  let buf = Buffer::new(area)
  assert_eq(buf.contents.length(), 8)
  for i in 0..<8 {
    assert_eq(buf.contents[i].char, ' ')
  }
  assert_eq(buf.height(), 2)
  assert_eq(buf.width(), 4)
  assert_eq(buf.get_index(3, 1), 7)
}

///|
test "label test - render" {
  let area = Area::new(40, 5)
  let ter = Terminal::new(area)
  let label = Label::new("Hello, tui-rabbit!", left=10, top=3)
  Terminal::clear()
  ter.draw(label)
  println("")
}

///|
test "block test - simple render" {
  let a1 = Area::new(50, 50)
  let ter = Terminal::new(a1)
  let l1 = Label::new("This is a label", left=5, top=5)
  let b1 = Block::new(0, 0, 50, 50, title="This is a block", child=l1)
  Terminal::clear()
  ter.draw(b1)
  println("")
}

///|
test "block test - nested block render" {
  let a1 = Area::new(70, 30)
  let ter = Terminal::new(a1)
  let b1 = Block::new(
    0,
    0,
    70,
    30,
    title="This is a block",
    child=Label::new("A nested label", left=30, top=2),
  )
  let b2 = Block::new(5, 5, 25, 10, title="This is a nested block")
  b1.add(b2)
  Terminal::clear()
  ter.draw(b1)
  println("")
}

///|
test "block test - nested label in nested block" {
  let area = Area::new(30, 30)
  let ter = Terminal::new(area)
  let b1 = Block::new(0, 0, 30, 30, title="Outer Block")
  let b2 = Block::new(
    5,
    5,
    20,
    10,
    title="Inner Block",
    child=Label::new("Nested Label", left=3, top=2),
  )
  b1.add(b2)
  Terminal::clear()
  ter.draw(b1)
  println("")
}

///|
test "layout test - HLayout render labels in block" {
  let area = Area::new(40, 20)
  let ter = Terminal::new(area)
  let labels : Array[&Widget] = Array::default()
  for i in 0..<5 {
    labels.push(Label::new("\{i}", left=0, top=0))
  }
  let block = Block::new(
    0,
    0,
    title="Outer Block",
    area.width,
    area.height,
    layout=HLayout::new(),
  )
  block.add_all(labels)
  Terminal::clear()
  ter.draw(block)
  println("")
}

///|
test "layout test - HLayout render blocks in block" {
  let area = Area::new(60, 10)
  let ter = Terminal::new(area)
  let blocks : Array[&Widget] = Array::default()
  for i in 0..<3 {
    let b = Block::new(
      0,
      0,
      15,
      5,
      title="Block \{i}",
      child=Label::new("Content", left=2, top=2),
    )
    blocks.push(b)
  }
  let block = Block::new(
    0,
    0,
    title="Outer Block",
    area.width,
    area.height,
    layout=HLayout::new(),
  )
  block.add_all(blocks)
  Terminal::clear()
  ter.draw(block)
  println("")
}

///|
test "layout test - VLayout render labels in block" {
  let area = Area::new(20, 20)
  let ter = Terminal::new(area)
  let labels : Array[&Widget] = Array::default()
  for i in 0..<5 {
    labels.push(Label::new("Label \{i}", left=0, top=0))
  }
  let block = Block::new(
    0,
    0,
    title="Outer Block",
    area.width,
    area.height,
    layout=VLayout::new(),
  )
  block.add_all(labels)
  Terminal::clear()
  ter.draw(block)
  println("")
}
