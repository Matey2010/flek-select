# 🎯 FlekSelect

A customizable Flutter select widget library with flexible overlay options and tree-shakable exports. Extracted from dredge_ui as part of a modular package restructuring.

## ✨ Features

- **📋 Select Widget**: Dropdown-style select with flexible overlay system
- **🎛️ ToggleButtonGroup**: Row-based toggle buttons for inline selection
- **🌳 Tree-Shakable**: Import only what you need
- **🎨 Highly Customizable**: Custom builders for input, buttons, and values
- **👆 Flexible Touch Handling**: Use any touch handler (GestureDetector, InkWell, Tappable, etc.)
- **⚙️ Rich Options**: Labels, hints, errors, disabled states, and more
- **🔒 Type-Safe**: Optional generic types for compile-time type checking

## 🔒 Type Safety (v0.4.0+)

FlekSelect supports optional generic type parameters for compile-time type safety:

```dart
// Type-safe with generics (optional)
SelectOption<String, int>(
  text: 'Messages',
  value: 'messages',
  params: 5, // Notification count - strongly typed as int
)

Select<int, dynamic>(
  options: [
    SelectOption<int, dynamic>(text: 'One', value: 1),
    SelectOption<int, dynamic>(text: 'Two', value: 2),
  ],
  value: selectedValue,
  onChange: (int? value) {
    // No casting needed - value is already int!
    setState(() => selectedValue = value);
  },
)

// Or use without types (backwards compatible)
SelectOption(text: 'Option', value: 'value')
```

**Benefits:**
- 🎯 Compile-time type checking
- 🚫 No runtime casting needed
- 💡 Better IDE autocomplete
- 📝 Self-documenting code
- ✅ Gradual migration - existing code works unchanged

## Installation

Add this to your package's `pubspec.yaml` file:

```yaml
dependencies:
  flek_select:
    path: ../flek_select
```

## 📖 Usage

### 📋 Select Widget

#### Basic Example

```dart
import 'package:flutter/material.dart';
import 'package:flek_select/select.dart';
import 'package:flek_select/select_option.dart';

class MyWidget extends StatefulWidget {
  @override
  _MyWidgetState createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  String? selectedValue;

  @override
  Widget build(BuildContext context) {
    return Select(
      options: [
        SelectOption(text: 'Option 1', value: '1'),
        SelectOption(text: 'Option 2', value: '2'),
        SelectOption(text: 'Option 3', value: '3'),
      ],
      value: selectedValue,
      onChange: (value) {
        setState(() {
          selectedValue = value;
        });
      },
    );
  }
}
```

### With Label and Error

```dart
Select(
  inputLabel: 'Choose an option',
  isRequired: true,
  error: isValid ? null : 'Please select an option',
  options: myOptions,
  value: selectedValue,
  onChange: (value) {
    setState(() {
      selectedValue = value;
    });
  },
)
```

### Custom Overlay (Deprecated)

> ⚠️ **Note**: The `showOverlay` parameter is deprecated as of version 0.3.0. The Select widget now uses an optimized OverlayEntry-based system that works reliably in all scenarios.

```dart
// This approach is deprecated and will be removed in future versions
Select(
  options: myOptions,
  value: selectedValue,
  onChange: (value) {
    setState(() {
      selectedValue = value;
    });
  },
  showOverlay: (context, dialogContent) async {
    // No longer needed - overlay behavior is built-in
    await showCustomOverlay(context, dialogContent);
  },
)
```

### Custom Builders

```dart
Select(
  options: myOptions,
  value: selectedValue,
  onChange: (value) => setState(() => selectedValue = value),
  optionBuilder: (context, option) {
    return Row(
      children: [
        Icon(Icons.star),
        SizedBox(width: 8),
        Text(option.text),
      ],
    );
  },
  valueBuilder: (context, option, isDisabled) {
    return Text(
      option?.text ?? 'Select...',
      style: TextStyle(
        color: isDisabled ? Colors.grey : Colors.black,
        fontWeight: FontWeight.bold,
      ),
    );
  },
)
```

