///|
pub struct Area {
  width : Int
  height : Int
} derive(Eq)

///|
pub fn Area::new(width : Int, height : Int) -> Area {
  Area::{ width: @cmp.maximum(0, width), height: @cmp.maximum(0, height) }
}

///|
pub fn Area::size(self : Area) -> Int {
  self.width * self.height
}

///|
pub struct Section {
  area : Area
  left : Int
  top : Int
} derive(Eq)

///|
pub fn Section::new(area : Area, left : Int, top : Int) -> Section {
  Section::{ area, left: @cmp.maximum(0, left), top: @cmp.maximum(0, top) }
}
