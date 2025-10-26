///|
pub struct HLayout {}

///|
pub fn HLayout::new() -> HLayout {
  HLayout::{  }
}

///|
pub impl @base.Layout for HLayout with split(
  self : HLayout,
  area : @base.Area,
  children : Array[&@base.Widget],
) -> Array[@base.Section] {
  ignore(self) // NOLINT
  let count = children.length()
  if count == 0 {
    return []
  }
  let cell_width = area.width / count
  let cell_height = area.height
  let sections = Array::default()
  for i in 0..<count {
    let (cell_left, cell_top) = (i * cell_width, 0)
    let (center_left, center_top) = (
      cell_left + cell_width / 2,
      cell_top + cell_height / 2,
    )
    let child = children[i]
    let (section_left, section_top) = (
      @cmp.maximum(cell_left, center_left - child.width() / 2),
      @cmp.maximum(cell_top, center_top - child.height() / 2),
    )
    let section = @base.Section::new(
      @base.Area::new(
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
pub impl @base.Layout for HLayout with width(
  self : HLayout,
  area : @base.Area,
  children : Array[&@base.Widget],
) -> Int {
  ignore(self) // NOLINT
  let children_total = children
    .iter()
    .map(fn(child) { child.width() })
    .fold(fn(acc, cur) { acc + cur }, init=0)
  @cmp.minimum(children_total, area.width)
}

///|
pub impl @base.Layout for HLayout with height(
  self : HLayout,
  area : @base.Area,
  children : Array[&@base.Widget],
) -> Int {
  ignore(self) // NOLINT
  let child_max = children
    .iter()
    .map(fn(child) { child.height() })
    .fold(fn(max, cur) { @cmp.maximum(max, cur) }, init=0)
  @cmp.minimum(child_max, area.height)
}
