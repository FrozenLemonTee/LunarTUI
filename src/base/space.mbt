///|
/// Represents a rectangular area with width and height dimensions.
///
/// Used to define the size and boundaries of display regions in the TUI framework.
/// Dimensions are automatically clamped to non-negative values.
pub struct Area {
  /// The width of the area in characters.
  width : Int
  /// The height of the area in characters.
  height : Int
} derive(Eq)

///|
/// Creates a new Area with specified dimensions.
///
/// # Parameters
/// * `width`: The desired width of the area
/// * `height`: The desired height of the area
///
/// # Returns
/// A new Area instance with dimensions clamped to non-negative values.
///
/// # Examples
/// ```moonbit
/// let valid_area = Area::new(10, 5)    // Creates 10x5 area
/// let clamped_area = Area::new(-5, 3)  // Creates 0x3 area (negative width clamped)
/// ```
pub fn Area::new(width : Int, height : Int) -> Area {
  Area::{ width: @cmp.maximum(0, width), height: @cmp.maximum(0, height) }
}

///|
/// Calculates the total size (area) of the region.
///
/// # Parameters
/// * `self`: The Area instance
///
/// # Returns
/// The total number of character cells in the area (width × height).
///
/// # Examples
/// ```moonbit
/// let area = Area::new(10, 5)
/// let size = area.size()  // Returns 50
/// ```
pub fn Area::size(self : Area) -> Int {
  self.width * self.height
}

///|
/// Represents a subsection of a larger area with position offset.
///
/// Defines a rectangular region within a parent area, specified by its
/// position (left, top) and dimensions (area).
pub struct Section {
  /// The dimensions of the section.
  area : Area
  /// The horizontal offset from the left edge of the parent area.
  left : Int
  /// The vertical offset from the top edge of the parent area.
  top : Int
} derive(Eq)

///|
/// Creates a new Section with specified area and position.
///
/// # Parameters
/// * `area`: The dimensions of the section
/// * `left`: The left offset position
/// * `top`: The top offset position
///
/// # Returns
/// A new Section instance with position coordinates clamped to non-negative values.
///
/// # Examples
/// ```moonbit
/// let area = Area::new(8, 4)
/// let section = Section::new(area, 2, 1)    // Section at position (2,1)
/// let clamped = Section::new(area, -1, 3)   // Section at position (0,3)
/// ```
pub fn Section::new(area : Area, left : Int, top : Int) -> Section {
  Section::{ area, left: @cmp.maximum(0, left), top: @cmp.maximum(0, top) }
}