### Custom Input Builder (v0.5.0+)

Build the entire input field with full control over styling and touch handling:

```dart
Select(
  options: myOptions,
  value: selectedValue,
  onChange: (value) => setState(() => selectedValue = value),
  inputBuilder: (context, selectedOption, isDisabled, onOpenSelectPopup) {
    return GestureDetector(
      onTap: isDisabled ? null : onOpenSelectPopup,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.blue.shade50,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.blue.shade200),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(selectedOption?.text ?? 'Select an option'),
            Icon(Icons.keyboard_arrow_down),
          ],
        ),
      ),
    );
  },
)
```

### Custom Backdrop Builder (v0.5.0+)

Customize the backdrop behind the popup:

```dart
Select(
  options: myOptions,
  value: selectedValue,
  onChange: (value) => setState(() => selectedValue = value),
  backdropBuilder: (context, onCloseSelectPopup) {
    return GestureDetector(
      onTap: onCloseSelectPopup,
      child: Container(color: Colors.black54),
    );
  },
)
```

#### With "Not Selected" Option

```dart
Select(
  options: myOptions,
  value: selectedValue,
  onChange: (value) => setState(() => selectedValue = value),
  showNotSelectedOption: true,
  notSelectedOptionText: 'None',
)
```

### 🎛️ ToggleButtonGroup Widget

A row-based toggle button group that displays options as a horizontal (or multiline) row of tappable buttons.

#### Basic Example

```dart
import 'package:flutter/material.dart';
import 'package:flek_select/toggle_button_group.dart';
import 'package:flek_select/select_option.dart';

class MyWidget extends StatefulWidget {
  @override
  _MyWidgetState createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  String selectedValue = 'option1';

  @override
  Widget build(BuildContext context) {
    return ToggleButtonGroup(
      options: [
        SelectOption(text: 'Option 1', value: 'option1'),
        SelectOption(text: 'Option 2', value: 'option2'),
        SelectOption(text: 'Option 3', value: 'option3'),
      ],
      value: selectedValue,
      onChange: (value) {
        setState(() {
          selectedValue = value;
        });
      },
    );
  }
}
```

#### Custom Button Builder (v0.5.0+)

The `buttonBuilder` now receives an `onSelect` callback that you must handle for the tap action:

```dart
ToggleButtonGroup(
  options: myOptions,
  value: selectedValue,
  onChange: (value) => setState(() => selectedValue = value),
  buttonBuilder: (context, option, isActive, onSelect) {
    return GestureDetector(
      onTap: onSelect,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          color: isActive ? Colors.purple : Colors.grey.shade200,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isActive ? Colors.purple : Colors.grey.shade300,
            width: 2,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.check_circle,
              size: 16,
              color: isActive ? Colors.white : Colors.grey,
            ),
            SizedBox(width: 8),
            Text(
              option.text,
              style: TextStyle(
                color: isActive ? Colors.white : Colors.black87,
                fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  },
)
```

#### With Custom Spacing

```dart
ToggleButtonGroup(
  options: myOptions,
  value: selectedValue,
  onChange: (value) => setState(() => selectedValue = value),
  spacing: 12.0,  // Horizontal spacing between buttons
  runSpacing: 12.0,  // Vertical spacing when wrapping to new line
  wrapAlignment: WrapAlignment.center,
)
```

#### Scrollable Mode

Use scrollable mode to create a horizontally scrollable row of buttons when you have many options or limited horizontal space.

```dart
ToggleButtonGroup(
  options: myOptions,
  value: selectedValue,
  onChange: (value) => setState(() => selectedValue = value),
  scrollable: true,
  scrollAlignment: MainAxisAlignment.start,
  scrollCrossAlignment: CrossAxisAlignment.center,
)
```

