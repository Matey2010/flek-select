# 📋 Changelog

## [0.4.0] - 2025-11-11

### 🎯 Type Safety Enhancement

- **Generic type parameters**: Added compile-time type safety with optional generic types
  - `SelectOption<T, P>` - Generic types for value (`T`) and params (`P`)
  - `Select<T, P>` - Type-safe select widget
  - `ToggleButtonGroup<T, P>` - Type-safe toggle button group
  - Both types default to `dynamic` when omitted for backwards compatibility

### ✨ Features

- **Type-safe values**: Eliminate runtime casting with compile-time type checking
  ```dart
  // Before: dynamic value, runtime casting needed
  SelectOption(text: 'Option', value: 42)
  onChange: (value) => handleChange(value as int)

  // After: compile-time type safety (optional)
  SelectOption<int, void>(text: 'Option', value: 42)
  onChange: (int? value) => handleChange(value!)
  ```

- **Type-safe params**: Pass strongly-typed metadata (e.g., notification counts)
  ```dart
  // Before: Map-based params
  SelectOption(text: 'Messages', value: 'msg', params: {'count': 5})

  // After: type-safe params
  SelectOption<String, int>(text: 'Messages', value: 'msg', params: 5)
  ```

- **Better IDE support**: Full autocomplete and type inference
- **Gradual migration**: Existing code works unchanged without type annotations

### 🔄 Backwards Compatibility

- **100% compatible**: All existing code works without modifications
- Type parameters are optional - omit them to use `dynamic` types
- No breaking changes to API surface

### 📝 Migration Guide

**Optional - Only if you want type safety:**

```dart
// Simple value typing
Select<String, dynamic>(
  options: [
    SelectOption<String, dynamic>(text: 'English', value: 'en'),
    SelectOption<String, dynamic>(text: 'Spanish', value: 'es'),
  ],
  value: currentLang,
  onChange: (String? value) => setLanguage(value),
)

// Typed params for metadata
SelectOption<String, int>(
  text: 'Notifications',
  value: 'notifications',
  params: unreadCount, // Strongly typed as int
)

// Without types (existing code - still works!)
SelectOption(text: 'Option', value: 'value')
```

## [0.3.0] - 2025-11-11

### 🚀 Major Changes

- **OverlayEntry-based popup system**: Completely rewritten Select widget to use Flutter's `OverlayEntry` API instead of `showDialog`
  - Fixes popup closing issues in complex widget hierarchies (e.g., SliverPersistentHeader)
  - Synchronous removal prevents Navigator stack conflicts
  - Uses `rootOverlay: true` to render above all navigation elements (header, bottom nav, etc.)
  - Centered modal container with max 80% screen height and 90% screen width
  - Scrollable content when options exceed available space

### ✨ Improved

- **Better backdrop behavior**:
  - Full-screen dark backdrop (87% opacity) that covers entire app including navigation
  - Uses `Tappable` widget for consistent touch feedback
  - `SizedBox.expand()` ensures complete screen coverage
- **Proper overlay lifecycle management**:
  - Overlay cleanup in `dispose()` prevents memory leaks
  - Prevents multiple overlays from opening simultaneously
  - Safe removal with mounted state checking

### 🗑️ Deprecated

- **`showOverlay` parameter**: Now deprecated as overlay behavior is built-in and optimized
  - Custom overlay integration is no longer needed for most use cases
  - Will be removed in future versions

### 🔧 Technical Details

- Popup now inserts at root overlay level using `Overlay.of(context, rootOverlay: true)`
- GlobalKey-based positioning system (prepared for future dropdown-style positioning)
- No longer dependent on Navigator for close behavior

### 📝 Breaking Changes

- While the API surface remains compatible, the internal behavior has changed significantly
- If you were relying on `showOverlay` parameter, you'll need to update your implementation
- Popup now always renders as centered modal instead of dialog

## [0.0.2] - 2025-11-10

### ✨ Added
- 🎛️ **ToggleButtonGroup Widget**: New row-based toggle button component for inline selection
  - Displays options as horizontal row of tappable buttons
  - Supports multiline wrapping with customizable spacing
  - Custom `buttonBuilder` for full design control
  - Rounded edges by default for beautiful appearance
  - Uses same `SelectOption` model as Select widget
  - **Scrollable mode**: New `scrollable` parameter enables horizontal scrolling for buttons
  - **Scroll controller support**: Optional `scrollController` parameter for programmatic scrolling
  - **Advanced scroll customization**:
    - `scrollPadding` for horizontal padding in scrollable mode
    - `scrollPhysics` for custom scroll behavior (bouncing, clamping, etc.)
    - `clipBehavior` for controlling how content is clipped in scroll view
  - **Dual alignment system**:
    - `wrapAlignment` and `wrapCrossAlignment` for Wrap mode (non-scrollable)
    - `scrollAlignment` and `scrollCrossAlignment` for scrollable mode
- 📚 Enhanced documentation with emojis and better organization
- 🌳 Tree-shakable export for ToggleButtonGroup widget
- 📖 Comprehensive usage examples for ToggleButtonGroup including scrollable mode with custom physics

### 🔄 Changed
- Updated README.md with fancy emojis throughout
- Improved API reference documentation structure
- **Breaking**: Renamed `alignment` parameter to `wrapAlignment` in ToggleButtonGroup for clarity between wrap and scroll modes
- **Breaking**: Renamed `crossAxisAlignment` parameter to `wrapCrossAlignment` in ToggleButtonGroup for consistency and clarity

## [0.0.1] - 2025-11-10

### Added
- Initial release of FlekSelect package
- `Select` widget with flexible overlay system
- `SelectOption` model for defining select options
- Support for custom overlay via `showOverlay` callback
- Tree-shakable exports for widgets and models
- Integration with Tappable package for responsive touch feedback
- Comprehensive customization options:
  - Labels, hints, and error messages
  - Disabled state support
  - Custom builders for options and values
  - "Not selected" option support
  - Custom styling via inputDecoration and backgroundColor

### Features
- Default overlay using Flutter's `showDialog`
- Custom overlay integration support for third-party packages
- Responsive touch feedback from Tappable package
- Full feature parity with dredge_ui Select widget
