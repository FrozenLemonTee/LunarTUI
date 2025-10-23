///|
pub struct HLayout {}

///|
pub fn HLayout::new() -> HLayout {
  HLayout::{  }
}

///|
pub impl Layout for HLayout with split(
  self : HLayout,
  area : Area,
  children : Array[&Widget],
) -> Array[Section] {
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
