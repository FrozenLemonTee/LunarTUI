///|
/// Text alignment options for paragraph content.
///
/// Controls how text is horizontally aligned within the paragraph's bounding box.
pub(all) enum Align {
  /// Align text to the left edge of the paragraph area.
  Left
  /// Center text horizontally within the paragraph area.
  Center
  /// Align text to the right edge of the paragraph area.
  Right
}

///|
/// A multi-line text paragraph widget with automatic word wrapping and alignment.
///
/// The Paragraph widget displays formatted text within a defined rectangular area,
/// automatically handling line breaks at newline characters and at the boundary
/// of the paragraph width. Supports left, center, and right text alignment.
pub struct Paragraph {
  /// The text content to be displayed, with newline characters for explicit line breaks.
  text : String
  /// The horizontal alignment of text within the paragraph area.
  align : Align
  /// The position and dimensions of the paragraph within its parent container.
  section : @base.Section
}

///|
/// Creates a new Paragraph with specified position, dimensions, and text.
///
/// # Parameters
/// * `left`: The horizontal position from the left edge of the parent container
/// * `top`: The vertical position from the top edge of the parent container
/// * `width`: The width of the paragraph area in characters
/// * `height`: The height of the paragraph area in lines
/// * `text`: The text content to display (supports newlines for explicit breaks)
/// * `align`: Text alignment within the paragraph (default: Left)
///
/// # Returns
/// A new Paragraph instance with automatic line wrapping capabilities.
///
/// # Examples
/// ```moonbit
/// let para = Paragraph::new(2, 3, 30, 5, "This is a long text that will wrap automatically.", align=Center)
/// ```
pub fn Paragraph::new(
  left : Int,
  top : Int,
  width : Int,
  height : Int,
  text : String,
  align? : Align = Align::Left,
) -> Paragraph {
  let left = @cmp.maximum(0, left)
  let top = @cmp.maximum(0, top)
  let width = @cmp.maximum(0, width)
  let height = @cmp.maximum(0, height)
  let section = @base.Section::new(@base.Area::new(width, height), left, top)
  Paragraph::{ text, align, section }
}

///|
/// Creates a new Paragraph from an existing Section.
///
/// # Parameters
/// * `section`: The pre-defined section specifying position and dimensions
/// * `text`: The text content to display
/// * `align`: Text alignment within the paragraph (default: Left)
///
/// # Returns
/// A new Paragraph instance using the provided section for layout.
///
/// # Examples
/// ```moonbit
/// let section = @base.Section::new(@base.Area::new(40, 10), 5, 2)
/// let para = Paragraph::from_section(section, "Pre-formatted text content", align=Right)
/// ```
pub fn Paragraph::from_section(
  section : @base.Section,
  text : String,
  align? : Align = Align::Left,
) -> Paragraph {
  Paragraph::{ text, align, section }
}

///|
/// Gets the width of the paragraph area.
///
/// # Parameters
/// * `self`: The Paragraph instance
///
/// # Returns
/// The width of the paragraph in characters.
pub impl @base.Widget for Paragraph with width(self : Paragraph) -> Int {
  self.section.area.width
}

///|
/// Gets the height of the paragraph area.
///
/// # Parameters
/// * `self`: The Paragraph instance
///
/// # Returns
/// The height of the paragraph in lines.
pub impl @base.Widget for Paragraph with height(self : Paragraph) -> Int {
  self.section.area.height
}

///|
/// Calculates line break positions for the paragraph text.
///
/// This internal method processes the text to determine where line breaks
/// should occur, either at newline characters or when the line exceeds
/// the paragraph width.
///
/// # Parameters
/// * `self`: The Paragraph instance
///
/// # Returns
/// An array of indices indicating the start position of each line.
///
/// # Algorithm
/// - Starts each line at index 0 or after a newline
/// - Breaks lines when character count exceeds paragraph width
/// - Preserves explicit newline characters as line breaks
fn Paragraph::indices(self : Paragraph) -> Array[Int] {
  let text = self.text
  let width = self.section.area.width
  let line_starts = [0]
  let mut count = 0
  for i in 0..<text.length() {
    let ch = text[i]
    count += 1
    if ch == '\n' {
      line_starts.push(i + 1)
      count = 0
    } else if count >= width {
      line_starts.push(i + 1)
      count = 0
    }
  }
  line_starts
}

///|
/// Renders a single line of text with proper alignment.
///
/// This internal method handles the rendering of individual text lines
/// with the specified alignment (left, center, or right).
///
/// # Parameters
/// * `self`: The Paragraph instance
/// * `frame`: The frame to render the line into
/// * `start`: The starting index of the line in the text
/// * `end`: The ending index of the line in the text
///
/// # Alignment Behavior
/// - Left: Text starts at left edge
/// - Center: Text centered horizontally with equal padding on both sides
/// - Right: Text aligned to right edge with padding on the left
fn Paragraph::draw_line(
  self : Paragraph,
  frame : @base.Frame,
  start : Int,
  end : Int,
) -> Unit {
  let text = self.text.view()
  if start >= text.length() {
    return
  }
  let line_len = end - start
  let line = text.iter().drop(start).take(line_len)
  let line_len_max = self.width()
  let space = line_len_max - line_len
  let left = match self.align {
    Center => space / 2
    Left => 0
    Right => line_len_max - line_len
  }
  let subframe = frame.subframe(left, 0, line_len_max, 1)
  for i, ch in line.iter2() {
    subframe.set_chars(i, 0, ch)
  }
}

///|
/// Renders the entire paragraph with line wrapping and alignment.
///
/// The paragraph is rendered within its allocated section, with text automatically
/// wrapped to fit the paragraph width. Both explicit newlines and automatic
/// wrapping at width boundaries are supported.
///
/// # Parameters
/// * `self`: The Paragraph instance
/// * `frame`: The parent frame to render into
///
/// # Rendering Process
/// 1. Creates a subframe for the paragraph's section
/// 2. Calculates line break positions
/// 3. Renders each line with proper alignment
/// 4. Clips text that exceeds the paragraph height
pub impl @base.Widget for Paragraph with render(
  self : Paragraph,
  frame : @base.Frame,
) -> Unit {
  let subframe = frame.subframe(
    self.section.left,
    self.section.top,
    self.width(),
    self.height(),
  )
  let line_starts = self.indices()
  for i in 0..<line_starts.length() {
    let start = line_starts[i]
    let end = if i + 1 < line_starts.length() {
      line_starts[i + 1]
    } else {
      self.text.length()
    }
    let frame_line = subframe.subframe(0, i, self.width(), 1)
    self.draw_line(frame_line, start, end)
  }
}
