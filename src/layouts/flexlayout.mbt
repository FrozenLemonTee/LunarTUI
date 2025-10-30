///|
/// The main axis direction for flex layout arrangement.
///
/// Determines whether children are arranged horizontally (Row) or vertically (Column).
pub(all) enum Direction {
  /// Arrange children horizontally from left to right.
  Row
  /// Arrange children vertically from top to bottom.
  Column
} derive(Eq)

///|
/// Defines how children are distributed along the main axis in flex layout.
///
/// Controls the spacing behavior between children when there's extra space available.
pub(all) enum Justify {
  /// Pack children at the start of the main axis.
  Start
  /// Pack children at the center of the main axis.
  Center
  /// Pack children at the end of the main axis.
  End
  /// Distribute children evenly with equal space between them.
  SpaceBetween
  /// Distribute children with equal space around them.
  SpaceAround
  /// Distribute children with equal space around and between them.
  SpaceEvenly
} derive(Eq)

///|
/// Defines how children are aligned along the cross axis in flex layout.
///
/// Controls the positioning of children perpendicular to the main axis direction.
pub(all) enum Align {
  /// Align children at the start of the cross axis.
  Start
  /// Align children at the center of the cross axis.
  Center
  /// Align children at the end of the cross axis.
  End
} derive(Eq)

///|
/// A flexible box layout that arranges widgets with configurable alignment and spacing.
///
/// FlexLayout provides CSS Flexbox-like layout capabilities, allowing flexible
/// arrangement of children along configurable axes with various justification
/// and alignment options.
pub(all) struct FlexLayout {
  /// The main axis direction for child arrangement.
  direction : Direction
  /// How children are distributed along the main axis.
  justify : Justify
  /// How children are aligned along the cross axis.
  align : Align
}

///|
/// Creates a new flexible layout manager with configurable options.
///
/// # Parameters
/// * `direction`: The main axis direction (default: Row)
/// * `justify`: Main axis distribution (default: Start)
/// * `align`: Cross axis alignment (default: Start)
///
/// # Returns
/// A new FlexLayout instance with the specified configuration.
///
/// # Examples
/// ```moonbit
/// let layout = FlexLayout::new()  // Default row layout
/// let centered = FlexLayout::new(Direction::Column, Justify::Center, Align::Center)
/// ```
pub fn FlexLayout::new(
  direction? : Direction = Direction::Row,
  justify? : Justify = Justify::Start,
  align? : Align = Align::Start,
) -> FlexLayout {
  FlexLayout::{ direction, justify, align }
}

///|
/// Gets the child's size along the main axis based on layout direction.
///
/// # Parameters
/// * `self`: The FlexLayout instance
/// * `child`: The child widget to measure
///
/// # Returns
/// The child's width for Row direction, height for Column direction.
fn FlexLayout::child_main_size(self : FlexLayout, child : &@base.Widget) -> Int {
  match self.direction {
    Row => child.width()
    Column => child.height()
  }
}

///|
/// Gets the child's size along the cross axis based on layout direction.
///
/// # Parameters
/// * `self`: The FlexLayout instance
/// * `child`: The child widget to measure
///
/// # Returns
/// The child's height for Row direction, width for Column direction.
fn FlexLayout::child_cross_size(
  self : FlexLayout,
  child : &@base.Widget,
) -> Int {
  match self.direction {
    Row => child.height()
    Column => child.width()
  }
}

