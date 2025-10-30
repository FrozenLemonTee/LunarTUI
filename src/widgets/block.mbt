///|
/// A bordered container widget with optional title and child content arrangement.
///
/// The Block widget provides a visually distinct bordered area that can contain
/// other widgets, with an optional title displayed in the top border. It combines
/// border rendering, title management, and child widget containment in a single
/// component, making it ideal for creating panels, windows, and grouped UI sections.
pub struct Block {
  /// The title text displayed in the top border of the block.
  mut title : String
  /// The position and dimensions of the entire block including borders.
  section : @base.Section
  /// The internal container that manages child widgets and layout.
  container : Container
}

///|
/// Creates a new Block with specified position, dimensions, and optional content.
///
/// # Parameters
/// * `left`: The horizontal position from the left edge of the parent container
/// * `top`: The vertical position from the top edge of the parent container
/// * `width`: The total width of the block including borders
/// * `height`: The total height of the block including borders
/// * `title`: Optional title text displayed in the top border (default: "")
/// * `child`: Optional initial child widget to add to the block
/// * `layout`: Optional layout algorithm for arranging children
///
/// # Returns
/// A new Block instance with borders and optional title/child content.
///
/// # Layout Considerations
/// The internal content area is reduced by 1 character on each side to accommodate
/// borders, so child widgets are rendered within (width-2, height-2) area.
pub fn Block::new(
  left : Int,
  top : Int,
  width : Int,
  height : Int,
  title? : String = "",
  child? : &@base.Widget,
  layout? : &@base.Layout,
) -> Block {
  let left = @cmp.maximum(0, left)
  let top = @cmp.maximum(0, top)
  let width = @cmp.maximum(0, width)
  let height = @cmp.maximum(0, height)
  let section_block = @base.Section::new(
    @base.Area::new(width, height),
    left,
    top,
  )
  let section_children = @base.Section::new(
    @base.Area::new(width - 1, height - 1),
    left + 1,
    top + 1,
  )
  let block = match layout {
    None =>
      Block::{
        title,
        section: section_block,
        container: Container::from_section(section_children),
      }
    Some(layout) =>
      Block::{
        title,
        section: section_block,
        container: Container::from_section(layout~, section_children),
      }
  }
  match child {
    Some(child) => block.container.add(child)
    None => ()
  }
  block
}

///|
/// Creates a new Block from an existing Section with optional content.
///
/// # Parameters
/// * `section`: Pre-defined section specifying position and dimensions
/// * `title`: Optional title text displayed in the top border (default: "")
/// * `child`: Optional initial child widget to add to the block
/// * `layout`: Optional layout algorithm for arranging children
///
/// # Returns
/// A new Block instance using the provided section for layout.
pub fn Block::from_section(
  section : @base.Section,
  title? : String = "",
  child? : &@base.Widget,
  layout? : &@base.Layout,
) -> Block {
  Block::new(
    section.left,
    section.top,
    section.area.width,
    section.area.height,
    title~,
    child?,
    layout?,
  )
}

///|
/// Sets or updates the title text of the block.
///
/// # Parameters
/// * `self`: The Block instance
/// * `title`: New title text to display in the top border
pub fn Block::set_title(self : Block, title : String) -> Unit {
  self.title = title
}

///|
/// Adds a child widget to the block's internal container.
///
/// # Parameters
/// * `self`: The Block instance
/// * `child`: The child widget to add to the block
pub fn Block::add(self : Block, child : &@base.Widget) -> Unit {
  self.container.add(child)
}

///|
/// Adds multiple child widgets to the block's internal container at once.
///
/// # Parameters
/// * `self`: The Block instance
/// * `children`: Array of child widgets to add to the block
pub fn Block::add_all(self : Block, children : Array[&@base.Widget]) -> Unit {
  self.container.add_all(children)
}

///|
/// Draws the border around the block with customizable characters.
///
/// This internal method renders the four sides and four corners of the block
/// using specified border characters for a consistent visual appearance.
///
/// # Parameters
/// * `self`: The Block instance
/// * `frame`: The frame to render the border into
/// * `hor`: Horizontal border character (default: '-')
/// * `ver`: Vertical border character (default: '|')
/// * `edge`: Corner character (default: '+')
///
/// # Border Rendering
/// - Top and bottom edges use horizontal character
/// - Left and right edges use vertical character
/// - Four corners use the edge character
fn Block::draw_border(
  self : Block,
  frame : @base.Frame,
  hor? : Char = '-',
  ver? : Char = '|',
  edge? : Char = '+',
) -> Unit {
  for i in 0..<self.width() {
    frame.set_chars(i, 0, hor)
    frame.set_chars(i, self.height() - 1, hor)
  }
  for j in 0..<self.height() {
    frame.set_chars(0, j, ver)
    frame.set_chars(self.width() - 1, j, ver)
  }
  frame.set_chars(0, 0, edge)
  frame.set_chars(self.width() - 1, 0, edge)
  frame.set_chars(0, self.height() - 1, edge)
  frame.set_chars(self.width() - 1, self.height() - 1, edge)
}

///|
/// Draws the title text in the top border of the block.
///
/// This internal method renders the title starting from position (2, 0)
/// within the block's top border, ensuring it doesn't interfere with corners.
///
/// # Parameters
/// * `self`: The Block instance
/// * `frame`: The frame to render the title into
fn Block::draw_title(self : Block, frame : @base.Frame) -> Unit {
  for i, ch in self.title.iter2() {
    frame.set_chars(2 + i, 0, ch)
  }
}

///|
/// Renders all child widgets within the block's content area.
///
/// This internal method delegates to the internal container to render
/// all child widgets within the bordered content area (excluding borders).
///
/// # Parameters
/// * `self`: The Block instance
/// * `frame`: The frame to render children into
fn Block::draw_children(self : Block, frame : @base.Frame) -> Unit {
  let subframe = frame.subframe(1, 1, self.width() - 2, self.height() - 2)
  self.container.render(subframe)
}

///|
/// Gets the total width of the block including borders.
///
/// # Parameters
/// * `self`: The Block instance
///
/// # Returns
/// The total width of the block in characters including border characters.
pub impl @base.Widget for Block with width(self : Block) -> Int {
  self.section.area.width
}

///|
/// Gets the total height of the block including borders.
///
/// # Parameters
/// * `self`: The Block instance
///
/// # Returns
/// The total height of the block in character rows including border rows.
pub impl @base.Widget for Block with height(self : Block) -> Int {
  self.section.area.height
}

///|
/// Renders the complete block including borders, title, and child content.
///
/// The rendering process occurs in three distinct phases:
/// 1. Draw border around the entire block
/// 2. Draw title in the top border (if present)
/// 3. Render all child widgets in the internal content area
///
/// # Parameters
/// * `self`: The Block instance
/// * `frame`: The parent frame to render into
pub impl @base.Widget for Block with render(self : Block, frame : @base.Frame) -> Unit {
  let subframe = frame.subframe(
    self.section.left,
    self.section.top,
    self.width(),
    self.height(),
  )
  self.draw_border(subframe)
  self.draw_title(subframe)
  self.draw_children(subframe)
}
