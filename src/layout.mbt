///|
pub struct Area {
  width : Int
  height : Int
} derive(Eq)

///|
pub fn Area::new(
  width : Int,
  height : Int,
) -> Area {
  Area::{ width, height }
}

///|
pub fn Area::size(self : Area) -> Int {
  self.width * self.height
}

pub struct Section {
  area : Area
  x : Int
  y : Int
} derive(Eq)

pub fn Section::new(
  area : Area,
  x : Int,
  y : Int,
) -> Section {
  Section::{ area, x, y }
}