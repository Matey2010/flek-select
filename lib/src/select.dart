import 'package:flek_select/src/select_option.dart';
import 'package:flutter/material.dart';

const double _selectHeight = 48.0;
const EdgeInsets _defaultInputPadding = EdgeInsets.only(left: 12, right: 12);

/// Builder for the entire input field widget.
/// If provided, you are responsible for handling the tap to open.
typedef SelectInputBuilder<T, P> = Widget Function(
  BuildContext context,
  SelectOption<T, P>? selectedOption,
  bool isDisabled,
  VoidCallback onOpenSelectPopup,
);

/// Builder for the backdrop widget behind the popup.
/// If provided, you are responsible for handling the tap to close.
typedef SelectBackdropBuilder = Widget Function(
  BuildContext context,
  VoidCallback onCloseSelectPopup,
);

Widget _defaultOptionBuilder<T, P>(BuildContext context, SelectOption<T, P> option) {
  return Text(option.text);
}

Widget _defaultValueBuilder<T, P>(
  BuildContext context,
  SelectOption<T, P>? option,
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

class Select<T, P> extends StatefulWidget {
  final String? inputLabel;
  final String? inputHint;
  final String? dialogLabel;
  final String? hint;
  final T? value;
  final bool? isRequired;
  final void Function(T? value) onChange;
  final List<SelectOption<T, P>> options;
  final bool withNotSelectedOption;
  final bool showNotSelectedOption;
  final String notSelectedOptionText;
  final String? error;
  final bool isDisabled;
  final EdgeInsetsGeometry? inputPadding;
  final BoxDecoration? inputDecoration;
  final Color? backgroundColor;
  final Widget Function(BuildContext context, SelectOption<T, P> option)
  optionBuilder;
  final Widget Function(
    BuildContext context,
    SelectOption<T, P>? option,
    bool isDisabled,
  )?
  valueBuilder;
  @Deprecated(
    'showOverlay is deprecated and will be removed. Overlay behavior is now built-in.',
  )
  final Future<void> Function(BuildContext context, Widget dialogContent)?
  showOverlay;

  /// Builder for the entire input field widget.
  /// If provided, you are responsible for handling the tap to open the popup.
  final SelectInputBuilder<T, P>? inputBuilder;

  /// Builder for the backdrop widget behind the popup.
  /// If provided, you are responsible for handling the tap to close the popup.
  final SelectBackdropBuilder? backdropBuilder;

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
    this.inputBuilder,
    this.backdropBuilder,
    Widget Function(BuildContext context, SelectOption<T, P> option)? optionBuilder,
    Widget Function(
      BuildContext context,
      SelectOption<T, P>? option,
      bool isDisabled,
    )?
    valueBuilder,
    super.key,
  }) : optionBuilder = optionBuilder ?? _defaultOptionBuilder<T, P>,
       valueBuilder = valueBuilder ?? _defaultValueBuilder<T, P>,
       assert(
         !showNotSelectedOption || notSelectedOptionText != "",
         "notSelectedOptionText must be set if showNotSelectedOption is true",
       );

  @override
  State<Select<T, P>> createState() => _SelectState<T, P>();
}

class _SelectState<T, P> extends State<Select<T, P>> {
  bool isDialogVisible = false;
  OverlayEntry? _overlayEntry;
  final GlobalKey _selectKey = GlobalKey();

  @override
  void dispose() {
    _closeOverlay();
    super.dispose();
  }

  void _closeOverlay() {
    if (_overlayEntry == null) return;
    if (mounted) {
      setState(() {
        isDialogVisible = false;
      });
    }

    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  void _showSelectOverlay() {
    if (_overlayEntry != null) return; // Already open

    setState(() {
      isDialogVisible = true;
    });

    _overlayEntry = OverlayEntry(
      builder: (context) => _buildOverlayContent(context),
    );

    Overlay.of(context, rootOverlay: true).insert(_overlayEntry!);
  }

  Widget _buildOverlayContent(BuildContext context) {
    // Get screen size
    final screenSize = MediaQuery.of(context).size;

    // Build options list
    List<SelectOption<T, P>> optionsToShow = [
      if (widget.showNotSelectedOption)
        SelectOption<T, P>(text: widget.notSelectedOptionText, value: null as T),
      ...widget.options,
    ];

    return SizedBox.expand(
      child: Stack(
        children: [
          // Backdrop - tap to close
          Positioned.fill(
            child: widget.backdropBuilder != null
                ? widget.backdropBuilder!(context, _closeOverlay)
                : GestureDetector(
                    onTap: _closeOverlay,
                    behavior: HitTestBehavior.opaque,
                    child: Container(color: Colors.black87),
                  ),
          ),
          // Centered options container
          Center(
            child: Material(
              elevation: 8,
              borderRadius: BorderRadius.circular(8),
              color: widget.backgroundColor ?? Colors.white,
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: screenSize.height * 0.8,
                  maxWidth: screenSize.width * 0.9,
                ),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      if (widget.dialogLabel != null)
                        Padding(
                          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                          child: Text(
                            widget.dialogLabel!,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ...optionsToShow.map((option) {
                        return InkWell(
                          onTap: () {
                            widget.onChange(option.value);
                            _closeOverlay();
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                            child: widget.optionBuilder(context, option),
                          ),
                        );
                      }).toList(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  SelectOption<T, P>? get selectedOption {
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
        widget.inputBuilder != null
            ? KeyedSubtree(
                key: _selectKey,
                child: widget.inputBuilder!(
                  context,
                  selectedOption,
                  widget.isDisabled,
                  _showSelectOverlay,
                ),
              )
            : Container(
                key: _selectKey, // Add key for positioning
                height: widget.inputLabel != null ? _selectHeight : 32,
                decoration: BoxDecoration(
                  borderRadius: borderRadius,
                  color: widget.backgroundColor ?? Colors.white10,
                ).copyWith(color: widget.inputDecoration?.color),
                child: GestureDetector(
                  onTap: widget.isDisabled ? null : _showSelectOverlay,
                  behavior: HitTestBehavior.opaque,
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
