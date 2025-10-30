///|
/// A character-based image widget for displaying ASCII art or text-based graphics.
///
/// The Image widget renders a fixed grid of characters at a specified position,
/// supporting creation from arrays, text strings, or external files. Useful for
/// displaying ASCII art, diagrams, or any pre-formatted character-based graphics.
pub struct Image {
  /// The position and dimensions of the image within its parent container.
  section : @base.Section
  /// The character data stored in row-major order (width * height elements).
  contents : Array[Char]
}

///|
/// Creates a new Image from a character array with specified dimensions.
///
/// # Parameters
/// * `contents`: Array of characters in row-major order (must have width * height elements)
/// * `width`: The width of the image in characters
/// * `height`: The height of the image in character rows
/// * `left`: Horizontal position offset (default: 0)
/// * `top`: Vertical position offset (default: 0)
///
/// # Returns
/// A new Image instance with the specified character data.
///
/// # Aborts
/// If the contents array length does not match width * height.
pub fn Image::new(
  contents : Array[Char],
  width : Int,
  height : Int,
  left? : Int = 0,
  top? : Int = 0,
) -> Image {
  if contents.length() != width * height {
    abort(
      "Contents length (\{contents.length()}) does not match width * height (\{width * height}).",
    )
  }
  Image::{
    section: @base.Section::new(@base.Area::new(width, height), left, top),
    contents,
  }
}

///|
/// Creates a new Image by loading character data from a text file.
///
/// The file should contain ASCII art or text graphics, with each line representing
/// a row of the image. Lines are automatically padded with spaces to create a
/// rectangular grid.
///
/// # Parameters
/// * `path`: File system path to the text file containing the image data
/// * `left`: Horizontal position offset (default: 0)
/// * `top`: Vertical position offset (default: 0)
///
/// # Returns
/// A new Image instance loaded from the specified file.
///
/// # Aborts
/// - If the file path does not exist
/// - If an IO error occurs while reading the file
///
/// # File Format
/// - Each line becomes a row in the image
/// - Lines are padded with spaces to match the longest line
/// - Newline characters are used as row separators
pub fn Image::from_file(
  path : String,
  left? : Int = 0,
  top? : Int = 0,
) -> Image {
  let exist = @fs.path_exists(path)
  if !exist {
    abort("Path '\{path}' does not exist.")
  }
  try {
    let file_contents = @fs.read_file_to_string(path)
    let lines = file_contents.split("\n")
    let height = lines.count()
    let width = lines
      .map(fn(line) -> Int { line.length() })
      .fold(init=0, fn(max, cur) { @cmp.maximum(max, cur) })
    let contents : Array[Char] = []
    for line in lines.iter() {
      for ch in line.iter() {
        contents.push(ch)
      }
      let remain = width - line.length()
      for _ in 0..<remain {
        contents.push(' ')
      }
    }
    Image::{
      section: @base.Section::new(@base.Area::new(width, height), left, top),
      contents,
    }
  } catch {
    @fs.IOError(path) => abort("IOError raised when reading file '\{path}'.")
  }
}

///|
/// Creates a new Image from a multi-line text string.
///
/// Converts a string containing newlines into a character grid, automatically
/// determining dimensions and padding lines with spaces to create a rectangle.
///
/// # Parameters
/// * `text`: Multi-line string containing the image data
/// * `left`: Horizontal position offset (default: 0)
/// * `top`: Vertical position offset (default: 0)
///
/// # Returns
/// A new Image instance created from the text string.
///
/// # Processing
/// - Splits text on newline characters to determine rows
/// - Finds maximum line length to determine width
/// - Pads shorter lines with spaces to maintain rectangular shape
///
/// # Examples
/// ```moonbit
/// let ascii_art = " /\\\n/  \\\n\\  /\n \\/"
/// let img = Image::from_string(ascii_art, 2, 1)  // Creates a diamond shape
/// ```
pub fn Image::from_string(
  text : String,
  left? : Int = 0,
  top? : Int = 0,
) -> Image {
  let lines = text.split("\n")
  let height = lines.count()
  let width = lines
    .map(fn(line) -> Int { line.length() })
    .fold(init=0, fn(max, cur) { @cmp.maximum(max, cur) })
  let contents : Array[Char] = []
  for line in lines.iter() {
    for ch in line.iter() {
      contents.push(ch)
    }
    let remain = width - line.length()
    for _ in 0..<remain {
      contents.push(' ')
    }
  }
  Image::{
    section: @base.Section::new(@base.Area::new(width, height), left, top),
    contents,
  }
}

///|
/// Gets the width of the image in characters.
///
/// # Parameters
/// * `self`: The Image instance
///
/// # Returns
/// The width of the image in characters.
pub impl @base.Widget for Image with width(self : Image) -> Int {
  self.section.area.width
}

///|
/// Gets the height of the image in character rows.
///
/// # Parameters
/// * `self`: The Image instance
///
/// # Returns
/// The height of the image in character rows.
pub impl @base.Widget for Image with height(self : Image) -> Int {
  self.section.area.height
}

///|
/// Renders the character-based image within the provided frame.
///
/// Draws the image by placing each character from the contents array into
/// the corresponding position in the frame, using row-major order.
///
/// # Parameters
/// * `self`: The Image instance
/// * `frame`: The Frame to render into
///
/// # Rendering Process
/// 1. Creates a subframe for the image's section
/// 2. Iterates through rows (top to bottom)
/// 3. For each row, creates a line subframe
/// 4. Places characters left to right within each row
/// 5. Uses the exact character data from the contents array
///
/// # Performance
/// Efficiently renders the entire image by leveraging subframes and
/// direct character access without additional processing.
pub impl @base.Widget for Image with render(self : Image, frame : @base.Frame) -> Unit {
  let subframe = frame.subframe(
    self.section.left,
    self.section.top,
    self.section.area.width,
    self.section.area.height,
  )
  let mut idx = 0
  for i in 0..<self.section.area.height {
    let frame_line = subframe.subframe(0, i, self.section.area.width, 1)
    for j in 0..<self.section.area.width {
      frame_line.set_chars(j, 0, self.contents[idx])
      idx += 1
    }
  }
}
