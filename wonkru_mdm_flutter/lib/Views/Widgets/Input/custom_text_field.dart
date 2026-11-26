import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../Core/Theme/design.dart';
import '../../../Logic/UI/input_controller.dart';

class CustomTextField extends StatefulWidget {
  const CustomTextField({
    super.key,
    required this.name,
    this.controller,
    this.initialValue,
    this.label,
    this.hint,
    this.helper,
    this.obscureText = false,
    this.enabled = true,
    this.readOnly = false,
    this.keyboardType,
    this.textAlign = TextAlign.start,
    this.textDirection,
    this.textInputAction,
    this.onSubmitted,
    this.onChanged,
    this.prefixIcon,
    this.maxLines = 1,
    this.autofocus = false,
    this.focusNode,
    this.inputFormatters,
    this.suffixIcon,
    this.onSuffixTap,
    this.showValidationError = true,
    this.dense = false,
    this.autofillHints,
  });

  /// Unique field name; used to look up/create a controller in
  /// [InputController] when [controller] is null.
  final String name;

  final TextEditingController? controller;
  final String? initialValue;

  final String? label;

  final String? hint;
  final String? helper;
  final bool obscureText;
  final bool enabled;
  final bool readOnly;
  final TextInputType? keyboardType;
  final TextAlign textAlign;
  final TextDirection? textDirection;
  final TextInputAction? textInputAction;
  final ValueChanged<String>? onSubmitted;
  final ValueChanged<String>? onChanged;
  final IconData? prefixIcon;
  final int? maxLines;
  final bool autofocus;

  /// Optional external [FocusNode]. If provided, this widget does not own or
  /// dispose it, allowing external focus management (requestFocus).
  final FocusNode? focusNode;

  final List<TextInputFormatter>? inputFormatters;
  final IconData? suffixIcon;
  final VoidCallback? onSuffixTap;

  /// Shows the validation error registered under [name] in [InputController]
  /// below the field. The error is shown even when an external [controller] is
  /// used, as long as a validator was registered for that name.
  final bool showValidationError;

  final bool dense;

  /// Browser/password manager hints ([AutofillHints]). The field must sit in an
  /// [AutofillGroup] for this to apply.
  final Iterable<String>? autofillHints;

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  late final FocusNode _focusNode;

  /// This widget never owns the controller, so dispose only removes the
  /// listener. Not `final` because the parent may swap in a different
  /// controller; that is handled in [didUpdateWidget].
  late TextEditingController _controller;

  bool _focused = false;
  bool _obscured = true;
  bool _hasText = false;

  @override
  void initState() {
    super.initState();
    _controller =
        widget.controller ??
        InputController.to.getController(
          widget.name,
          defaultValue: widget.initialValue,
        );
    _focusNode = (widget.focusNode ?? FocusNode())..addListener(_onFocusChange);
    _controller.addListener(_onTextChange);
    _hasText = _controller.text.isNotEmpty;
  }

  /// Moves the listener to the new controller when the parent swaps one in.
  /// The old controller may already be disposed by then, so removing the
  /// listener from it is guarded.
  @override
  void didUpdateWidget(CustomTextField oldWidget) {
    super.didUpdateWidget(oldWidget);
    final next = widget.controller;
    if (next == null || identical(next, _controller)) return;

    _removeTextListener(_controller);
    _controller = next;
    _controller.addListener(_onTextChange);
    _hasText = _controller.text.isNotEmpty;
  }

  void _removeTextListener(TextEditingController controller) {
    try {
      controller.removeListener(_onTextChange);
    } on FlutterError {
      // Controller already disposed: the listener is gone.
    }
  }

  void _onFocusChange() {
    setState(() => _focused = _focusNode.hasFocus);
  }

