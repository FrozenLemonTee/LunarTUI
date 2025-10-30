///|
/// A grid layout that arranges widgets in a fixed grid pattern with center alignment.
///
/// GridLayout divides the available area into a fixed number of rows and columns,
/// placing widgets in grid cells from left to right, top to bottom. Each widget
/// is centered within its allocated cell and constrained to fit within cell boundaries.
pub struct GridLayout {
  /// The number of rows in the grid.
  rows : Int
  /// The number of columns in the grid.
  cols : Int
}

///|
/// Creates a new grid layout manager with specified dimensions.
///
/// # Parameters
/// * `rows`: The number of rows in the grid (automatically clamped to non-negative)
/// * `cols`: The number of columns in the grid (automatically clamped to non-negative)
///
/// # Returns
/// A new GridLayout instance ready to arrange widgets in a grid pattern.
///
/// # Examples
/// ```moonbit
/// let layout = GridLayout::new(2, 3)  // Creates a 2x3 grid
/// ```
pub fn GridLayout::new(rows : Int, cols : Int) -> GridLayout {
  GridLayout::{ rows: @cmp.maximum(0, rows), cols: @cmp.maximum(0, cols) }
}

///|
/// Splits the area into a grid of cells and assigns sections to child widgets.
///
/// Widgets are placed in grid cells in row-major order (left to right, top to bottom).
/// Each widget is centered within its cell and constrained to the cell dimensions.
/// If there are more widgets than grid cells, excess widgets are ignored.
///
/// # Parameters
/// * `self`: The GridLayout instance
/// * `area`: The total available area to divide into grid cells
/// * `children`: Array of references to child widgets to arrange in the grid
///
/// # Returns
/// An array of Sections, each defining the position and size for a child widget
/// placed in the corresponding grid cell.
pub impl @base.Layout for GridLayout with split(
  self : GridLayout,
  area : @base.Area,
  children : Array[&@base.Widget],
) -> Array[@base.Section] {
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
/// Calculates the preferred width for grid layout.
///
/// The width is determined by the grid column structure and available area,
/// ignoring individual child widget widths to maintain consistent grid alignment.
///
/// # Parameters
/// * `self`: The GridLayout instance
/// * `area`: The available area constraints
/// * `children`: Array of references to child widgets (ignored in calculation)
///
/// # Returns
/// The total grid width constrained by available area, or 0 for invalid grid dimensions.
pub impl @base.Layout for GridLayout with width(
  self : GridLayout,
  area : @base.Area,
  children : Array[&@base.Widget],
) -> Int {
  ignore(children) // NOLINT
  if self.cols == 0 || self.rows == 0 {
    return 0
  }
  @cmp.minimum(area.width, self.cols * (area.width / self.cols))
}

///|
/// Calculates the preferred height for grid layout.
///
/// The height is determined by the grid row structure and available area,
/// ignoring individual child widget heights to maintain consistent grid alignment.
///
/// # Parameters
/// * `self`: The GridLayout instance
/// * `area`: The available area constraints
/// * `children`: Array of references to child widgets (ignored in calculation)
///
/// # Returns
/// The total grid height constrained by available area, or 0 for invalid grid dimensions.
pub impl @base.Layout for GridLayout with height(
  self : GridLayout,
  area : @base.Area,
  children : Array[&@base.Widget],
) -> Int {
  ignore(children) // NOLINT
  if self.cols == 0 || self.rows == 0 {
    return 0
  }
  @cmp.minimum(area.height, self.rows * (area.height / self.rows))
}
