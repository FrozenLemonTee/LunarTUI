///|
pub struct VLayout {}

///|
pub fn VLayout::new() -> VLayout {
  VLayout::{  }
}

///|
pub impl Layout for VLayout with split(
  self : VLayout,
  area : Area,
  children : Array[&Widget],
) -> Array[Section] {
  ignore(self) // NOLINT
  let count = children.length()
  if count == 0 {
    return []
  }
  let cell_height = area.height / count
  let cell_width = area.width
  let sections = Array::default()
  for i in 0..<count {
    let (cell_left, cell_top) = (0, i * cell_height)
    let (center_left, center_top) = (
      cell_left + cell_width / 2,
      cell_top + cell_height / 2,
    )
    let child = children[i]
    let (section_left, section_top) = (
      @cmp.maximum(cell_left, center_left - child.width() / 2),
      @cmp.maximum(cell_top, center_top - child.height() / 2),
    )
    let section = Section::new(
      Area::new(
        @cmp.minimum(child.width(), cell_width),
        @cmp.minimum(child.height(), cell_height),
      ),
      section_left,
      section_top,
    )
    sections.push(section)
  }
  sections
}

///|
pub impl Layout for VLayout with width(
  self : VLayout,
  area : Area,
  children : Array[&Widget],
) -> Int {
  ignore(self) // NOLINT
  let child_max = children
    .iter()
    .map(fn(child) { child.width() })
    .fold(fn(max, cur) { @cmp.maximum(max, cur) }, init=0)
  @cmp.minimum(child_max, area.width)
}

///|
pub impl Layout for VLayout with height(
  self : VLayout,
  area : Area,
  children : Array[&Widget],
) -> Int {
  ignore(self) // NOLINT
  let children_total = children
    .iter()
    .map(fn(child) { child.height() })
    .fold(fn(acc, cur) { acc + cur }, init=0)
  @cmp.minimum(children_total, area.height)
}
