///|
pub enum FlexDirection {
  Row
  Column
} derive(Eq)

///|
pub enum Justify {
  Start
  Center
  End
  SpaceBetween
  SpaceAround
  SpaceEvenly
} derive(Eq)

///|
pub enum Align {
  Start
  Center
  End
} derive(Eq)

///|
pub struct FlexLayout {
  direction : FlexDirection
  justify : Justify
  align : Align
}

///|
pub fn FlexLayout::new(
  direction? : FlexDirection = FlexDirection::Row,
  justify? : Justify = Justify::Start,
  align? : Align = Align::Start,
) -> FlexLayout {
  FlexLayout::{ direction, justify, align }
}

///|
fn FlexLayout::child_main_size(self : FlexLayout, child : &Widget) -> Int {
  match self.direction {
    Row => child.width()
    Column => child.height()
  }
}

///|
fn FlexLayout::child_cross_size(self : FlexLayout, child : &Widget) -> Int {
  match self.direction {
    Row => child.height()
    Column => child.width()
  }
}

///|
pub impl Layout for FlexLayout with split(
  self : FlexLayout,
  area : Area,
  children : Array[&Widget],
) -> Array[Section] {
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
  let mut offset = match self.justify {
    Start => 0
    Center => remaining / 2
    End => remaining
    SpaceBetween => 0
    SpaceAround => remaining / count / 2
    SpaceEvenly => remaining / (count + 1)
  }
  let sections = Array::default()
  for i, child in children.iter2() {
    let main = {
      let mut cur = offset
      offset += self.child_main_size(child)
      if self.justify == SpaceBetween {
        if i < count - 1 {
          offset += remaining / (count - 1)
        } else {
          cur = main_size - self.child_main_size(child)
        }
      } else if self.justify == SpaceAround {
        offset += remaining / count
      } else if self.justify == SpaceEvenly {
        offset += remaining / (count + 1)
      }
      cur
    }
    let cross = match self.align {
      Start => 0
      Center => (cross_size - self.child_cross_size(child)) / 2
      End => cross_size - self.child_cross_size(child)
    }
    let (x, y, width, height) = match self.direction {
      Row => (main, cross, child.width(), cross_size)
      Column => (cross, main, cross_size, child.height())
    }
    sections.push(Section::new(Area::new(width, height), x, y))
  }
  sections
}

///|
pub impl Layout for FlexLayout with width(
  self : FlexLayout,
  area : Area,
  children : Array[&Widget],
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
pub impl Layout for FlexLayout with height(
  self : FlexLayout,
  area : Area,
  children : Array[&Widget],
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
