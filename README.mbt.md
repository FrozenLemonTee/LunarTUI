# LunarTUI Framework

一个基于 **MoonBit** 语言开发的终端用户界面（TUI）框架，提供丰富的组件和灵活的布局系统，用于构建美观的终端应用程序。

---

## 🌟 特性

### 🎯 核心功能
- **双缓冲渲染**：消除屏幕闪烁，提供流畅的视觉体验  
- **灵活的布局系统**：支持水平、垂直、网格和 Flexbox 布局  
- **丰富的组件库**：标签、段落、进度条、分割线、图像、容器等  
- **Unicode 支持**：完整的 UTF-8 字符渲染支持  
- **自动换行**：智能文本换行和对齐功能  

### 🎨 组件系统
- **基础组件**：`Label`、`Paragraph`、`Divider`、`Image`  
- **容器组件**：`Container`、`Block`（带边框的块容器）  
- **进度指示器**：`ProgressBar`（支持多种显示模式）  
- **布局管理器**：`HLayout`、`VLayout`、`GridLayout`、`FlexLayout`  

### ⚡ 性能优化
- **差异渲染**：只更新变化的屏幕区域  
- **高效重绘**：最小化终端输出操作  
- **内存优化**：紧凑的数据结构和智能缓存  

---

## 🚀 快速开始

### 安装依赖
确保已安装 MoonBit 开发环境，在项目文件夹执行以下命令：

```bash
moon add FrozenLemonTee/LunarTUI
```

然后在 `moon.mod.json` 文件中添加依赖：

```json
"deps": {
    "FrozenLemonTee/LunarTUI": "0.0.1",
}
```

### 基础示例

```moonbit
///|
test {
  // 创建组件
  let title = @widgets.Label::new("Welcome to the LunarTUI framework", left=2, top=1)
  let progress = @widgets.ProgressBar::new(
    20,
    value=0.75,
    left=2,
    top=3,
    prefix="Loading progress:",
    suffix="Complete",
  )

  // 创建带布局的容器
  let container = @widgets.Container::new(
    0,
    0,
    80,
    24,
    layout=@layouts.VLayout::new(),
    children=[title, progress],
  )

  // 创建终端实例
  let terminal = @terminal.Terminal::new(@base.Area::new(80, 24))

  // 渲染界面
  @terminal.Terminal::clear()
  terminal.draw(container)
  @terminal.Terminal::newline()
}
```

---

## 🧩 核心概念

### 布局系统

#### 水平布局（HLayout）
```moonbit
///|
test {
  let layout = @layouts.HLayout::new()
  let labels : Array[&@base.Widget] = []
  for i in 0..<3 {
    labels.push(@widgets.Label::new("Label\{i}"))
  }
  let container = @widgets.Container::new(
    0,
    0,
    60,
    10,
    layout~,
    children=labels,
  )
  let terminal = @terminal.Terminal::new(@base.Area::new(80, 24))
  @terminal.Terminal::clear()
  terminal.draw(container)
  @terminal.Terminal::newline()
}
```

#### 垂直布局（VLayout）
```moonbit
///|
test {
  let layout = @layouts.VLayout::new()
  let labels : Array[&@base.Widget] = []
  for i in 0..<3 {
    labels.push(@widgets.Label::new("Label\{i}"))
  }
  let container = @widgets.Container::new(
    0,
    0,
    60,
    10,
    layout~,
    children=labels,
  )
  let terminal = @terminal.Terminal::new(@base.Area::new(80, 24))
  @terminal.Terminal::clear()
  terminal.draw(container)
  @terminal.Terminal::newline()
}
```

