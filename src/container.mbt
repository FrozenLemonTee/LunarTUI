///|
pub struct Container {
  layout : &Layout?
  section : Section
  children : Array[&Widget]
}

///|
pub fn Container::new(
  layout? : &Layout,
  section : Section,
  children? : Array[&Widget] = [],
) -> Container {
  Container::{ layout, section, children }
}

///|
pub fn Container::add(self : Container, child : &Widget) -> Unit {
  self.children.push(child)
}

///|
pub fn Container::add_all(self : Container, children : Array[&Widget]) -> Unit {
  self.children.append(children)
}

///|
pub impl Widget for Container with width(self : Container) -> Int {
  match self.layout {
    Some(layout) => layout.width(self.section.area, self.children)
    None => self.section.area.width
  }
}

///|
pub impl Widget for Container with height(self : Container) -> Int {
  match self.layout {
    Some(layout) => layout.height(self.section.area, self.children)
    None => self.section.area.height
  }
}

///|
pub impl Widget for Container with render(self : Container, frame : Frame) -> Unit {
  if self.children.is_empty() {
    return
  }
  match self.layout {
    None =>
      for child in self.children {
        child.render(frame)
      }
    Some(layout) => {
      let area = self.section.area
      let sections = layout.split(area, self.children)
      for i, child in self.children.iter2() {
        let sec = sections[i]
        let subframe = frame.subframe(
          sec.left,
          sec.top,
          sec.area.width,
          sec.area.height,
        )
        child.render(subframe)
      }
    }
  }
}
