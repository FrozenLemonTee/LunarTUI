///|
pub(all) enum Direction {
  Row
  Column
} derive(Eq)

///|
pub(all) enum Justify {
  Start
  Center
  End
  SpaceBetween
  SpaceAround
  SpaceEvenly
} derive(Eq)

///|
pub(all) enum Align {
  Start
  Center
  End
} derive(Eq)

///|
pub(all) struct FlexLayout {
  direction : Direction
  justify : Justify
  align : Align
}

///|
pub fn FlexLayout::new(
  direction? : Direction = Direction::Row,
  justify? : Justify = Justify::Start,
  align? : Align = Align::Start,
) -> FlexLayout {
  FlexLayout::{ direction, justify, align }
}

///|
fn FlexLayout::child_main_size(self : FlexLayout, child : &@base.Widget) -> Int {
  match self.direction {
    Row => child.width()
    Column => child.height()
  }
}

///|
fn FlexLayout::child_cross_size(
  self : FlexLayout,
  child : &@base.Widget,
) -> Int {
  match self.direction {
    Row => child.height()
    Column => child.width()
  }
}

///|
pub impl @base.Layout for FlexLayout with split(
  self : FlexLayout,
  area : @base.Area,
  children : Array[&@base.Widget],
) -> Array[@base.Section] {
  let count = children.length()
  if count == 0 {
    return []
  }
  let (main_size, cross_size) = match self.direction {
    Row => (area.width, area.height)
    Column => (area.height, area.width)
  }
  let main_size_children = children
    .iter()
    .map(fn(child) { self.child_main_size(child) })
    .fold(fn(acc, cur) { acc + cur }, init=0)
  let remaining = main_size - main_size_children
  if remaining < 0 {
    return []
  }
  let (space, extra_init) = match self.justify {
    SpaceBetween =>
      if count > 1 {
        (remaining / (count - 1), remaining % (count - 1))
      } else {
        (0, 0)
      }
    SpaceAround => (remaining / count, remaining % count)
    SpaceEvenly => (remaining / (count + 1), remaining % (count + 1))
    _ => (0, 0)
  }
  let mut offset = match self.justify {
    Start => 0
    Center => remaining / 2
    End => remaining
    SpaceBetween => 0
    SpaceAround => space / 2
    SpaceEvenly => space
  }
  let sections = Array::default()
  let mut extra = extra_init
  for i, child in children.iter2() {
    let cur = offset
    let main_step = self.child_main_size(child)
    offset += main_step
    match self.justify {
      SpaceBetween if i < count - 1 => {
        offset += space
        if extra > 0 {
          offset += 1
          extra -= 1
        }
      }
      SpaceAround | SpaceEvenly => {
        offset += space
        if extra > 0 {
          offset += 1
          extra -= 1
        }
      }
      _ => ()
    }
    let cross = match self.align {
      Start => 0
      Center => (cross_size - self.child_cross_size(child)) / 2
      End => cross_size - self.child_cross_size(child)
    }
    let (x, y, width, height) = match self.direction {
      Row => (cur, cross, child.width(), cross_size)
      Column => (cross, cur, cross_size, child.height())
    }
    sections.push(@base.Section::new(@base.Area::new(width, height), x, y))
  }
  sections
}

///|
pub impl @base.Layout for FlexLayout with width(
  self : FlexLayout,
  area : @base.Area,
  children : Array[&@base.Widget],
) {
  if children.is_empty() {
    return 0
  }
  let fold = match self.direction {
    Row => fn(acc : Int, cur : Int) { acc + cur }
    Column => fn(max : Int, cur : Int) { @cmp.maximum(max, cur) }
  }
  let children_size = children
    .iter()
    .map(fn(child) { child.width() })
    .fold(fold, init=0)
  @cmp.minimum(children_size, area.width)
}

///|
pub impl @base.Layout for FlexLayout with height(
  self : FlexLayout,
  area : @base.Area,
  children : Array[&@base.Widget],
) {
  if children.is_empty() {
    return 0
  }
  let fold = match self.direction {
    Row => fn(max : Int, cur : Int) { @cmp.maximum(max, cur) }
    Column => fn(acc : Int, cur : Int) { acc + cur }
  }
  let children_size = children
    .iter()
    .map(fn(child) { child.height() })
    .fold(fold, init=0)
  @cmp.minimum(children_size, area.height)
}
