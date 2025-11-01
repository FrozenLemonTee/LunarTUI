///|
/// Display modes for the progress bar value.
///
/// Controls how the current progress value is displayed alongside the visual bar.
pub(all) enum ShowMode {
  /// Display value as percentage (e.g., "75%")
  Percentage
  /// Display value as decimal (e.g., "0.75")
  Decimal
  /// Don't display the value, only show the visual bar
  Null
} derive(Eq)

///|
/// A visual progress indicator widget for showing completion status.
///
/// The ProgressBar displays a graphical bar that fills from left to right
/// based on the current progress value. Supports customizable prefixes,
/// suffixes, and multiple value display modes.
pub struct ProgressBar {
  /// The current progress value between 0.0 and 1.0 (automatically clamped).
  mut value : Double
  /// The visual length of the progress bar in characters (excluding brackets).
  length : Int
  /// The horizontal offset from the left edge of the parent container.
  left : Int
  /// The vertical offset from the top edge of the parent container.
  top : Int
  /// Text displayed before the progress bar.
  mut prefix : String
  /// Text displayed after the progress bar.
  mut suffix : String
  /// How the progress value is displayed alongside the bar.
  mut mode : ShowMode
}

///|
/// Creates a new ProgressBar with specified parameters.
///
/// # Parameters
/// * `length`: The visual length of the bar in characters (excluding brackets)
/// * `value`: Initial progress value between 0.0 and 1.0 (default: 0.0, automatically clamped)
/// * `left`: Horizontal position offset (default: 0)
/// * `top`: Vertical position offset (default: 0)
/// * `prefix`: Text to display before the bar (default: "")
/// * `suffix`: Text to display after the bar (default: "")
/// * `mode`: Value display mode (default: Percentage)
///
/// # Returns
/// A new ProgressBar instance ready for rendering.
pub fn ProgressBar::new(
  length : Int,
  value? : Double = 0,
  left? : Int = 0,
  top? : Int = 0,
  prefix? : String = "",
  suffix? : String = "",
  mode? : ShowMode = Percentage,
) -> ProgressBar {
  let new_value = if value < 0.0 {
    0.0
  } else if value > 1.0 {
    1.0
  } else {
    value
  }
  ProgressBar::{ value: new_value, length, left, top, prefix, suffix, mode }
}

///|
/// Gets the formatted progress value string based on the current display mode.
///
/// # Parameters
/// * `self`: The ProgressBar instance
///
/// # Returns
/// Formatted value string according to the current ShowMode setting.
pub fn ProgressBar::value(self : ProgressBar) -> String {
  match self.mode {
    Percentage => "\{self.value * 100}%"
    Decimal => "\{self.value}"
    Null => ""
  }
}

///|
/// Sets the current progress value.
///
/// # Parameters
/// * `self`: The ProgressBar instance
/// * `value`: New progress value (automatically clamped to 0.0-1.0 range)
pub fn ProgressBar::set_value(self : ProgressBar, value : Double) -> Unit {
  let new_value = if value < 0 { 0.0 } else if value > 1 { 1.0 } else { value }
  self.value = new_value
}

///|
/// Sets the value display mode.
///
/// # Parameters
/// * `self`: The ProgressBar instance
/// * `mode`: New display mode for the progress value
///
/// # Examples
/// ```moonbit
/// let pb = ProgressBar::new(20, value=0.75)
/// pb.set_mode(ShowMode::Decimal)  // Now shows "0.75" instead of "75%"
/// ```
pub fn ProgressBar::set_mode(self : ProgressBar, mode : ShowMode) -> Unit {
  self.mode = mode
}

///|
/// Sets the prefix text displayed before the progress bar.
///
/// # Parameters
/// * `self`: The ProgressBar instance
/// * `prefix`: New prefix text
///
/// # Examples
/// ```moonbit
/// let pb = ProgressBar::new(20)
/// pb.set_prefix("Downloading:")  // Shows "Downloading:|[▇▇▇       ]"
/// ```
pub fn ProgressBar::set_prefix(self : ProgressBar, prefix : String) -> Unit {
  self.prefix = prefix
}

