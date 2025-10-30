///|
/// A container widget that groups and arranges child widgets using layout algorithms.
///
/// The Container widget serves as a parent component that can hold multiple child widgets
/// and arrange them according to a specified layout strategy. It supports both positioned
/// layout (no layout manager) and automatic layout using various layout algorithms.
pub struct Container {
  /// The layout algorithm used to arrange child widgets (optional).
  /// If None, children are rendered at their inherent positions.
  layout : &@base.Layout?
  /// The position and dimensions of the container within its parent.
  section : @base.Section
  /// The child widgets contained within this container.
  children : Array[&@base.Widget]
}

///|
/// Creates a new Container with specified position, dimensions, and optional layout.
///
/// # Parameters
/// * `left`: The horizontal position from the left edge of the parent container
/// * `top`: The vertical position from the top edge of the parent container
/// * `width`: The width of the container in characters
/// * `height`: The height of the container in character rows
/// * `layout`: The layout algorithm to use for arranging children (optional)
/// * `children`: Initial array of child widgets (default: empty)
///
/// # Returns
/// A new Container instance ready to hold and arrange child widgets.
pub fn Container::new(
  left : Int,
  top : Int,
  width : Int,
  height : Int,
  layout? : &@base.Layout,
  children? : Array[&@base.Widget] = [],
) -> Container {
  let section = @base.Section::new(@base.Area::new(width, height), left, top)
  Container::from_section(layout?, section, children~)
}

///|
/// Creates a new Container from an existing Section with optional layout.
///
/// # Parameters
/// * `layout`: The layout algorithm to use for arranging children (optional)
/// * `section`: Pre-defined section specifying position and dimensions
/// * `children`: Initial array of child widgets (default: empty)
///
/// # Returns
/// A new Container instance using the provided section for layout.
pub fn Container::from_section(
  layout? : &@base.Layout,
  section : @base.Section,
  children? : Array[&@base.Widget] = [],
) -> Container {
  Container::{ layout, section, children }
}

///|
/// Adds a single child widget to the container.
///
/// # Parameters
/// * `self`: The Container instance
/// * `child`: The child widget to add to the container
pub fn Container::add(self : Container, child : &@base.Widget) -> Unit {
  self.children.push(child)
}

///|
/// Adds multiple child widgets to the container at once.
///
/// # Parameters
/// * `self`: The Container instance
/// * `children`: Array of child widgets to add to the container
pub fn Container::add_all(
  self : Container,
  children : Array[&@base.Widget],
) -> Unit {
  self.children.append(children)
}

///|
/// Gets the preferred width of the container.
///
/// When a layout manager is specified, delegates to the layout's width calculation.
/// When no layout manager is set, returns the container's fixed width.
///
/// # Parameters
/// * `self`: The Container instance
///
/// # Returns
/// The preferred width in characters based on layout strategy.
pub impl @base.Widget for Container with width(self : Container) -> Int {
  match self.layout {
    Some(layout) => layout.width(self.section.area, self.children)
    None => self.section.area.width
  }
}

///|
/// Gets the preferred height of the container.
///
/// When a layout manager is specified, delegates to the layout's height calculation.
/// When no layout manager is set, returns the container's fixed height.
///
/// # Parameters
/// * `self`: The Container instance
///
/// # Returns
/// The preferred height in character rows based on layout strategy.
pub impl @base.Widget for Container with height(self : Container) -> Int {
  match self.layout {
    Some(layout) => layout.height(self.section.area, self.children)
    None => self.section.area.height
  }
}

///|
/// Renders the container and all its child widgets.
///
/// The rendering behavior depends on whether a layout manager is specified:
/// - With layout: Children are arranged according to the layout algorithm
/// - Without layout: Children are rendered at their inherent positions
///
/// # Parameters
/// * `self`: The Container instance
/// * `frame`: The parent frame to render into
///
/// # Rendering Modes
/// ## With Layout Manager
/// 1. The layout calculates sections for each child
/// 2. Creates subframes for each child's allocated area
/// 3. Delegates rendering to each child within their subframe
///
/// ## Without Layout Manager
/// 1. Each child is rendered directly into the parent frame
/// 2. Children use their own position coordinates
/// 3. No automatic arrangement is performed
pub impl @base.Widget for Container with render(
  self : Container,
  frame : @base.Frame,
) -> Unit {
  if self.children.is_empty() {
    return
  }
  match self.layout {
    None =>
      for child in self.children {
        child.render(frame)
      }
    Some(layout) => {
      let area = self.section.area
      let sections = layout.split(area, self.children)
      for i, child in self.children.iter2() {
        let sec = sections[i]
        let subframe = frame.subframe(
          sec.left,
          sec.top,
          sec.area.width,
          sec.area.height,
        )
        child.render(subframe)
      }
    }
  }
}
