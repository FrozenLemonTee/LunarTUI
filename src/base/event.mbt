///|
/// Terminal-agnostic input event model for LunarTUI.
///
/// This module defines the minimal event data structures that the TUI core can
/// understand without depending on any concrete terminal event backend.

///|
/// Describes the high-level category of an input event.
pub(all) enum EventKind {
  /// A keyboard event such as a key press, key release, or repeat.
  Key
  /// A mouse event such as move, click, drag, or scroll.
  Mouse
  /// A terminal resize event.
  Resize
  /// A focus state change event.
  Focus
  /// A text input event carrying committed text.
  TextInput
} derive(Eq)

///|
/// Describes the state of a key event.
pub(all) enum KeyState {
  Down
  Up
  Repeat
} derive(Eq)

///|
/// Describes a named key or a printable character key.
pub(all) enum KeyCode {
  Character
  Enter
  Esc
  Backspace
  Tab
  Space
  Left
  Right
  Up
  Down
  Home
  End
  PageUp
  PageDown
  Insert
  Delete
  F1
  F2
  F3
  F4
  F5
  F6
  F7
  F8
  F9
  F10
  F11
  F12
} derive(Eq)

///|
/// Describes a modifier key set attached to an input event.
pub(all) struct Modifiers {
  shift : Bool
  ctrl : Bool
  alt : Bool
  meta : Bool
} derive(Eq)

///|
/// Creates a modifier set with all modifiers disabled.
pub fn Modifiers::new() -> Modifiers {
  Modifiers::{ shift: false, ctrl: false, alt: false, meta: false }
}

///|
/// Describes a keyboard input event.
pub(all) struct KeyEvent {
  state : KeyState
  code : KeyCode
  text : String?
  modifiers : Modifiers
  repeat_count : Int
} derive(Eq)

///|
/// Describes a mouse button.
pub(all) enum MouseButton {
  Left
  Right
  Middle
  Back
  Forward
} derive(Eq)

///|
/// Describes the action carried by a mouse event.
pub(all) enum MouseState {
  Move
  Down
  Up
  Drag
  Scroll
} derive(Eq)

///|
/// Describes the direction of a mouse wheel scroll.
pub(all) enum ScrollDirection {
  Up
  Down
  Left
  Right
} derive(Eq)

///|
/// Describes a mouse input event.
pub(all) struct MouseEvent {
  state : MouseState
  button : MouseButton?
  scroll : ScrollDirection?
  x : Int
  y : Int
  modifiers : Modifiers
} derive(Eq)

///|
/// Describes a terminal resize event.
pub(all) struct ResizeEvent {
  width : Int
  height : Int
} derive(Eq)

///|
/// Describes a focus transition.
pub(all) enum FocusState {
  Gained
  Lost
} derive(Eq)

///|
/// Describes a focus change event.
pub(all) struct FocusEvent {
  state : FocusState
} derive(Eq)

///|
/// Describes committed text input.
pub(all) struct TextInputEvent {
  text : String
} derive(Eq)

///|
/// Describes the result of dispatching an event to a widget.
pub(all) enum EventResult {
  /// The event was not handled.
  Ignored
  /// The event was handled and no immediate redraw is required.
  Handled
  /// The event was handled and the caller should redraw.
  Redraw
} derive(Eq)

///|
/// A terminal-agnostic input event.
///
/// The `kind` field identifies the event category. The corresponding payload
/// field is populated according to that category, and the other payload fields
/// remain unset.
pub(all) struct Event {
  kind : EventKind
  key : KeyEvent?
  mouse : MouseEvent?
  resize : ResizeEvent?
  focus : FocusEvent?
  text_input : TextInputEvent?
} derive(Eq)

///|
/// Creates a keyboard event wrapper.
pub fn Event::key(key : KeyEvent) -> Event {
  Event::{
    kind: EventKind::Key,
    key: Some(key),
    mouse: None,
    resize: None,
    focus: None,
    text_input: None,
  }
}

///|
/// Creates a mouse event wrapper.
pub fn Event::mouse(mouse : MouseEvent) -> Event {
  Event::{
    kind: EventKind::Mouse,
    key: None,
    mouse: Some(mouse),
    resize: None,
    focus: None,
    text_input: None,
  }
}

///|
/// Creates a resize event wrapper.
pub fn Event::resize(resize : ResizeEvent) -> Event {
  Event::{
    kind: EventKind::Resize,
    key: None,
    mouse: None,
    resize: Some(resize),
    focus: None,
    text_input: None,
  }
}

///|
/// Creates a focus event wrapper.
pub fn Event::focus(focus : FocusEvent) -> Event {
  Event::{
    kind: EventKind::Focus,
    key: None,
    mouse: None,
    resize: None,
    focus: Some(focus),
    text_input: None,
  }
}

///|
/// Creates a text input event wrapper.
pub fn Event::text_input(text_input : TextInputEvent) -> Event {
  Event::{
    kind: EventKind::TextInput,
    key: None,
    mouse: None,
    resize: None,
    focus: None,
    text_input: Some(text_input),
  }
}