  /// Single change channel: the controller listener. Both user input and
  /// programmatic changes (setValue) flow through here, and InputController's
  /// own listener drives validation/dirty state.
  void _onTextChange() {
    final hasText = _controller.text.isNotEmpty;
    if (hasText != _hasText) {
      setState(() => _hasText = hasText);
    }
    widget.onChanged?.call(_controller.text);
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChange);
    if (widget.focusNode == null) {
      _focusNode.dispose();
    }
    _removeTextListener(_controller);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.label != null)
          Padding(
            padding: EdgeInsets.only(bottom: widget.dense ? 3 : AppSpacing.s6),
            child: SelectableText(
              widget.label!,
              maxLines: 1,
              style: AppText.label(
                context,
              ).copyWith(fontSize: widget.dense ? 11.5 : 13),
            ),
          ),
        if (widget.showValidationError)
          Obx(() {
            final error = InputController.to.getValidationError(widget.name);
            return _fieldWithError(context, colors, error);
          })
        else
          _field(context, colors, null),
        if (widget.helper != null && widget.helper!.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 5),
            child: Text(widget.helper!, style: AppText.caption(context)),
          ),
      ],
    );
  }

  Widget _fieldWithError(
    BuildContext context,
    AppColors colors,
    String? error,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        _field(context, colors, error),
        if (error != null && error.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: AppSpacing.s6),
            child: Text(
              error,
              style: AppText.caption(
                context,
                size: 12,
              ).copyWith(color: context.appColors.madder),
            ),
          ),
      ],
    );
  }

  Widget _field(BuildContext context, AppColors colors, String? error) {
    final lines = widget.obscureText ? 1 : (widget.maxLines ?? 1);
    final multiline = lines > 1;
    final hasError = error != null && error.isNotEmpty;

    final borderColor = hasError
        ? colors.madder
        : _focused
        ? colors.ring
        : colors.border;

    return Container(
      constraints: BoxConstraints(minHeight: widget.dense ? 30 : 40),
      // Clips content so child widgets cannot paint over the rounded corners.
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: widget.enabled ? colors.workshop : colors.muted,
        borderRadius: BorderRadius.circular(
          widget.dense ? AppRadius.r6 : AppRadius.r8,
        ),
        // The border stays 1px in every state: raising it to 1.5 on focus made
        // half-pixel corner arcs blurry and shifted text as the inner padding
        // changed. Focus is shown with the outer ring instead.
        border: Border.all(color: borderColor),
        boxShadow: _focused || hasError
            ? [
                BoxShadow(
                  color: borderColor.withValues(alpha: 0.18),
                  spreadRadius: 3,
                ),
              ]
            : null,
      ),
      child: Row(
        crossAxisAlignment: multiline
            ? CrossAxisAlignment.start
            : CrossAxisAlignment.center,
        children: [
          if (widget.prefixIcon != null)
            Padding(
              padding: EdgeInsets.only(
                left: AppSpacing.s10,
                top: multiline ? AppSpacing.s8 : 0,
              ),
              child: Icon(widget.prefixIcon, size: 14, color: colors.graphite),
            ),
          Expanded(
            child: TextField(
              controller: _controller,
              focusNode: _focusNode,
              obscureText: widget.obscureText && _obscured,
              enabled: widget.enabled,
              readOnly: widget.readOnly,
              keyboardType: widget.keyboardType,
              textAlign: widget.textAlign,
              textDirection: widget.textDirection,
              textInputAction: widget.textInputAction,
              onSubmitted: widget.onSubmitted,
              maxLines: lines,
              autofocus: widget.autofocus,
              autofillHints: widget.autofillHints,
              inputFormatters: widget.inputFormatters,
              style: AppText.body(context).copyWith(
                fontSize: widget.dense ? 12.5 : 14,
                height: widget.dense ? 1.2 : 1.45,
              ),
              cursorColor: colors.carbon,
              cursorWidth: 1.2,
              decoration: InputDecoration(
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                disabledBorder: InputBorder.none,
                errorBorder: InputBorder.none,
                focusedErrorBorder: InputBorder.none,
                isDense: true,
                isCollapsed: true,
                contentPadding: EdgeInsets.fromLTRB(
                  widget.prefixIcon != null ? 6 : (widget.dense ? 8 : 12),
                  multiline ? 8 : (widget.dense ? 6 : 10),
                  widget.dense ? 8 : 12,
                  multiline ? 8 : (widget.dense ? 6 : 10),
                ),
                hintText: widget.hint,
                // Hint line height must match the input text: otherwise the
                // hint drifts vertically and looks clipped.
                hintStyle: AppText.bodyMuted(context).copyWith(
                  color: colors.graphite.withValues(alpha: 0.6),
                  fontSize: widget.dense ? 12.5 : 14,
                  height: widget.dense ? 1.2 : 1.45,
                ),
                hintMaxLines: 1,
              ),
            ),
          ),
          if (widget.obscureText)
            GestureDetector(
              onTap: () => setState(() => _obscured = !_obscured),
              child: Padding(
                padding: const EdgeInsets.only(right: AppSpacing.s8),
                child: Icon(
                  _obscured ? LucideIcons.eye : LucideIcons.eyeOff,
                  size: 15,
                  color: colors.graphite,
                ),
              ),
            ),
          if (widget.suffixIcon != null)
            GestureDetector(
              onTap: widget.onSuffixTap,
              child: Padding(
                padding: const EdgeInsets.only(right: AppSpacing.s8),
                child: Icon(
                  widget.suffixIcon,
                  size: 15,
                  color: colors.graphite,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
