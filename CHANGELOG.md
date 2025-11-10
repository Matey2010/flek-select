# Changelog

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
