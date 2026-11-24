import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:keyboard_actions/keyboard_actions.dart';

import '../constants/app_constants.dart';

class QuantitySelector extends StatefulWidget {
  final int quantity;
  final ValueChanged<int> onQuantityChanged;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;
  final bool enabled;
  final Widget? labelTrailing;

  const QuantitySelector({
    super.key,
    required this.quantity,
    required this.onIncrement,
    required this.onDecrement,
    required this.onQuantityChanged,
    this.enabled = true,
    this.labelTrailing,
  });

  @override
  State<QuantitySelector> createState() => _QuantitySelectorState();
}

class _QuantitySelectorState extends State<QuantitySelector> {
  late TextEditingController _controller;
  late FocusNode _focusNode;

  String _lastSubmittedValue = "";
  bool _skipNextFocusLossCommit = false;

  @override
  void initState() {
    super.initState();

    _controller = TextEditingController(
      text: widget.quantity.toString(),
    );

    _lastSubmittedValue = widget.quantity.toString();

    _focusNode = FocusNode();

    _focusNode.addListener(() {
      if (!_focusNode.hasFocus) {
        if (_skipNextFocusLossCommit) {
          _skipNextFocusLossCommit = false;
          return;
        }

        _onManualInputChanged(_controller.text);
      }
    });
  }

  @override
  void didUpdateWidget(covariant QuantitySelector oldWidget) {
    super.didUpdateWidget(oldWidget);

    final parsedValue = int.tryParse(_controller.text);

    if (widget.quantity != parsedValue) {
      _controller.text = widget.quantity.toString();

      _controller.selection = TextSelection.fromPosition(
        TextPosition(offset: _controller.text.length),
      );

      _lastSubmittedValue = _controller.text;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();

    super.dispose();
  }

  void _onManualInputChanged(String value) {
    if (value == _lastSubmittedValue) return;

    final newValue = int.tryParse(value);

    if (newValue != null && newValue >= 0) {
      _lastSubmittedValue = value;
      widget.onQuantityChanged(newValue);
    }
  }

  void _submitFromKeyboard() {
    _skipNextFocusLossCommit = true;

    _onManualInputChanged(_controller.text);

    _focusNode.unfocus();
  }

  KeyboardActionsConfig _buildConfig() {
    return KeyboardActionsConfig(
      keyboardActionsPlatform: KeyboardActionsPlatform.IOS,
      keyboardBarColor: Colors.grey[200],
      nextFocus: false,
      actions: [
        KeyboardActionsItem(
          focusNode: _focusNode,
          displayArrows: false,
          displayActionBar: true,
          displayDoneButton: true,
          onTapAction: _submitFromKeyboard,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final borderColor = Colors.grey.shade300;

    final backgroundColor =
        widget.enabled ? const Color(0xFFF3F4F6) : Colors.grey.shade200;

    final isIphone = Theme.of(context).platform == TargetPlatform.iOS &&
        MediaQuery.of(context).size.shortestSide < 600;

    Widget formContent = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Quantity',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w400,
                  ),
            ),
            if (widget.labelTrailing != null) ...[
              const Spacer(),
              widget.labelTrailing!,
            ],
          ],
        ),
        const SizedBox(height: 4),
        Container(
          height: AppSizes.size40,
          decoration: BoxDecoration(
            border: Border.all(color: borderColor),
            borderRadius: BorderRadius.circular(AppSizes.size6),
          ),
          child: Row(
            children: [
              Container(
                color: backgroundColor,
                child: IconButton(
                  icon: Icon(
                    Icons.remove,
                    size: AppSizes.size18,
                    color: Colors.grey.shade800,
                  ),
                  onPressed: widget.enabled ? widget.onDecrement : null,
                ),
              ),
              Expanded(
                child: TextField(
                  enabled: widget.enabled,
                  controller: _controller,
                  focusNode: _focusNode,
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.done,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  textAlign: TextAlign.center,
                  textAlignVertical: TextAlignVertical.center,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w400,
                      ),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(
                      vertical: 16,
                    ),
                  ),
                  onSubmitted: (_) => _submitFromKeyboard(),
                ),
              ),
              Container(
                color: backgroundColor,
                child: IconButton(
                  icon: Icon(
                    Icons.add,
                    size: AppSizes.size18,
                    color: Colors.grey.shade800,
                  ),
                  onPressed: widget.enabled ? widget.onIncrement : null,
                ),
              ),
            ],
          ),
        ),
      ],
    );

    if (isIphone) {
      return KeyboardActions(
        config: _buildConfig(),
        disableScroll: true,
        child: formContent,
      );
    }

    return formContent;
  }
}
