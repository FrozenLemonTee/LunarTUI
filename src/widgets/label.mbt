///|
/// A simple text label widget for displaying static text in the TUI.
///
/// The Label widget displays a single line of text at a specified position
/// within its allocated frame. It supports Unicode text and can be positioned
/// with optional left and top offsets.
pub struct Label {
  /// The text content to be displayed by the label.
  text : String
  /// The horizontal offset from the left edge of the allocated frame.
  left : Int
  /// The vertical offset from the top edge of the allocated frame.
  top : Int
}

///|
/// Creates a new Label with the specified text and optional position.
///
/// # Parameters
/// * `text`: The text content to display
/// * `left`: Horizontal offset from the left edge (default: 0, clamped to non-negative)
/// * `top`: Vertical offset from the top edge (default: 0, clamped to non-negative)
///
/// # Returns
/// A new Label instance ready for rendering.
///
/// # Examples
/// ```moonbit
/// let label1 = Label::new("Hello")           // Label at (0, 0)
/// let label2 = Label::new("World", 2, 1)    // Label at (2, 1)
/// ```
pub fn Label::new(text : String, left? : Int = 0, top? : Int = 0) -> Label {
  Label::{ text, left: @cmp.maximum(0, left), top: @cmp.maximum(0, top) }
}

///|
/// Gets the preferred width of the label.
///
/// The width is determined by the number of characters in the text content.
///
/// # Parameters
/// * `self`: The Label instance
///
/// # Returns
/// The length of the text string in characters.
///
/// # Examples
/// ```moonbit
/// let label = Label::new("Hello")
/// let w = label.width()  // Returns 5
/// ```
pub impl @base.Widget for Label with width(self : Label) -> Int {
  self.text.length()
}

///|
/// Gets the preferred height of the label.
///
/// Labels are single-line widgets, so the height is always 1.
///
/// # Parameters
/// * `self`: The Label instance
///
/// # Returns
/// Always returns 1, as labels occupy a single row.
///
/// # Examples
/// ```moonbit
/// let label = Label::new("Hello")
/// let h = label.height()  // Returns 1
/// ```
pub impl @base.Widget for Label with height(self : Label) -> Int {
  ignore(self) // NOLINT
  1
}

///|
/// Renders the label text within the provided frame.
///
/// The text is rendered at the label's specified position (left, top) within
/// the frame. If the text exceeds the frame boundaries, it will be clipped.
/// Each character is placed individually to support proper Unicode handling.
///
/// # Parameters
/// * `self`: The Label instance
/// * `frame`: The Frame to render into
///
/// # Rendering Behavior
/// - Creates a subframe at the label's position with dimensions matching the text length
/// - Renders each character sequentially from left to right
/// - Supports Unicode characters through the frame's character setting mechanism
pub impl @base.Widget for Label with render(self : Label, frame : @base.Frame) -> Unit {
  let subframe = frame.subframe(self.left, self.top, self.text.length(), 1)
  for i, ch in self.text.iter2() {
    subframe.set_chars(i, 0, ch)
  }
}
