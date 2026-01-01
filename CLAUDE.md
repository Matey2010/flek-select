# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

**flek_select** is a Flutter package providing customizable select widgets with two main components:
- **Select**: Dropdown-style select with OverlayEntry-based popup
- **ToggleButtonGroup**: Row-based toggle buttons for inline selection

The package emphasizes tree-shakability, type safety (optional generics), and a reliable overlay system.

## Development Commands

### Running Tests
```bash
flutter test
```

### Analyzing Code
```bash
flutter analyze
```

### Running Lints
```bash
flutter pub run flutter_lints
```

### Publishing (Dry Run)
```bash
flutter pub publish --dry-run
```

## Code Architecture

### Package Structure

The package follows a tree-shakable export pattern:

```
lib/
├── select.dart              # Export file for Select widget
├── toggle_button_group.dart # Export file for ToggleButtonGroup
├── select_option.dart       # Export file for SelectOption model
└── src/
    ├── select.dart          # Select implementation
    ├── toggle_button_group.dart # ToggleButtonGroup implementation
    └── select_option.dart   # SelectOption model
```

**Import Pattern**: Users import from top-level files (e.g., `package:flek_select/select.dart`) which enables tree-shaking of unused components.

### Generic Type System

Both widgets support optional generic parameters for compile-time type safety:
- `T`: Type of the option value (defaults to `dynamic`)
- `P`: Type of the option params (defaults to `dynamic`)

Example:
```dart
SelectOption<String, int>(text: 'Messages', value: 'msg', params: 5)
Select<String, int>(options: [...], onChange: (String? value) => {...})
```

**Backward Compatibility**: Omitting type parameters defaults to `dynamic`, so all existing code works unchanged.

### Overlay System (Select Widget)

The Select widget uses Flutter's `OverlayEntry` API instead of `showDialog`. This was a major architectural change in v0.3.0.

**Key Implementation Details**:
- Uses `Overlay.of(context, rootOverlay: true)` to insert at app root level
- Overlay is stored in `_overlayEntry` field and managed in widget state
- Removal is synchronous via `_overlayEntry?.remove()` (not Navigator-based)
- Overlay is cleaned up in `dispose()` to prevent memory leaks
- GlobalKey `_selectKey` is stored for potential future dropdown positioning

**Why OverlayEntry vs showDialog?**
- showDialog uses Navigator which conflicts with complex widget hierarchies
- Navigator-based dialogs don't close reliably when parent widgets rebuild (e.g., in SliverPersistentHeader)
- OverlayEntry provides direct, synchronous control over overlay lifecycle

**Current Popup Style**: Centered modal with:
- Full-screen backdrop (87% opacity, tap-to-close)
- Centered Material container
- Max 80% screen height, 90% screen width
- Scrollable when options exceed available space

### Component Patterns

**Select Widget** ([lib/src/select.dart](lib/src/select.dart)):
- StatefulWidget with overlay state management
- Custom builders for options (`optionBuilder`) and selected value (`valueBuilder`)
- **v0.5.0+**: `inputBuilder` for full input field customization with `onOpenSelectPopup` callback
- **v0.5.0+**: `backdropBuilder` for backdrop customization with `onCloseSelectPopup` callback
- Support for labels, hints, errors, disabled states
- Optional "not selected" option
- Deprecated `showOverlay` parameter (will be removed)

**ToggleButtonGroup Widget** ([lib/src/toggle_button_group.dart](lib/src/toggle_button_group.dart)):
- StatelessWidget (simpler than Select)
- Two layout modes: Wrap (default) or SingleChildScrollView (when `scrollable: true`)
- **v0.5.0+**: `buttonBuilder` signature includes `onSelect` callback - user is responsible for handling tap
- Scroll controller support for programmatic scrolling

**SelectOption Model** ([lib/src/select_option.dart](lib/src/select_option.dart)):
- Simple data class with `text`, `value`, and optional `params`
- Generic types: `SelectOption<T, P>`
- Used by both Select and ToggleButtonGroup

### Touch Interaction (v0.5.0+)

As of v0.5.0, the package no longer depends on `tappable`. Touch interaction is now handled via:

1. **Default behavior**: Uses `GestureDetector` with `HitTestBehavior.opaque` (no visual feedback)
2. **Custom builders**: Users can provide their own touch handlers via:
   - `inputBuilder` / `backdropBuilder` for Select
   - `buttonBuilder` for ToggleButtonGroup

Users who want `tappable` or other touch feedback can add it as their own dependency and use it in their custom builders.

**Example with Tappable:**
```dart
Select(
  inputBuilder: (context, selectedOption, isDisabled, onOpenSelectPopup) {
    return Tappable(
      onTap: isDisabled ? null : onOpenSelectPopup,
      child: MyInputWidget(selectedOption),
    );
  },
)
```

## Development Notes

### When Modifying Overlay Behavior

1. Always test in complex widget hierarchies (e.g., inside SliverPersistentHeader, nested navigation)
2. Ensure overlay is removed in `dispose()` to prevent memory leaks
3. Check that `mounted` state before calling `setState` after async operations
4. Verify overlay doesn't block navigation or other overlays

### Type Safety Migration

When adding features that use SelectOption:
- Use generic type parameters for new APIs: `SelectOption<T, P>`
- Default to `<dynamic, dynamic>` when types aren't critical
- Maintain backward compatibility by not requiring type annotations

### Future Architecture Plans (from TODO.md)

1. **Custom Popup Builder**: Allow users to customize popup appearance while keeping overlay logic intact (partially implemented via `inputBuilder`/`backdropBuilder` in v0.5.0)
2. **Alternative Overlay Strategies**: Support for apps with existing overlay management systems

## Important Deprecations

- `showOverlay` parameter in Select widget is deprecated as of v0.3.0
- Will be removed in a future version
- Custom overlay behavior should eventually be handled via popup builder pattern (not yet implemented)

## Testing Strategy

Currently no tests exist in the repository. When adding tests:
- Focus on overlay lifecycle management (open, close, dispose)
- Test type safety with various generic type combinations
- Test edge cases: rapid open/close, parent widget rebuilds, navigation during open overlay
- Test both Select and ToggleButtonGroup with custom builders
