# LunarTUI

LunarTUI 是一个 MoonBit 终端用户界面库。它提供终端渲染基础设施、布局算法、组件库，以及一套与具体终端事件后端解耦的事件协议，用于构建 native 终端应用。

English documentation is available in [README.md](README.md).

## 特性

- 基于双缓冲的终端渲染，并通过差异更新减少输出。
- 布局 trait，以及内置水平、垂直、网格和 flex 布局。
- 内置组件包括 `Label`、`Paragraph`、`Divider`、`Image`、`Container`、`Block` 和 `ProgressBar`。
- 支持 UTF-8 文本渲染和基础文本换行。
- 提供终端无关事件模型，可由任意兼容事件后端驱动。

## 安装

```bash
moon add FrozenLemonTee/LunarTUI
```

也可以在 `moon.mod` 中手动添加：

```moonbit
import {
  "FrozenLemonTee/LunarTUI@0.1.0",
}
```

LunarTUI 当前面向 MoonBit native 构建目标。

## 包结构

- `FrozenLemonTee/LunarTUI/src/base`：核心渲染类型、布局/组件 trait 和事件协议。
- `FrozenLemonTee/LunarTUI/src/layouts`：内置布局实现。
- `FrozenLemonTee/LunarTUI/src/widgets`：内置组件。
- `FrozenLemonTee/LunarTUI/src/terminal`：终端绘制、缓冲、光标辅助函数和 native 终端输出。

## 基础渲染示例

```moonbit
let title = @widgets.Label::new(
  "Welcome to LunarTUI",
  left=2,
  top=1,
)
let progress = @widgets.ProgressBar::new(
  20,
  value=0.75,
  left=2,
  top=3,
  prefix="Loading:",
  suffix="complete",
)
let container = @widgets.Container::new(
  0,
  0,
  80,
  24,
  layout=@layouts.VLayout::new(),
  children=[title, progress],
)
let terminal = @terminal.Terminal::new(@base.Area::new(80, 24))
@terminal.Terminal::clear()
terminal.draw(container)
@terminal.Terminal::newline()
```

## 事件模型

LunarTUI 在 `src/base/event.mbt` 中定义 UI 侧事件模型。该模型刻意保持终端无关：LunarTUI 不读取 stdin，不解析终端原始字节流，也不依赖任何具体事件后端。

核心事件类型包括：

| 类型 | 用途 |
| --- | --- |
| `EventKind` | 标识事件类别：键盘、鼠标、尺寸变化、焦点变化或文本输入。 |
| `Event` | 事件包装类型，承载一个具体事件载荷。 |
| `KeyEvent` | 键盘状态、键码、可选文本、修饰键和重复次数。 |
| `MouseEvent` | 鼠标状态、可选按钮、可选滚轮方向、坐标和修饰键。 |
| `ResizeEvent` | 终端宽度和高度。 |
| `FocusEvent` | 焦点获得或失去。 |
| `TextInputEvent` | 已提交的文本输入。 |
| `EventResult` | 组件处理结果：`Ignored`、`Handled` 或 `Redraw`。 |

可以使用构造函数创建协议值：

```moonbit
let key = @base.KeyEvent::new(
  @base.KeyState::Down,
  @base.KeyCode::Enter,
)
let event = @base.Event::key(key)
```

## 组件事件协议

`Widget` trait 除尺寸和渲染外，也包含事件处理入口：

```moonbit
pub(open) trait Widget {
  fn width(self : Self) -> Int
  fn height(self : Self) -> Int
  fn render(self : Self, frame : Frame) -> Unit
  fn handle_event(self : Self, event : Event) -> EventResult
}
```

推荐的应用层协议是：

1. 从外部事件源轮询或接收后端事件。
2. 将事件转换为 `@base.Event`。
3. 将事件路由到当前焦点组件或组件树。
4. 检查返回的 `EventResult`。
5. 仅在结果为 `Redraw` 时重新渲染。

`EventResult` 将“事件是否被消费”和“是否需要重绘”分开：

- `Ignored`：组件未处理事件，父级或兄弟路由可以继续。
- `Handled`：组件已处理事件，但不需要立即重绘。
- `Redraw`：组件已处理事件，应用层应重新渲染。

这样 LunarTUI 不会绑定特定事件循环、焦点管理器或终端后端。

## 默认事件后端

LunarTUI 自身不依赖事件后端。推荐的默认后端是 [LunarEvent](https://github.com/FrozenLemonTee/LunarEvent)，它提供由 TerminalEvent C FFI 支撑的 MoonBit 事件 API。

在 LunarTUI 应用中，可以使用 `FrozenLemonTee/LunarEvent/lunartui` 适配层。该适配层会把 LunarEvent 事件转换为 LunarTUI `@base.Event`，并提供用于轮询的 `EventSource`：

```moonbit
let source = @lunartui.EventSource::new()
match source.poll_event(32) {
  Some(event) => {
    match widget.handle_event(event) {
      @base.EventResult::Redraw => terminal.draw(widget)
      @base.EventResult::Handled => ()
      @base.EventResult::Ignored => ()
    }
  }
  None => ()
}
```

## Demo

查看 [TextEditor](https://github.com/FrozenLemonTee/TextEditor) 交互式示例。该示例组合了：

```text
TerminalEvent -> LunarEvent -> LunarEvent/lunartui -> LunarTUI -> application redraw loop
```

该 demo 验证了键盘输入、光标移动、重绘请求以及将文本保存到磁盘的路径。

## 开发

```bash
moon check --target native
moon test --target native
```

部分测试会输出终端控制序列。建议在能够接受备用屏幕、光标控制和 raw terminal 输出的终端环境中运行。

## 许可证

Apache-2.0。详见 [LICENSE](LICENSE)。