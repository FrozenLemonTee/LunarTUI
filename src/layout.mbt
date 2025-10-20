///|
pub struct Area {
  pos_x : Int
  pos_y : Int
  width : Int
  height : Int
} derive(Eq)

///|
pub fn Area::new(
  pos_x? : Int = 0,
  pos_y? : Int = 0,
  width : Int,
  height : Int,
) -> Area {
  Area::{ pos_x, pos_y, width, height }
}

///|
pub fn Area::size(self : Area) -> Int {
  self.width * self.height
}

///|
pub fn Area::pos(self : Area) -> (Int, Int) {
  (self.pos_x, self.pos_y)
}
