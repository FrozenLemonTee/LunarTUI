///|
pub struct GridLayout {
  rows : Int
  cols : Int
}

///|
pub fn GridLayout::new(rows : Int, cols : Int) -> GridLayout {
  GridLayout::{ rows: @cmp.maximum(0, rows), cols: @cmp.maximum(0, cols) }
}

///|
pub impl Layout for GridLayout with split(
  self : GridLayout,
  area : Area,
  children : Array[&Widget],
) -> Array[Section] {
  let rows = self.rows
  let cols = self.cols
  let grids = rows * cols
  let count = @cmp.minimum(children.length(), grids)
  if count == 0 {
    return []
  }
  let cell_height = area.height / rows
  let cell_width = area.width / cols
  let sections = Array::default()
  for i in 0..<count {
    let row = i / cols
    let col = i % cols
    let (cell_left, cell_top) = (col * cell_width, row * cell_height)
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
pub impl Layout for GridLayout with width(
  self : GridLayout,
  area : Area,
  children : Array[&Widget],
) -> Int {
  ignore(children) // NOLINT
  if self.cols == 0 || self.rows == 0 {
    return 0
  }
  @cmp.minimum(area.width, self.cols * (area.width / self.cols))
}

///|
pub impl Layout for GridLayout with height(
  self : GridLayout,
  area : Area,
  children : Array[&Widget],
) -> Int {
  ignore(children) // NOLINT
  if self.cols == 0 || self.rows == 0 {
    return 0
  }
  @cmp.minimum(area.height, self.rows * (area.height / self.rows))
}
