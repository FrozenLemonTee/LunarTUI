///|
/// Orientation direction for divider widgets.
///
/// Determines whether the divider is drawn horizontally or vertically.
pub(all) enum Direction {
  /// Horizontal divider running left to right.
  Row
  /// Vertical divider running top to bottom.
  Column
}

///|
/// A visual separator widget for creating borders and section dividers in the TUI.
///
/// The Divider widget draws a line of specified length and orientation,
/// with customizable line characters and optional edge markers. Useful for
/// visually separating different sections of the user interface.
pub struct Divider {
  /// The horizontal offset from the left edge of the parent container.
  left : Int
  /// The vertical offset from the top edge of the parent container.
  top : Int
  /// The length of the divider in characters.
  length : Int
  /// The main line character used for the body of the divider.
  line : Char
  /// The edge character used at the start and end of the divider.
  edge : Char
  /// The orientation of the divider (horizontal or vertical).
  direction : Direction
}

///|
/// Creates a new Divider with specified parameters.
///
/// # Parameters
/// * `length`: The length of the divider in characters
/// * `left`: Horizontal position offset (default: 0)
/// * `top`: Vertical position offset (default: 0)
/// * `line`: Custom line character (optional, defaults to '-' for horizontal, '|' for vertical)
/// * `edge`: Edge character for divider ends (default: '+')
/// * `direction`: Orientation of the divider (default: Row/horizontal)
///
/// # Returns
/// A new Divider instance ready for rendering.
pub fn Divider::new(
  length : Int,
  left? : Int = 0,
  top? : Int = 0,
  line? : Char,
  edge? : Char = '+',
  direction? : Direction = Direction::Row,
) -> Divider {
  let ch_line = match line {
    None =>
      match direction {
        Row => '-'
        Column => '|'
      }
    Some(line) => line
  }
  Divider::{ left, top, length, line: ch_line, direction, edge }
}

///|
/// Gets the width of the divider widget.
///
/// For horizontal dividers, width equals the length.
/// For vertical dividers, width is always 1 character.
///
/// # Parameters
/// * `self`: The Divider instance
///
/// # Returns
/// The width in characters based on divider orientation.
///
/// # Examples
/// ```moonbit
/// let hdiv = Divider::new(15, direction=Direction::Row)
/// let w = hdiv.width()  // Returns 15
/// 
/// let vdiv = Divider::new(10, direction=Direction::Column)
/// let w = vdiv.width()  // Returns 1
/// ```
pub impl @base.Widget for Divider with width(self : Divider) -> Int {
  match self.direction {
    Row => self.length
    Column => 1
  }
}

///|
/// Gets the height of the divider widget.
///
/// For horizontal dividers, height is always 1 character.
/// For vertical dividers, height equals the length.
///
/// # Parameters
/// * `self`: The Divider instance
///
/// # Returns
/// The height in character rows based on divider orientation.
///
/// # Examples
/// ```moonbit
/// let hdiv = Divider::new(15, direction=Direction::Row)
/// let h = hdiv.height()  // Returns 1
/// 
/// let vdiv = Divider::new(10, direction=Direction::Column)
/// let h = vdiv.height()  // Returns 10
/// ```
pub impl @base.Widget for Divider with height(self : Divider) -> Int {
  match self.direction {
    Row => 1
    Column => self.length
  }
}

///|
/// Renders the divider within the provided frame.
///
/// Draws a continuous line with edge characters at both ends. The divider
/// adapts its rendering based on the specified direction (horizontal or vertical).
///
/// # Parameters
/// * `self`: The Divider instance
/// * `frame`: The Frame to render into
///
/// # Rendering Behavior
/// - Uses edge characters at the start and end positions
/// - Uses line characters for all intermediate positions
/// - Renders horizontally (left to right) for Row direction
/// - Renders vertically (top to bottom) for Column direction
pub impl @base.Widget for Divider with render(
  self : Divider,
  frame : @base.Frame,
) -> Unit {
  let subframe = frame.subframe(
    self.left,
    self.top,
    self.width(),
    self.height(),
  )
  for i in 0..<self.length {
    let ch = if i == 0 || i == self.length - 1 { self.edge } else { self.line }
    match self.direction {
      Row => subframe.set_chars(i, 0, ch)
      Column => subframe.set_chars(0, i, ch)
    }
  }
}
