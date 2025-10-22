///|
pub(open) trait Layout {
  split(self : Self, area : Area, children : Array[&Widget]) -> Array[Section]
}
