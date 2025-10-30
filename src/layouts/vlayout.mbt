///|
/// A vertical layout that arranges widgets top-to-bottom with center alignment.
///
/// VLayout divides the available height equally among child widgets and centers
/// each widget within its allocated cell. Widgets are constrained to fit within
/// their allocated space.
pub struct VLayout {}

///|
/// Creates a new vertical layout manager.
///
/// # Returns
/// A new VLayout instance ready to arrange widgets vertically.
///
/// # Examples
/// ```moonbit
/// let layout = VLayout::new()
/// ```
pub fn VLayout::new() -> VLayout {
  VLayout::{  }
}

///|
/// Splits the area vertically into equal sections for each child widget.
///
/// Each child widget is centered within its allocated cell. If a widget's
/// preferred size is larger than the allocated cell, it will be constrained
/// to fit within the cell boundaries.
///
/// # Parameters
/// * `self`: The VLayout instance
/// * `area`: The total available area to split among children
/// * `children`: Array of references to child widgets to arrange vertically
///
/// # Returns
/// An array of Sections, each defining the position and size for a child widget
/// arranged from top to bottom.
pub impl @base.Layout for VLayout with split(
  self : VLayout,
  area : @base.Area,
  children : Array[&@base.Widget],
) -> Array[@base.Section] {
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
/// Calculates the preferred width for vertical layout with given children.
///
/// The width is the maximum of all children's preferred widths, constrained by
/// the available area width.
///
/// # Parameters
/// * `self`: The VLayout instance
/// * `area`: The available area constraints
/// * `children`: Array of references to child widgets
///
/// # Returns
/// The minimum between the maximum child width and available area width.
pub impl @base.Layout for VLayout with width(
  self : VLayout,
  area : @base.Area,
  children : Array[&@base.Widget],
) -> Int {
  ignore(self) // NOLINT
  let child_max = children
    .iter()
    .map(fn(child) { child.width() })
    .fold(fn(max, cur) { @cmp.maximum(max, cur) }, init=0)
  @cmp.minimum(child_max, area.width)
}

///|
/// Calculates the preferred height for vertical layout with given children.
///
/// The height is the sum of all children's preferred heights, constrained by
/// the available area height.
///
/// # Parameters
/// * `self`: The VLayout instance
/// * `area`: The available area constraints
/// * `children`: Array of references to child widgets
///
/// # Returns
/// The minimum between the total children height and available area height.
pub impl @base.Layout for VLayout with height(
  self : VLayout,
  area : @base.Area,
  children : Array[&@base.Widget],
) -> Int {
  ignore(self) // NOLINT
  let children_total = children
    .iter()
    .map(fn(child) { child.height() })
    .fold(fn(acc, cur) { acc + cur }, init=0)
  @cmp.minimum(children_total, area.height)
}
