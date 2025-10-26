///|
pub(open) trait Layout {
  split(self : Self, area : Area, children : Array[&Widget]) -> Array[Section]
  width(self : Self, area : Area, children : Array[&Widget]) -> Int
  height(self : Self, area : Area, children : Array[&Widget]) -> Int
}