#### 网格布局（GridLayout）
```moonbit
///|
test {
  let layout = @layouts.GridLayout::new(2, 3) // 2行3列
  let labels : Array[&@base.Widget] = []
  for i in 0..<6 {
    labels.push(@widgets.Label::new("Label\{i}"))
  }
  let container = @widgets.Container::new(
    0,
    0,
    60,
    10,
    layout~,
    children=labels,
  )
  let terminal = @terminal.Terminal::new(@base.Area::new(80, 24))
  @terminal.Terminal::clear()
  terminal.draw(container)
  @terminal.Terminal::newline()
}
```

#### 弹性布局（FlexLayout）
```moonbit
///|
test {
  let layout = @layouts.FlexLayout::new(
    direction=Row,
    justify=SpaceBetween,
    align=Center,
  )
  let labels : Array[&@base.Widget] = []
  for i in 0..<3 {
    labels.push(@widgets.Label::new("Label\{i}"))
  }
  let container = @widgets.Container::new(
    0,
    0,
    60,
    10,
    layout~,
    children=labels,
  )
  let terminal = @terminal.Terminal::new(@base.Area::new(80, 24))
  @terminal.Terminal::clear()
  terminal.draw(container)
  @terminal.Terminal::newline()
}
```

---

## 🧱 组件使用

### 标签（Label）
```moonbit
///|
test {
  let label = @widgets.Label::new("Hello World", left=5, top=3)
  let terminal = @terminal.Terminal::new(@base.Area::new(80, 24))
  @terminal.Terminal::clear()
  terminal.draw(label)
  @terminal.Terminal::newline()
}
```

### 段落（Paragraph）
```moonbit
///|
test {
  let text = "This is a multi-line text paragraph that supports automatic line breaks and alignment features."
  let para = @widgets.Paragraph::new(2, 2, 40, 5, text, align=Center)
  let terminal = @terminal.Terminal::new(@base.Area::new(80, 24))
  @terminal.Terminal::clear()
  terminal.draw(para)
  @terminal.Terminal::newline()
}
```

### 进度条（ProgressBar）
```moonbit
///|
test {
  let progress = @widgets.ProgressBar::new(
    25,
    value=0.65,
    left=5,
    top=5,
    prefix="Processing:",
    mode=Percentage,
  )
  progress.set_value(0.8) // 更新进度
  let terminal = @terminal.Terminal::new(@base.Area::new(80, 24))
  @terminal.Terminal::clear()
  terminal.draw(progress)
  @terminal.Terminal::newline()
}
```

### 分割线（Divider）
```moonbit
///|
test {
  let area = @base.Area::new(50, 50)
  // 水平分割线
  let hdiv = @widgets.Divider::new(
    30,
    left=5,
    top=2,
    line='=',
    edge='+',
    direction=Row,
  )
  // 垂直分割线  
  let vdiv = @widgets.Divider::new(
    10,
    left=15,
    top=0,
    line='|',
    edge='+',
    direction=Column,
  )
  let container = @widgets.Container::new(
    0,
    0,
    area.width,
    area.height,
    layout=@layouts.VLayout::new(),
  )
  container.add(hdiv)
  container.add(vdiv)
  let ter = @terminal.Terminal::new(area)
  @terminal.Terminal::clear()
  ter.draw(container)
  @terminal.Terminal::newline()
}
```

### 图像（Image）
```moonbit
///|
test {  
  let area = @base.Area::new(100, 50)
  // 从字符串创建
  let ascii_art = " /\\\n/  \\\n\\  /\n \\/"
  let image1 = @widgets.Image::from_string(ascii_art, left=10, top=2)
  let container = @widgets.Container::new(
    0,
    0,
    area.width,
    area.height,
    layout=@layouts.VLayout::new(),
  )
  container.add(image1)
  // 从文件加载
  let cwd = @env.current_dir()
  match cwd {
    None => ()
    Some(cwd) => {
      let file_name = "test/ascii_pic.txt"
      let file_dir = @path.Path::new(cwd)
      file_dir.push(file_name)
      let image2 = @widgets.Image::from_file(file_dir.to_string())
      container.add(image2)
    }
  }
  let ter = @terminal.Terminal::new(area)
  @terminal.Terminal::clear()
  ter.draw(container)
  @terminal.Terminal::newline()
}
```

