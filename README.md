# LunarTUI

LunarTUI is a MoonBit terminal user interface library. It provides rendering primitives, layout algorithms, widgets, and a terminal-agnostic event protocol for building native terminal applications.

Chinese documentation is available in [README.zh-CN.md](README.zh-CN.md).

## Features

- Double-buffered terminal rendering with diff updates.
- Layout traits and built-in horizontal, vertical, grid, and flex layouts.
- Widgets including `Label`, `Paragraph`, `Divider`, `Image`, `Container`, `Block`, and `ProgressBar`.
- UTF-8 text rendering and basic text wrapping support.
- A terminal-agnostic event model that can be driven by any compatible event backend.

## Installation

```bash
moon add FrozenLemonTee/LunarTUI
```

Or add it manually to `moon.mod`:

```moonbit
import {
  "FrozenLemonTee/LunarTUI@0.1.0",
}
```

LunarTUI currently targets MoonBit native builds.

## Packages

- `FrozenLemonTee/LunarTUI/src/base`: core rendering types, layout/widget traits, and event protocol.
- `FrozenLemonTee/LunarTUI/src/layouts`: built-in layout implementations.
- `FrozenLemonTee/LunarTUI/src/widgets`: built-in widgets.
- `FrozenLemonTee/LunarTUI/src/terminal`: terminal drawing, buffering, cursor helpers, and native terminal output.

## Basic Rendering Example

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

## Event Model

LunarTUI defines the UI-side event model in `src/base/event.mbt`. The model is deliberately terminal-agnostic: LunarTUI does not read stdin, parse terminal byte streams, or depend on a concrete event backend.

Core event types include:

| Type | Purpose |
| --- | --- |
| `EventKind` | Identifies the event category: key, mouse, resize, focus, or text input. |
| `Event` | Wrapper carrying exactly one event payload. |
| `KeyEvent` | Key state, key code, optional text, modifiers, and repeat count. |
| `MouseEvent` | Mouse state, optional button, optional scroll direction, position, and modifiers. |
| `ResizeEvent` | Terminal width and height. |
| `FocusEvent` | Focus gained or lost. |
| `TextInputEvent` | Committed text input. |
| `EventResult` | Widget response: `Ignored`, `Handled`, or `Redraw`. |

Event constructors are available for building protocol values:

```moonbit
let key = @base.KeyEvent::new(
  @base.KeyState::Down,
  @base.KeyCode::Enter,
)
let event = @base.Event::key(key)
```

## Widget Event Protocol

The `Widget` trait includes event handling alongside sizing and rendering:

```moonbit
pub(open) trait Widget {
  fn width(self : Self) -> Int
  fn height(self : Self) -> Int
  fn render(self : Self, frame : Frame) -> Unit
  fn handle_event(self : Self, event : Event) -> EventResult
}
```

The recommended application protocol is:

1. Poll or receive a backend event from an external event source.
2. Convert it into `@base.Event`.
3. Route it to the focused widget or component tree.
4. Inspect the returned `EventResult`.
5. Redraw only when the result is `Redraw`.

`EventResult` separates event consumption from rendering:

- `Ignored`: the widget did not handle the event; parent or sibling routing may continue.
- `Handled`: the widget handled the event, but no immediate redraw is required.
- `Redraw`: the widget handled the event and the application should render again.

This keeps LunarTUI independent from a specific event loop, focus manager, or terminal backend.

## Default Event Backend

LunarTUI does not depend on an event backend. The default recommended backend is [LunarEvent](https://github.com/FrozenLemonTee/LunarEvent), which provides a MoonBit event API backed by TerminalEvent's C FFI surface.

For LunarTUI applications, use the `FrozenLemonTee/LunarEvent/lunartui` adapter. It converts LunarEvent values into LunarTUI `@base.Event` values and exposes `EventSource` for polling:

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

See [TextEditor](https://github.com/FrozenLemonTee/TextEditor) for an interactive demo that combines:

```text
TerminalEvent -> LunarEvent -> LunarEvent/lunartui -> LunarTUI -> application redraw loop
```

The demo validates keyboard input, cursor movement, redraw requests, and saving text to disk.

## Development

```bash
moon check --target native
moon test --target native
```

Some tests render terminal control sequences. Run them in a terminal environment that can tolerate alternate screen, cursor, and raw terminal output.

## License

Apache-2.0. See [LICENSE](LICENSE).
