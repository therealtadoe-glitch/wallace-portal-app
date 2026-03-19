# Custom UI Pack (Godot 4.x)

A small "build-itself" UI component library aimed at **Windows desktop apps** with **mobile-friendly modularity**.

**Design goals**
- Each component is a single script that can be dropped onto an empty `Control` node (or instanced as a script class) and it will **create and own its children**.
- Desktop defaults (mouse/keyboard), but every component includes a simple hook to make it feel decent on touch devices.
- Components are **Theme-aware** and follow container-driven layouts.

## Install
Copy the folder `addons/custom_ui` into your Godot project.

## How to use
1. Create a `Control` (or any `Node`) in your scene.
2. Attach the component script (e.g. `ToastManager.gd`).
3. Call methods from your own UI logic.

A recommended pattern is to add a singleton "UI Root" scene and put:
- `ToastManager`
- `AppModalLayer`

…so any part of your app can show toasts / dialogs.

## Included components
- **Core**
  - `CustomUI.gd`: base class, child builder helpers, DPIscale helper, safe-area helper, input mode helper.
  - `AppModalLayer.gd`: a modal overlay layer for alerts, confirmations, sheets, etc.
  - `FocusTrap.gd`: keeps keyboard focus within a modal (desktop UX).

- **Components**
  - `ToastManager.gd`: toast notifications (stacking, timeout, actions).
  - `AlertCard.gd`: simple alert UI (title/body/buttons) for embedding.
  - `AppAlertDialog.gd`: modal alert/confirm/prompt built on `AppModalLayer`.
  - `BottomSheet.gd`: mobile-style bottom sheet with drag + snap.
  - `AppWindowPanel.gd`: a "fake window" panel (title bar, close, drag, resizable optional) useful inside a Godot app.
  - `DateTimePicker.gd`: date+time picker with calendar grid + spin boxes.
  - `SegmentedControl.gd`: iOS-style segmented toggle.
  - `InlineSearchBar.gd`: a search bar with clear button & debounced signal.
  - `Breadcrumbs.gd`: clickable breadcrumb trail.
  - `EmptyState.gd`: illustration slot + headline + body + primary/secondary actions.
  - `ShortcutHint.gd`: renders platform-ish shortcut hints (e.g. Ctrl+S).

## Demo
The `demo` folder includes a minimal scene you can open to see everything in action. It’s intentionally tiny.

## Notes
- These scripts favor clarity over cleverness.
- You can safely rename classes and paths to fit your project.
- For production, you’ll likely want to provide a Theme resource and set colors/fonts consistently.

Enjoy building weird little app UIs in a game engine. :)


## Live editor preview (@tool)
Most components are marked `@tool`, so changing exported properties in the Inspector updates their appearance in the editor.

## Style tokens
`core/UIStyleTokens.gd` is a small Resource you can assign to components that expose `tokens` to keep spacing/rounding/colors consistent.
