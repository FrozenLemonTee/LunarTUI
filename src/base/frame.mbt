///|
/// Represents a viewport into a buffer with clipping and coordinate translation.
///
/// A Frame defines a rectangular subsection of a buffer, providing a way to
/// render content within specific boundaries and create nested UI components.
pub struct Frame {
  /// The underlying buffer that stores the actual content.
  buf : Buffer
  /// The section of the buffer that this frame represents.
  section : Section
}

///|
/// Creates a new Frame that views a subsection of a buffer.
///
/// The frame will be automatically clipped to stay within the buffer's boundaries.
///
/// # Parameters
/// * `buf`: The underlying buffer to view
/// * `section`: The section of the buffer to display in this frame
///
/// # Returns
/// A new Frame instance with adjusted dimensions to fit within buffer bounds.
///
/// # Examples
/// ```moonbit
/// let buffer = Buffer::new(Area::new(20, 10))
/// let section = Section::new(Area::new(5, 3), 2, 1)
/// let frame = Frame::new(buffer, section)  // Creates 5x3 frame at (2,1)
/// ```
pub fn Frame::new(buf : Buffer, section : Section) -> Frame {
  let (left, top) = (
    @cmp.minimum(section.left, buf.area.width),
    @cmp.minimum(section.top, buf.area.height),
  )
  let (right, bottom) = (
    @cmp.minimum(left + section.area.width, buf.area.width),
    @cmp.minimum(top + section.area.height, buf.area.height),
  )
  let (width, height) = (right - left, bottom - top)
  Frame::{ buf, section: Section::new(Area::new(width, height), left, top) }
}

///|
/// Gets the area of the underlying buffer.
///
/// # Parameters
/// * `self`: The Frame instance
///
/// # Returns
/// The Area representing the full dimensions of the underlying buffer.
pub fn Frame::area(self : Frame) -> Area {
  self.buf.area
}

///|
/// Sets a character at the specified position within the frame.
///
/// Coordinates are relative to the frame's top-left corner. Positions outside
/// the frame's boundaries are silently ignored.
///
/// # Parameters
/// * `self`: The Frame instance
/// * `left`: The x-coordinate relative to the frame (0-based)
/// * `top`: The y-coordinate relative to the frame (0-based)
/// * `ch`: The character to set
///
/// # Returns
/// Unit, indicating the operation is performed for side effects.
///
/// # Examples
/// ```moonbit
/// let frame = Frame::new(buffer, section)
/// frame.set_chars(1, 2, 'X')  // Sets 'X' at frame-relative position (1,2)
/// ```
pub fn Frame::set_chars(self : Frame, left : Int, top : Int, ch : Char) -> Unit {
  if left < 0 || left >= self.section.area.width {
    return
  }
  if top < 0 || top >= self.section.area.height {
    return
  }
  let buf_x = left + self.section.left
  let buf_y = top + self.section.top
  self.buf.set_chars(buf_x, buf_y, ch)
}

///|
/// Creates a subframe within the current frame.
///
/// The subframe's coordinates are relative to the current frame's top-left corner.
/// Useful for creating nested UI components with local coordinate systems.
///
/// # Parameters
/// * `self`: The parent Frame instance
/// * `left`: The left offset relative to the parent frame
/// * `top`: The top offset relative to the parent frame
/// * `width`: The width of the subframe
/// * `height`: The height of the subframe
///
/// # Returns
/// A new Frame representing the specified subsection of the parent frame.
///
/// # Examples
/// ```moonbit
/// let parent = Frame::new(buffer, Section::new(Area::new(10, 5), 0, 0))
/// let child = parent.subframe(2, 1, 6, 3)  // Creates 6x3 frame at (2,1) relative to parent
/// ```
pub fn Frame::subframe(
  self : Frame,
  left : Int,
  top : Int,
  width : Int,
  height : Int,
) -> Frame {
  Frame::new(
    self.buf,
    Section::new(
      Area::new(width, height),
      @cmp.maximum(0, left) + self.section.left,
      @cmp.maximum(0, top) + self.section.top,
    ),
  )
}