#### With Scroll Controller and Custom Physics

You can provide a scroll controller to programmatically scroll to specific items, along with custom scroll physics and padding:

```dart
final scrollController = ScrollController();

// ... later in your code
ToggleButtonGroup(
  options: myOptions,
  value: selectedValue,
  onChange: (value) => setState(() => selectedValue = value),
  scrollable: true,
  scrollController: scrollController,
  scrollPadding: EdgeInsets.symmetric(horizontal: 16),
  scrollPhysics: BouncingScrollPhysics(),
  clipBehavior: Clip.none,
)

// Scroll to a specific position
scrollController.animateTo(
  200,
  duration: Duration(milliseconds: 300),
  curve: Curves.easeInOut,
);
```

## 🔧 Implementation Details

### Overlay System (v0.3.0+)

The Select widget uses Flutter's native `OverlayEntry` API instead of `showDialog` for superior reliability and performance:

**Key Features:**

- **Root Overlay Insertion**: Uses `Overlay.of(context, rootOverlay: true)` to insert at the app's root level
- **Covers All UI**: Appears above navigation elements (headers, bottom navigation, etc.)
- **Synchronous Removal**: Uses `OverlayEntry.remove()` instead of `Navigator.pop()` to avoid timing conflicts
- **Complex Hierarchy Support**: Works reliably in SliverPersistentHeader and other advanced layouts
- **Centered Modal**: Displays as a centered container with 80% max height and 90% max width
- **Dark Backdrop**: Full-screen semi-transparent backdrop (87% opacity) with tap-to-close

**Technical Architecture:**

```dart
// Simplified internal implementation
void _showSelectOverlay() {
  _overlayEntry = OverlayEntry(
    builder: (context) => SizedBox.expand(
      child: Stack(
        children: [
          // Full-screen backdrop (customizable via backdropBuilder)
          Positioned.fill(
            child: GestureDetector(
              onTap: _closeOverlay,
              child: Container(color: Colors.black87),
            ),
          ),
          // Centered options modal
          Center(
            child: Material(
              child: /* options list */,
            ),
          ),
        ],
      ),
    ),
  );

  // Insert at root level
  Overlay.of(context, rootOverlay: true).insert(_overlayEntry!);
}
```

**Lifecycle Management:**

- Overlay is removed in `dispose()` to prevent memory leaks
- Prevents multiple overlays from opening simultaneously
- Safe state updates with mounted checks

**Why Not `showDialog`?**

- `showDialog` uses Navigator which can conflict with complex widget hierarchies
- Navigator-based dialogs may not close properly when parent widgets rebuild
- OverlayEntry provides direct, synchronous control over overlay lifecycle

## 📚 API Reference

### Select Widget

**Generic Parameters:**
- `T` - Type of the option value (defaults to `dynamic`)
- `P` - Type of the option params (defaults to `dynamic`)

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `options` | `List<SelectOption<T, P>>` | **required** | List of selectable options |
| `onChange` | `Function(T?)` | **required** | Callback when value changes |
| `value` | `T?` | `null` | Currently selected value |
| `inputLabel` | `String?` | `null` | Label displayed above the select |
| `isRequired` | `bool?` | `null` | Shows asterisk (*) next to label |
| `inputHint` | `String?` | `null` | Hint text displayed inside select |
| `dialogLabel` | `String?` | `null` | Title for the options dialog |
| `hint` | `String?` | `null` | Hint text displayed below select |
| `error` | `String?` | `null` | Error message displayed below select |
| `isDisabled` | `bool` | `false` | Disables the select |
| `showNotSelectedOption` | `bool` | `false` | Show a "not selected" option |
| `notSelectedOptionText` | `String` | `""` | Text for "not selected" option |
| `inputPadding` | `EdgeInsetsGeometry?` | `EdgeInsets.only(left: 12, right: 12)` | Padding inside select |
| `inputDecoration` | `BoxDecoration?` | `null` | Custom decoration for select |
| `backgroundColor` | `Color?` | `Colors.white10` | Background color |
| `optionBuilder` | `Widget Function(BuildContext, SelectOption<T, P>)?` | Default text builder | Custom builder for options |
| `valueBuilder` | `Widget Function(BuildContext, SelectOption<T, P>?, bool)?` | Default text builder | Custom builder for selected value |
| `inputBuilder` | `SelectInputBuilder<T, P>?` | `null` | **(v0.5.0+)** Custom builder for entire input field. Receives `(context, selectedOption, isDisabled, onOpenSelectPopup)` |
| `backdropBuilder` | `SelectBackdropBuilder?` | `null` | **(v0.5.0+)** Custom builder for backdrop. Receives `(context, onCloseSelectPopup)` |
| `showOverlay` | `Future<void> Function(BuildContext, Widget)?` | `null` | **Deprecated in v0.3.0**. Custom overlay handler (no longer needed - overlay system is now built-in) |

