import 'package:flek_select/src/select_option.dart';
import 'package:flutter/material.dart';
import 'package:tappable/tappable.dart';

Widget _defaultButtonBuilder<T, P>(
  BuildContext context,
  SelectOption<T, P> option,
  bool isActive,
) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    decoration: BoxDecoration(
      color: isActive ? Colors.blue : Colors.grey.shade200,
      borderRadius: BorderRadius.circular(8),
    ),
    child: Text(
      option.text,
      style: TextStyle(
        color: isActive ? Colors.white : Colors.black87,
        fontSize: 14,
        fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
      ),
    ),
  );
}

class ToggleButtonGroup<T, P> extends StatelessWidget {
  final List<SelectOption<T, P>> options;
  final T? value;
  final void Function(T? value) onChange;
  final Widget Function(BuildContext context, SelectOption<T, P> option, bool isActive)?
      buttonBuilder;
  final double spacing;
  final double runSpacing;
  final WrapAlignment wrapAlignment;
  final WrapCrossAlignment wrapCrossAxisAlignment;
  final bool isDisabled;
  final bool scrollable;
  final ScrollController? scrollController;
  final MainAxisAlignment scrollAlignment;
  final CrossAxisAlignment scrollCrossAlignment;
  final EdgeInsetsGeometry? scrollPadding;
  final ScrollPhysics? scrollPhysics;
  final Clip clipBehavior;

  const ToggleButtonGroup({
    required this.options,
    required this.value,
    required this.onChange,
    this.buttonBuilder,
    this.spacing = 8.0,
    this.runSpacing = 8.0,
    this.wrapAlignment = WrapAlignment.start,
    this.wrapCrossAxisAlignment = WrapCrossAlignment.center,
    this.isDisabled = false,
    this.scrollable = false,
    this.scrollController,
    this.scrollAlignment = MainAxisAlignment.start,
    this.scrollCrossAlignment = CrossAxisAlignment.center,
    this.scrollPadding,
    this.scrollPhysics,
    this.clipBehavior = Clip.hardEdge,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveButtonBuilder = buttonBuilder ?? _defaultButtonBuilder<T, P>;

    final buttons = options.map((option) {
      final isActive = option.value == value;

      return Tappable(
        onTap: isDisabled
            ? null
            : () {
                onChange(option.value);
              },
        borderRadius: BorderRadius.circular(8),
        fillParent: false,
        child: effectiveButtonBuilder(context, option, isActive),
      );
    }).toList();

    if (scrollable) {
      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        controller: scrollController,
        padding: scrollPadding,
        physics: scrollPhysics,
        clipBehavior: clipBehavior,
        child: Row(
          mainAxisAlignment: scrollAlignment,
          crossAxisAlignment: scrollCrossAlignment,
          children: buttons
              .asMap()
              .entries
              .map((entry) {
                final index = entry.key;
                final button = entry.value;
                return Padding(
                  padding: EdgeInsets.only(
                    right: index < buttons.length - 1 ? spacing : 0,
                  ),
                  child: button,
                );
              })
              .toList(),
        ),
      );
    }

    return Wrap(
      spacing: spacing,
      runSpacing: runSpacing,
      alignment: wrapAlignment,
      crossAxisAlignment: wrapCrossAxisAlignment,
      children: buttons,
    );
  }
}
