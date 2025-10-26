///|
test "ffi test" {
  @terminal.Terminal::clear()
  @terminal.Terminal::move_cursor(0, 0)
  for i in 0..<10 {
    @terminal.Terminal::move_cursor(i, i)
    @terminal.Terminal::put_char('*')
  }
  @terminal.Terminal::flush()
}

///|
test "terminal test - init" {
  let area = @base.Area::new(20, 1)
  let ter = @terminal.Terminal::new(area)
  assert_eq(ter.cur.contents.length(), area.size())
  assert_eq(ter.last.contents.length(), area.size())
}

///|
test "buffer init" {
  let area = @base.Area::new(4, 2)
  let buf = @base.Buffer::new(area)
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
  let area = @base.Area::new(40, 5)
  let ter = @terminal.Terminal::new(area)
  let label = @widgets.Label::new("Hello, tui-rabbit!", left=10, top=3)
  @terminal.Terminal::clear()
  ter.draw(label)
  println("")
}

///|
test "block test - simple render" {
  let a1 = @base.Area::new(50, 50)
  let ter = @terminal.Terminal::new(a1)
  let l1 = @widgets.Label::new("This is a label", left=5, top=5)
  let b1 = @widgets.Block::new(0, 0, 50, 50, title="This is a block", child=l1)
  @terminal.Terminal::clear()
  ter.draw(b1)
  println("")
}

///|
test "block test - nested block render" {
  let a1 = @base.Area::new(70, 30)
  let ter = @terminal.Terminal::new(a1)
  let b1 = @widgets.Block::new(
    0,
    0,
    70,
    30,
    title="This is a block",
    child=@widgets.Label::new("A nested label", left=30, top=2),
  )
  let b2 = @widgets.Block::new(5, 5, 25, 10, title="This is a nested block")
  b1.add(b2)
  @terminal.Terminal::clear()
  ter.draw(b1)
  println("")
}

///|
test "block test - nested label in nested block" {
  let area = @base.Area::new(30, 30)
  let ter = @terminal.Terminal::new(area)
  let b1 = @widgets.Block::new(0, 0, 30, 30, title="Outer Block")
  let b2 = @widgets.Block::new(
    5,
    5,
    20,
    10,
    title="Inner Block",
    child=@widgets.Label::new("Nested Label", left=3, top=2),
  )
  b1.add(b2)
  @terminal.Terminal::clear()
  ter.draw(b1)
  println("")
}

///|
test "layout test - HLayout render labels in block" {
  let area = @base.Area::new(40, 20)
  let ter = @terminal.Terminal::new(area)
  let labels : Array[&@base.Widget] = Array::default()
  for i in 0..<5 {
    labels.push(@widgets.Label::new("\{i}", left=0, top=0))
  }
  let block = @widgets.Block::new(
    0,
    0,
    title="Outer Block",
    area.width,
    area.height,
    layout=@layouts.HLayout::new(),
  )
  block.add_all(labels)
  @terminal.Terminal::clear()
  ter.draw(block)
  println("")
}

///|
test "layout test - HLayout render blocks in block" {
  let area = @base.Area::new(60, 10)
  let ter = @terminal.Terminal::new(area)
  let blocks : Array[&@base.Widget] = Array::default()
  for i in 0..<3 {
    let b = @widgets.Block::new(
      0,
      0,
      15,
      5,
      title="Block \{i}",
      child=@widgets.Label::new("Content", left=2, top=2),
    )
    blocks.push(b)
  }
  let block = @widgets.Block::new(
    0,
    0,
    title="Outer Block",
    area.width,
    area.height,
    layout=@layouts.HLayout::new(),
  )
  block.add_all(blocks)
  @terminal.Terminal::clear()
  ter.draw(block)
  println("")
}

///|
test "layout test - VLayout render labels in block" {
  let area = @base.Area::new(20, 20)
  let ter = @terminal.Terminal::new(area)
  let labels : Array[&@base.Widget] = Array::default()
  for i in 0..<5 {
    labels.push(@widgets.Label::new("Label \{i}", left=0, top=0))
  }
  let block = @widgets.Block::new(
    0,
    0,
    title="Outer Block",
    area.width,
    area.height,
    layout=@layouts.VLayout::new(),
  )
  block.add_all(labels)
  @terminal.Terminal::clear()
  ter.draw(block)
  println("")
}

///|
test "layout test - GridLayout render labels in block" {
  let area = @base.Area::new(40, 20)
  let ter = @terminal.Terminal::new(area)
  let labels : Array[&@base.Widget] = Array::default()
  for i in 0..<9 {
    labels.push(@widgets.Label::new("L\{i}", left=0, top=0))
  }
  let block = @widgets.Block::new(
    0,
    0,
    title="Outer Block",
    area.width,
    area.height,
    layout=@layouts.GridLayout::new(3, 3),
  )
  block.add_all(labels)
  @terminal.Terminal::clear()
  ter.draw(block)
  println("")
}

///|
test "layout test - GridLayout render blocks in block" {
  let area = @base.Area::new(40, 20)
  let ter = @terminal.Terminal::new(area)
  let blocks : Array[&@base.Widget] = Array::default()
  for i in 0..<9 {
    let b = @widgets.Block::new(
      0,
      0,
      10,
      5,
      title="B\{i}",
      child=@widgets.Label::new("Blk\{i}", left=2, top=2),
    )
    blocks.push(b)
  }
  let block = @widgets.Block::new(
    0,
    0,
    title="Outer Block",
    area.width,
    area.height,
    layout=@layouts.GridLayout::new(3, 3),
  )
  block.add_all(blocks)
  @terminal.Terminal::clear()
  ter.draw(block)
  @terminal.Terminal::newline()
}

