pub struct Area {
  pos_x : Int
  pos_y : Int
  height : Int
  width : Int
} derive(Default, Eq)

pub fn Area::new(
  pos_x? : Int = 0,
  pos_y? : Int = 0,
  height : Int,
  width : Int,
) -> Area {
  Area::{ pos_x, pos_y, height, width }
}
