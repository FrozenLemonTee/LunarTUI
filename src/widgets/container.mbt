///|
pub struct Container {
  layout : &@base.Layout?
  section : @base.Section
  children : Array[&@base.Widget]
}

///|
pub fn Container::new(
  left : Int,
  top : Int,
  width : Int,
  height : Int,
  layout? : &@base.Layout,
  children? : Array[&@base.Widget] = []
) -> Container {
  let section = @base.Section::new(@base.Area::new(width, height), left, top)
  Container::fromSection(layout?, section, children=children)
}

///|
pub fn Container::fromSection(
  layout? : &@base.Layout,
  section : @base.Section,
  children? : Array[&@base.Widget] = [],
) -> Container {
  Container::{ layout, section, children }
}

///|
pub fn Container::add(self : Container, child : &@base.Widget) -> Unit {
  self.children.push(child)
}

///|
pub fn Container::add_all(
  self : Container,
  children : Array[&@base.Widget],
) -> Unit {
  self.children.append(children)
}

///|
pub impl @base.Widget for Container with width(self : Container) -> Int {
  match self.layout {
    Some(layout) => layout.width(self.section.area, self.children)
    None => self.section.area.width
  }
}

///|
pub impl @base.Widget for Container with height(self : Container) -> Int {
  match self.layout {
    Some(layout) => layout.height(self.section.area, self.children)
    None => self.section.area.height
  }
}

///|
pub impl @base.Widget for Container with render(
  self : Container,
  frame : @base.Frame,
) -> Unit {
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
