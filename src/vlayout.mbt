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
  let section_height_max = area.height / count
  let section_width_max = area.width
  let sections = Array::default()
  for i in 0..<count {
    let (block_left, block_top) = (0, i * section_height_max)
    let (center_left, center_top) = (
      block_left + section_width_max / 2,
      block_top + section_height_max / 2,
    )
    let child = children[i]
    let (section_left, section_top) = (
      @cmp.maximum(block_left, center_left - child.width() / 2),
      @cmp.maximum(block_top, center_top - child.height() / 2),
    )
    let section = Section::new(
      Area::new(
        @cmp.minimum(child.width(), section_width_max),
        @cmp.minimum(child.height(), section_height_max),
      ),
      section_left,
      section_top,
    )
    sections.push(section)
  }
  sections
}