///|
/// Splits the area using flexible box layout algorithm.
///
/// Arranges children along the main axis according to the justify policy,
/// and aligns them along the cross axis according to the align policy.
/// Handles various space distribution strategies including SpaceBetween,
/// SpaceAround, and SpaceEvenly.
///
/// # Parameters
/// * `self`: The FlexLayout instance
/// * `area`: The total available area for layout
/// * `children`: Array of references to child widgets to arrange
///
/// # Returns
/// An array of Sections positioned according to flex layout rules.
pub impl @base.Layout for FlexLayout with split(
  self : FlexLayout,
  area : @base.Area,
  children : Array[&@base.Widget],
) -> Array[@base.Section] {
  let count = children.length()
  if count == 0 {
    return []
  }
  let (main_size, cross_size) = match self.direction {
    Row => (area.width, area.height)
    Column => (area.height, area.width)
  }
  let main_size_children = children
    .iter()
    .map(fn(child) { self.child_main_size(child) })
    .fold(fn(acc, cur) { acc + cur }, init=0)
  let remaining = main_size - main_size_children
  if remaining < 0 {
    return []
  }
  let (space, extra_init) = match self.justify {
    SpaceBetween =>
      if count > 1 {
        (remaining / (count - 1), remaining % (count - 1))
      } else {
        (0, 0)
      }
    SpaceAround => (remaining / count, remaining % count)
    SpaceEvenly => (remaining / (count + 1), remaining % (count + 1))
    _ => (0, 0)
  }
  let mut offset = match self.justify {
    Start => 0
    Center => remaining / 2
    End => remaining
    SpaceBetween => 0
    SpaceAround => space / 2
    SpaceEvenly => space
  }
  let sections = Array::default()
  let mut extra = extra_init
  for i, child in children.iter2() {
    let cur = offset
    let main_step = self.child_main_size(child)
    offset += main_step
    match self.justify {
      SpaceBetween if i < count - 1 => {
        offset += space
        if extra > 0 {
          offset += 1
          extra -= 1
        }
      }
      SpaceAround | SpaceEvenly => {
        offset += space
        if extra > 0 {
          offset += 1
          extra -= 1
        }
      }
      _ => ()
    }
    let cross = match self.align {
      Start => 0
      Center => (cross_size - self.child_cross_size(child)) / 2
      End => cross_size - self.child_cross_size(child)
    }
    let (x, y, width, height) = match self.direction {
      Row => (cur, cross, child.width(), cross_size)
      Column => (cross, cur, cross_size, child.height())
    }
    sections.push(@base.Section::new(@base.Area::new(width, height), x, y))
  }
  sections
}

///|
/// Calculates the preferred width for flex layout.
///
/// For Row direction: sum of all children's widths.
/// For Column direction: maximum of all children's widths.
///
/// # Parameters
/// * `self`: The FlexLayout instance
/// * `area`: The available area constraints
/// * `children`: Array of references to child widgets
///
/// # Returns
/// The calculated width constrained by available area.
pub impl @base.Layout for FlexLayout with width(
  self : FlexLayout,
  area : @base.Area,
  children : Array[&@base.Widget],
) -> Int {
  if children.is_empty() {
    return 0
  }
  let fold = match self.direction {
    Row => fn(acc : Int, cur : Int) { acc + cur }
    Column => fn(max : Int, cur : Int) { @cmp.maximum(max, cur) }
  }
  let children_size = children
    .iter()
    .map(fn(child) { child.width() })
    .fold(fold, init=0)
  @cmp.minimum(children_size, area.width)
}

///|
/// Calculates the preferred height for flex layout.
///
/// For Row direction: maximum of all children's heights.
/// For Column direction: sum of all children's heights.
///
/// # Parameters
/// * `self`: The FlexLayout instance
/// * `area`: The available area constraints
/// * `children`: Array of references to child widgets
///
/// # Returns
/// The calculated height constrained by available area.
pub impl @base.Layout for FlexLayout with height(
  self : FlexLayout,
  area : @base.Area,
  children : Array[&@base.Widget],
) -> Int {
  if children.is_empty() {
    return 0
  }
  let fold = match self.direction {
    Row => fn(max : Int, cur : Int) { @cmp.maximum(max, cur) }
    Column => fn(acc : Int, cur : Int) { acc + cur }
  }
  let children_size = children
    .iter()
    .map(fn(child) { child.height() })
    .fold(fold, init=0)
  @cmp.minimum(children_size, area.height)
}
