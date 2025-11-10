# 📋 Changelog

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