### 块容器（Block）
```moonbit
///|
test {
  let area = @base.Area::new(30, 12)
  let block = @widgets.Block::new(
    0,
    0,
    area.width,
    area.height,
    title="Control Panel",
    layout=@layouts.VLayout::new(),
  )
  let l1 = @widgets.Label::new("l1")
  let d1 = @widgets.Divider::new(10)
  let l2 = @widgets.Label::new("l2")
  block.add(l1)
  block.add(d1)
  block.add(l2)
  let ter = @terminal.Terminal::new(area)
  @terminal.Terminal::clear()
  ter.draw(block)
  @terminal.Terminal::newline()
}
```

---

## 🧠 高级特性

### 自定义组件
实现 `Widget` trait 来创建自定义组件：

```moonbit
///|
pub struct CustomWidget {
  // 组件状态
}

///|
pub impl @base.Widget for CustomWidget with width(self : CustomWidget) -> Int {
  // 返回宽度
  ...
}

///|
pub impl @base.Widget for CustomWidget with height(self : CustomWidget) -> Int {
  // 返回高度
  ...
}

///|
pub impl @base.Widget for CustomWidget with render(
  self : CustomWidget,
  frame : @base.Frame,
) -> Unit {
  // 渲染逻辑
  ...
}
```

### 自定义布局
实现 `Layout` trait 来创建自定义布局：

```moonbit
///|
pub struct CustomLayout {}

///|
pub impl @base.Layout for CustomLayout with split(
  self : CustomLayout,
  area : @base.Area,
  children : Array[&@base.Widget],
) -> Array[@base.Section] {
  // 布局算法
  ...
}

///|
pub impl @base.Layout for CustomLayout with width(
  self : CustomLayout,
  area : @base.Area,
  children : Array[&@base.Widget],
) -> Int {
  ...
}

///|
pub impl @base.Layout for CustomLayout with height(
  self : CustomLayout,
  area : @base.Area,
  children : Array[&@base.Widget],
) -> Int {
  ...
}
```

---

## 📘 API 文档

### 核心类型
| 类型 | 说明 |
|------|------|
| `Terminal` | 终端渲染引擎，管理双缓冲和差异更新 |
| `Buffer` | 字符缓冲区，存储终端内容状态 |
| `Frame` | 渲染视图，提供坐标转换和裁剪 |
| `Area` | 二维区域定义 |
| `Section` | 带位置的区域定义 |

### Widget Trait
```moonbit
pub(open) trait Widget {
  width(self : Self) -> Int
  height(self : Self) -> Int  
  render(self : Self, frame : @base.Frame) -> Unit
}
```

### Layout Trait
```moonbit
pub(open) trait Layout {
  split(self : Self, area : @base.Area, children : Array[&Widget]) -> Array[@base.Section]
  width(self : Self, area : @base.Area, children : Array[&Widget]) -> Int
  height(self : Self, area : @base.Area, children : Array[&Widget]) -> Int
}
```

---

## 🤝 贡献指南

1. Fork 本项目  
2. 创建特性分支  
   ```bash
   git checkout -b feature/AmazingFeature
   ```
3. 提交更改  
   ```bash
   git commit -m 'Add some AmazingFeature'
   ```
4. 推送到分支  
   ```bash
   git push origin feature/AmazingFeature
   ```
5. 开启 Pull Request  

---

## 📄 许可证
本项目采用 **Apache License Version 2.0**，详情请参阅 `LICENSE` 文件。

---

## ❤️ 致谢
- 感谢 **MoonBit 团队** 提供的优秀编程语言  
- 感谢 **MoonBit Community** 对本项目的支持
- 受 **ratatui** 启发  

**Enjoy Coding! 🎉**

如有问题或建议，请开启 Issue 或参与讨论。