///|
test "layout test - FlexLayout render adjust mode" {
  let blocks : Array[&@base.Widget] = []
  for i in 0..<4 {
    let b = @widgets.Block::new(
      0,
      0,
      10,
      3,
      title="B\{i}",
      child=@widgets.Label::new("Blk\{i}", left=2, top=1),
    )
    blocks.push(b)
  }
  let area = @base.Area::new(80, 40)
  let ter = @terminal.Terminal::new(area)
  let outer = @widgets.Block::new(
    0,
    0,
    area.width,
    area.height,
    title="FlexLayout Test",
    layout=@layouts.VLayout::new(),
  )
  let block_start = @widgets.Block::new(
    0,
    0,
    title="Main axis: Start",
    70,
    5,
    layout=@layouts.FlexLayout::new(direction=Row, justify=Start, align=Center),
  )
  block_start.add_all(blocks)
  let block_center = @widgets.Block::new(
    0,
    0,
    title="Main axis: Center",
    70,
    5,
    layout=@layouts.FlexLayout::new(direction=Row, justify=Center, align=Center),
  )
  block_center.add_all(blocks)
  let block_end = @widgets.Block::new(
    0,
    0,
    title="Main axis: End",
    70,
    5,
    layout=@layouts.FlexLayout::new(direction=Row, justify=End, align=Center),
  )
  block_end.add_all(blocks)
  let block_space_between = @widgets.Block::new(
    0,
    0,
    title="Main axis: SpaceBetween",
    70,
    5,
    layout=@layouts.FlexLayout::new(
      direction=Row,
      justify=SpaceBetween,
      align=Center,
    ),
  )
  block_space_between.add_all(blocks)
  let block_space_around = @widgets.Block::new(
    0,
    0,
    title="Main axis: SpaceAround",
    70,
    5,
    layout=@layouts.FlexLayout::new(
      direction=Row,
      justify=SpaceAround,
      align=Center,
    ),
  )
  block_space_around.add_all(blocks)
  let block_space_evenly = @widgets.Block::new(
    0,
    0,
    title="Main axis: SpaceEvenly",
    70,
    5,
    layout=@layouts.FlexLayout::new(
      direction=Row,
      justify=SpaceEvenly,
      align=Center,
    ),
  )
  block_space_evenly.add_all(blocks)
  outer.add(block_start)
  outer.add(block_center)
  outer.add(block_end)
  outer.add(block_space_between)
  outer.add(block_space_around)
  outer.add(block_space_evenly)
  @terminal.Terminal::clear()
  ter.draw(outer)
  @terminal.Terminal::newline()
}

///|
test "layout test - FlexLayout render align mode" {
  let blocks : Array[&@base.Widget] = []
  for i in 0..<3 {
    let b = @widgets.Block::new(
      0,
      0,
      10,
      3,
      title="B\{i}",
      child=@widgets.Label::new("Blk\{i}", left=2, top=1),
    )
    blocks.push(b)
  }
  let area = @base.Area::new(60, 30)
  let ter = @terminal.Terminal::new(area)
  let outer = @widgets.Block::new(
    0,
    0,
    area.width,
    area.height,
    title="FlexLayout Align Test",
    layout=@layouts.VLayout::new(),
  )
  let block_align_start = @widgets.Block::new(
    0,
    0,
    title="Cross axis: Start",
    55,
    7,
    layout=@layouts.FlexLayout::new(direction=Row, justify=Center, align=Start),
  )
  block_align_start.add_all(blocks)
  let block_align_center = @widgets.Block::new(
    0,
    0,
    title="Cross axis: Center",
    55,
    7,
    layout=@layouts.FlexLayout::new(direction=Row, justify=Center, align=Center),
  )
  block_align_center.add_all(blocks)
  let block_align_end = @widgets.Block::new(
    0,
    0,
    title="Cross axis: End",
    55,
    7,
    layout=@layouts.FlexLayout::new(direction=Row, justify=Center, align=End),
  )
  block_align_end.add_all(blocks)
  outer.add(block_align_start)
  outer.add(block_align_center)
  outer.add(block_align_end)
  @terminal.Terminal::clear()
  ter.draw(outer)
  @terminal.Terminal::newline()
}

///|
test "layout test - FlexLayout render adjust mode vertical main axis" {
  let area = @base.Area::new(30, 40)
  let ter = @terminal.Terminal::new(area)
  let block = @widgets.Block::new(
    0,
    0,
    area.width,
    area.height,
    title="FlexLayout Vertical Test",
    layout=@layouts.FlexLayout::new(
      direction=Column,
      justify=SpaceAround,
      align=Center,
    ),
  )
  let blocks : Array[&@base.Widget] = []
  for i in 0..<6 {
    let b = @widgets.Block::new(
      0,
      0,
      10,
      3,
      title="B\{i}",
      child=@widgets.Label::new("Blk\{i}", left=2, top=1),
    )
    blocks.push(b)
  }
  block.add_all(blocks)
  @terminal.Terminal::clear()
  ter.draw(block)
  @terminal.Terminal::newline()
}
