///|
pub struct HLayout {}

///|
pub fn HLayout::new() -> HLayout {
  HLayout::{  }
}

///|
pub impl Layout for HLayout with split(self: HLayout, area : Area, children : Array[&Widget]) -> Array[
  Section,
] {
  let count = children.length()
  if count == 0 {
    return []
  }
  let width_per = area.width / count
  let sections = Array::default()
  for i in 0..<count {
    let section = Section::new(
      Area::new(width_per, area.height),
      i * width_per,
      0,
    )
    sections.push(section)
  }
  sections
}
