# FlekSelect

A customizable Flutter select widget with flexible overlay options and tree-shakable exports. Extracted from dredge_ui as part of a modular package restructuring.

## Features

- **Flexible Overlay System**: Custom callback for showing select options dialog
- **Tree-Shakable**: Import only what you need
- **Highly Customizable**: Custom builders for options and values
- **Responsive Touch**: Uses Tappable package for better touch feedback
- **Rich Options**: Labels, hints, errors, disabled states, and more

## Installation

Add this to your package's `pubspec.yaml` file:

```yaml
dependencies:
  flek_select:
    path: ../flek_select
```

## Usage

### Basic Example

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

### With "Not Selected" Option

```dart
Select(
  options: myOptions,
  value: selectedValue,
  onChange: (value) => setState(() => selectedValue = value),
  showNotSelectedOption: true,
  notSelectedOptionText: 'None',
)
```

## API Reference

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

### SelectOption Model

| Property | Type | Description |
|----------|------|-------------|
| `text` | `String` | Display text for the option |
| `value` | `dynamic` | Value associated with the option |
| `params` | `Map<String, dynamic>?` | Optional additional metadata |

## Tree-Shaking

Import only what you need:

```dart
// Import only Select widget
import 'package:flek_select/select.dart';

// Import only SelectOption model
import 'package:flek_select/select_option.dart';
```

This ensures unused code is not included in your app bundle.

## License

MIT License
