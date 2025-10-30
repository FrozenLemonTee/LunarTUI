///|
pub(all) enum ShowMode {
  Percentage
  Decimal
  Null
} derive(Eq)

///|
pub struct ProgressBar {
  mut value : Double
  length : Int
  left : Int
  top : Int
  mut prefix : String
  mut suffix : String
  mut mode : ShowMode
}

///|
pub fn ProgressBar::new(
  length : Int,
  value? : Double = 0,
  left? : Int = 0,
  top? : Int = 0,
  prefix? : String = "",
  suffix? : String = "",
  mode? : ShowMode = Percentage,
) -> ProgressBar {
  let new_value = if value < 0.0 { 0.0 } else if value > 1.0 { 1.0 } else { value }
  ProgressBar::{ value: new_value, length, left, top, prefix, suffix, mode }
}

///|
pub fn ProgressBar::value(self : ProgressBar) -> String {
  match self.mode {
    Percentage => "\{self.value * 100}%"
    Decimal => "\{self.value}"
    Null => ""
  }
}

///|
pub fn ProgressBar::set_value(self : ProgressBar, value : Double) -> Unit {
  let new_value = if value < 0 { 0.0 } else if value > 1 { 1.0 } else { value }
  self.value = new_value
}

///|
pub fn ProgressBar::set_mode(self : ProgressBar, mode : ShowMode) -> Unit {
  self.mode = mode
}

///|
pub fn ProgressBar::set_prefix(self : ProgressBar, prefix : String) -> Unit {
  self.prefix = prefix
}

///|
pub fn ProgressBar::set_suffix(self : ProgressBar, suffix : String) -> Unit {
  self.suffix = suffix
}

///|
pub impl @base.Widget for ProgressBar with width(self : ProgressBar) -> Int {
  let bar_len = self.value().length() + 2 + self.length
  let value_len = if self.mode == ShowMode::Null {
    0
  } else {
    self.value().length() + 1
  }
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
  bar_len + prefix_len + suffix_len + value_len
}

///|
pub impl @base.Widget for ProgressBar with height(self : ProgressBar) -> Int {
  ignore(self)
  1
}

///|
fn ProgressBar::draw_bar(self : ProgressBar) -> String {
  let filled_len = (self.value * self.length.to_double()).to_int()
  let empty_len = self.length - filled_len
  "[" + String::make(filled_len, '▇') + String::make(empty_len, ' ') + "]"
}

///|
pub impl @base.Widget for ProgressBar with render(
  self : ProgressBar,
  frame : @base.Frame,
) -> Unit {
  let subframe = frame.subframe(self.left, self.top, self.width(), 1)
  let bar = self.draw_bar()
  let components : Array[String] = []
  if !self.prefix.is_empty() {
    parts.push(self.prefix)
  }
  parts.push(bar)
  let value_str = self.value()
  if !value_str.is_empty() {
    parts.push(value_str)
  }
  if !self.suffix.is_empty() {
    parts.push(self.suffix)
  }
  let display = parts.join("|")
  for i, ch in display.iter2() {
    subframe.set_chars(i, 0, ch)
  }
}
