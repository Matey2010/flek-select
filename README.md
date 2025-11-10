# 🎯 FlekSelect

A customizable Flutter select widget library with flexible overlay options and tree-shakable exports. Extracted from dredge_ui as part of a modular package restructuring.

## ✨ Features

- **📋 Select Widget**: Dropdown-style select with flexible overlay system
- **🎛️ ToggleButtonGroup**: Row-based toggle buttons for inline selection
- **🌳 Tree-Shakable**: Import only what you need
- **🎨 Highly Customizable**: Custom builders for options and values
- **👆 Responsive Touch**: Uses Tappable package for better touch feedback
- **⚙️ Rich Options**: Labels, hints, errors, disabled states, and more

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

### Custom Overlay (Using a different overlay package)

```dart
Select(
  options: myOptions,
  value: selectedValue,
  onChange: (value) {
    setState(() {
      selectedValue = value;
    });
  },
  showOverlay: (context, dialogContent) async {
    // Use your own overlay package here
    // For example, using a custom positioned overlay:
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

#### Custom Button Builder

```dart
ToggleButtonGroup(
  options: myOptions,
  value: selectedValue,
  onChange: (value) => setState(() => selectedValue = value),
  buttonBuilder: (context, option, isActive) {
    return Container(
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

## 📚 API Reference

### Select Widget

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `options` | `List<SelectOption>` | **required** | List of selectable options |
| `onChange` | `Function(dynamic)` | **required** | Callback when value changes |
| `value` | `dynamic` | `null` | Currently selected value |
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
| `optionBuilder` | `Widget Function(BuildContext, SelectOption)?` | Default text builder | Custom builder for options |
| `valueBuilder` | `Widget Function(BuildContext, SelectOption?, bool)?` | Default text builder | Custom builder for selected value |
| `showOverlay` | `Future<void> Function(BuildContext, Widget)?` | `null` | Custom overlay handler. If null, uses default `showDialog` |

### ToggleButtonGroup Widget

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `options` | `List<SelectOption>` | **required** | List of selectable options |
| `value` | `dynamic` | **required** | Currently selected value |
| `onChange` | `Function(dynamic)` | **required** | Callback when value changes |
| `buttonBuilder` | `Widget Function(BuildContext, SelectOption, bool)?` | Default rounded button | Custom builder for each button. Receives context, option, and isActive |
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

| Property | Type | Description |
|----------|------|-------------|
| `text` | `String` | Display text for the option |
| `value` | `dynamic` | Value associated with the option |
| `params` | `Map<String, dynamic>?` | Optional additional metadata |

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
