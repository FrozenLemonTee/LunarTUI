///|
/// Defines the interface for layout algorithms that arrange widgets within an area.
///
/// Layout traits are responsible for calculating the position and size of child widgets
/// within a given container area. Implementations can provide various layout strategies
/// like horizontal, vertical, grid, or custom arrangements.
pub(open) trait Layout {
  /// Splits the available area into sections for each child widget.
  ///
  /// # Parameters
  /// * `self`: The Layout instance
  /// * `area`: The total available area to split among children
  /// * `children`: Array of references to child widgets that need to be laid out
  ///
  /// # Returns
  /// An array of Sections, each defining the position and size for a corresponding child widget.
  ///
  /// # Examples
  /// ```moonbit
  /// let layout = HorizontalLayout::new()
  /// let sections = layout.split(Area::new(100, 20), [&button1, &button2])
  /// // Returns sections for two buttons arranged horizontally
  /// ```
  split(self : Self, area : Area, children : Array[&Widget]) -> Array[Section]

  /// Calculates the preferred width for this layout with given children.
  ///
  /// # Parameters
  /// * `self`: The Layout instance
  /// * `area`: The available area constraints
  /// * `children`: Array of references to child widgets
  ///
  /// # Returns
  /// The preferred width in characters that this layout would occupy.
  width(self : Self, area : Area, children : Array[&Widget]) -> Int

  /// Calculates the preferred height for this layout with given children.
  ///
  /// # Parameters
  /// * `self`: The Layout instance
  /// * `area`: The available area constraints
  /// * `children`: Array of references to child widgets
  ///
  /// # Returns
  /// The preferred height in character rows that this layout would occupy.
  height(self : Self, area : Area, children : Array[&Widget]) -> Int
}

///|
/// Defines the interface for UI components that can be rendered in the TUI.
///
/// Widgets are the building blocks of the user interface. Each widget is responsible
/// for its own dimensions and rendering logic within the provided frame.
pub(open) trait Widget {
  /// Gets the preferred width of the widget.
  ///
  /// # Parameters
  /// * `self`: The Widget instance
  ///
  /// # Returns
  /// The preferred width in characters that this widget would like to occupy.
  ///
  /// # Note
  /// The actual rendered width may be different due to layout constraints.
  width(self : Self) -> Int

  /// Gets the preferred height of the widget.
  ///
  /// # Parameters
  /// * `self`: The Widget instance
  ///
  /// # Returns
  /// The preferred height in character rows that this widget would like to occupy.
  ///
  /// # Note
  /// The actual rendered height may be different due to layout constraints.
  height(self : Self) -> Int

  /// Renders the widget's content into the provided frame.
  ///
  /// # Parameters
  /// * `self`: The Widget instance
  /// * `frame`: The Frame to render into. The frame's dimensions represent the
  ///            allocated space for this widget.
  ///
  /// # Returns
  /// Unit, indicating the rendering operation is complete.
  render(self : Self, frame : Frame) -> Unit
}
