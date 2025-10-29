///|
pub struct Image {
  section : @base.Section
  contents : Array[Char]
}

///|
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
pub impl @base.Widget for Image with width(self : Image) -> Int {
  self.section.area.width
}

///|
pub impl @base.Widget for Image with height(self : Image) -> Int {
  self.section.area.height
}

///|
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
