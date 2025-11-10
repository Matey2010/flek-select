import 'package:flek_select/src/select_option.dart';
import 'package:flutter/material.dart';
import 'package:tappable/tappable.dart';

const double _selectHeight = 48.0;
const EdgeInsets _defaultInputPadding = EdgeInsets.only(left: 12, right: 12);

Widget _defaultOptionBuilder(BuildContext context, SelectOption option) {
  return Text(option.text);
}

Widget _defaultValueBuilder(
  BuildContext context,
  SelectOption? option,
  bool isDisabled,
) {
  final textStyle = TextStyle(
    color: isDisabled ? Colors.blueGrey : Colors.grey,
    fontSize: 14,
    height: 1.2,
    fontWeight: FontWeight.w500,
    overflow: TextOverflow.ellipsis,
  );

  return Text(option?.text ?? "", style: textStyle);
}

class Select extends StatefulWidget {
  final String? inputLabel;
  final String? inputHint;
  final String? dialogLabel;
  final String? hint;
  final dynamic value;
  final bool? isRequired;
  final void Function(dynamic value) onChange;
  final List<SelectOption> options;
  final bool withNotSelectedOption;
  final bool showNotSelectedOption;
  final String notSelectedOptionText;
  final String? error;
  final bool isDisabled;
  final EdgeInsetsGeometry? inputPadding;
  final BoxDecoration? inputDecoration;
  final Color? backgroundColor;
  final Widget Function(BuildContext context, SelectOption option)
      optionBuilder;
  final Widget Function(
    BuildContext context,
    SelectOption? option,
    bool isDisabled,
  )? valueBuilder;
  final Future<void> Function(BuildContext context, Widget dialogContent)?
      showOverlay;

  const Select({
    required this.options,
    this.isRequired,
    this.inputLabel,
    this.inputHint,
    this.value,
    this.hint,
    required this.onChange,
    this.withNotSelectedOption = false,
    this.showNotSelectedOption = false,
    this.notSelectedOptionText = "",
    this.error,
    this.isDisabled = false,
    this.inputPadding,
    this.dialogLabel,
    this.inputDecoration,
    this.backgroundColor,
    this.showOverlay,
    Widget Function(BuildContext context, SelectOption option)? optionBuilder,
    Widget Function(
      BuildContext context,
      SelectOption? option,
      bool isDisabled,
    )?
        valueBuilder,
    super.key,
  })  : optionBuilder = optionBuilder ?? _defaultOptionBuilder,
        valueBuilder = valueBuilder ?? _defaultValueBuilder,
        assert(
          !showNotSelectedOption || notSelectedOptionText != "",
          "notSelectedOptionText must be set if showNotSelectedOption is true",
        );

  @override
  State<Select> createState() => _SelectState();
}

class _SelectState extends State<Select> {
  bool isDialogVisible = false;

  Future<void> showSelectDialog(BuildContext context) async {
    List<SelectOption> optionsToShow = [
      if (widget.showNotSelectedOption)
        SelectOption(text: widget.notSelectedOptionText, value: null),
      ...widget.options,
    ];

    final dialogContent = SimpleDialog(
      title: widget.dialogLabel != null ? Text(widget.dialogLabel!) : null,
      children: optionsToShow.map((e) {
        return SimpleDialogOption(
          onPressed: () {
            widget.onChange(e.value);
            Navigator.of(context).pop();
          },
          child: widget.optionBuilder(context, e),
        );
      }).toList(),
    );

    setState(() {
      isDialogVisible = true;
    });

    if (widget.showOverlay != null) {
      await widget.showOverlay!(context, dialogContent);
    } else {
      await showDialog(
        context: context,
        builder: (context) => dialogContent,
      );
    }

    if (mounted) {
      setState(() {
        isDialogVisible = false;
      });
    }
  }

  SelectOption? get selectedOption {
    final selectedValueIndex = widget.options.indexWhere(
      (element) => element.value == widget.value,
    );

    if (selectedValueIndex == -1) {
      return null;
    }

    return widget.options[selectedValueIndex];
  }

  @override
  Widget build(BuildContext context) {
    final BorderRadius borderRadius =
        (widget.inputDecoration?.borderRadius as BorderRadius?) ??
            BorderRadius.all(Radius.circular(8));

    final String? formattedLabel = (() {
      if (widget.inputLabel == null) {
        return null;
      }

      final label = widget.inputLabel!;

      if (widget.isRequired == true) {
        return "$label*";
      }

      return label;
    })();

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (formattedLabel != null) ...[
          Text(
            formattedLabel,
            style: TextStyle(
              color: widget.isDisabled ? Colors.grey : Colors.blueGrey,
              fontSize: 12,
              height: 1.2,
              fontWeight: FontWeight.w300,
            ),
          ),
        ],
        Container(
          height: widget.inputLabel != null ? _selectHeight : 32,
          decoration: BoxDecoration(
            borderRadius: borderRadius,
            color: widget.backgroundColor ?? Colors.white10,
          ).copyWith(color: widget.inputDecoration?.color),
          child: Tappable(
            borderRadius: borderRadius,
            onTap: widget.isDisabled
                ? null
                : () {
                    showSelectDialog(context);
                  },
            child: Container(
              padding: widget.inputPadding ?? _defaultInputPadding,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: widget.valueBuilder!(
                      context,
                      selectedOption,
                      widget.isDisabled,
                    ),
                  ),
                  Icon(
                    widget.isDisabled
                        ? Icons.lock
                        : isDialogVisible
                            ? Icons.arrow_drop_up
                            : Icons.arrow_drop_down,
                    size: 24,
                    color: Colors.grey,
                  ),
                ],
              ),
            ),
          ),
        ),
        if (widget.error != null || widget.hint != null)
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              widget.error ?? widget.hint!,
              style: TextStyle(
                fontSize: 12,
                color: widget.error != null ? Colors.red : Colors.blue,
              ),
            ),
          ),
      ],
    );
  }
}