///|
/// Sets the suffix text displayed after the progress bar.
///
/// # Parameters
/// * `self`: The ProgressBar instance
/// * `suffix`: New suffix text
///
/// # Examples
/// ```moonbit
/// let pb = ProgressBar::new(20)
/// pb.set_suffix("complete")  // Shows "[▇▇▇       ]|complete"
/// ```
pub fn ProgressBar::set_suffix(self : ProgressBar, suffix : String) -> Unit {
  self.suffix = suffix
}

///|
/// Gets the total width of the progress bar widget.
///
/// Calculates the complete width including prefix, bar, value, and suffix
/// with appropriate spacing between components.
///
/// # Parameters
/// * `self`: The ProgressBar instance
///
/// # Returns
/// Total width in characters needed to display the entire progress bar.
///
/// # Calculation
/// - Prefix length (with space if present)
/// - Bar length (including brackets: length + 2)
/// - Value length (with space if shown)
/// - Suffix length (with space if present)
pub impl @base.Widget for ProgressBar with width(self : ProgressBar) -> Int {
  let value_len = self.value().length()
  let bar_len = self.length + 2
  let prefix_len = if self.prefix.is_empty() {
    0
  } else {
    self.prefix.length() + 1
  }
  let suffix_len = if self.suffix.is_empty() {
    0
  } else {
    self.suffix.length() + 1
  }
  let value_display_len = if self.mode == ShowMode::Null {
    0
  } else {
    value_len + 1
  }
  prefix_len + bar_len + suffix_len + value_display_len
}

///|
/// Gets the height of the progress bar widget.
///
/// Progress bars are single-line widgets.
///
/// # Parameters
/// * `self`: The ProgressBar instance
///
/// # Returns
/// Always returns 1, as progress bars occupy a single row.
pub impl @base.Widget for ProgressBar with height(self : ProgressBar) -> Int {
  ignore(self)
  1
}

///|
/// Generates the visual bar string with filled and empty segments.
///
/// This internal method creates the graphical representation of the progress
/// using filled blocks (▇) for completed portion and spaces for remaining portion.
///
/// # Parameters
/// * `self`: The ProgressBar instance
///
/// # Returns
/// A string containing the visual bar with brackets, e.g., "[▇▇▇   ]"
///
/// # Visual Representation
/// - Uses '▇' character for filled segments
/// - Uses space character for empty segments
/// - Wraps in square brackets
fn ProgressBar::draw_bar(self : ProgressBar) -> String {
  let filled_len = (self.value * self.length.to_double()).to_int()
  let empty_len = self.length - filled_len
  "[" + String::make(filled_len, '▇') + String::make(empty_len, ' ') + "]"
}

///|
/// Renders the complete progress bar within the provided frame.
///
/// Combines prefix, visual bar, value display, and suffix into a single
/// display string and renders it at the specified position.
///
/// # Parameters
/// * `self`: The ProgressBar instance
/// * `frame`: The Frame to render into
///
/// # Rendering Format
/// The components are joined with pipe characters for visual separation:
/// `[prefix] | [bar] | [value] | [suffix]`
pub impl @base.Widget for ProgressBar with render(
  self : ProgressBar,
  frame : @base.Frame,
) -> Unit {
  let subframe = frame.subframe(self.left, self.top, self.width(), 1)
  let bar = self.draw_bar()
  let components : Array[String] = []
  if !self.prefix.is_empty() {
    components.push(self.prefix)
  }
  components.push(bar)
  let value_str = self.value()
  if !value_str.is_empty() {
    components.push(value_str)
  }
  if !self.suffix.is_empty() {
    components.push(self.suffix)
  }
  let display = components.join("|")
  for i, ch in display.iter2() {
    subframe.set_chars(i, 0, ch)
  }
}