### ToggleButtonGroup Widget

**Generic Parameters:**
- `T` - Type of the option value (defaults to `dynamic`)
- `P` - Type of the option params (defaults to `dynamic`)

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `options` | `List<SelectOption<T, P>>` | **required** | List of selectable options |
| `value` | `T?` | **required** | Currently selected value |
| `onChange` | `Function(T?)` | **required** | Callback when value changes |
| `buttonBuilder` | `ToggleButtonBuilder<T, P>?` | Default rounded button | **(v0.5.0+)** Custom builder for each button. Receives `(context, option, isActive, onSelect)`. You must handle the tap via `onSelect` |
| `spacing` | `double` | `8.0` | Horizontal spacing between buttons |
| `runSpacing` | `double` | `8.0` | Vertical spacing when buttons wrap to new line (Wrap mode only) |
| `wrapAlignment` | `WrapAlignment` | `WrapAlignment.start` | Alignment of buttons in Wrap mode (when scrollable is false) |
| `wrapCrossAlignment` | `WrapCrossAlignment` | `WrapCrossAlignment.center` | Cross-axis alignment of buttons in Wrap mode |
| `isDisabled` | `bool` | `false` | Disables all buttons |
| `scrollable` | `bool` | `false` | Enable horizontal scrolling mode |
| `scrollController` | `ScrollController?` | `null` | Optional controller for programmatic scrolling |
| `scrollAlignment` | `MainAxisAlignment` | `MainAxisAlignment.start` | Horizontal alignment of buttons in scrollable mode |
| `scrollCrossAlignment` | `CrossAxisAlignment` | `CrossAxisAlignment.center` | Vertical alignment of buttons in scrollable mode |
| `scrollPadding` | `EdgeInsetsGeometry?` | `null` | Padding around the scrollable content in scrollable mode |
| `scrollPhysics` | `ScrollPhysics?` | `null` | Custom scroll physics for scrollable mode |
| `clipBehavior` | `Clip` | `Clip.hardEdge` | Clip behavior for the scroll view in scrollable mode |

### SelectOption Model

**Generic Parameters:**
- `T` - Type of the value (defaults to `dynamic`)
- `P` - Type of the params (defaults to `dynamic`)

| Property | Type | Description |
|----------|------|-------------|
| `text` | `String` | Display text for the option |
| `value` | `T` | Value associated with the option |
| `params` | `P?` | Optional additional metadata (can be any type, not just Map) |

## 🌳 Tree-Shaking

Import only what you need:

```dart
// Import only Select widget
import 'package:flek_select/select.dart';

// Import only ToggleButtonGroup widget
import 'package:flek_select/toggle_button_group.dart';

// Import only SelectOption model
import 'package:flek_select/select_option.dart';
```

This ensures unused code is not included in your app bundle.

## 📄 License

MIT License
