import 'dart:async';

import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../Core/Errors/server_error_message.dart';
import '../../../Core/Theme/design.dart';
import '../Loading/app_loader.dart';
import 'text_controllers_owner.dart';
import 'custom_text_field.dart';

/// Typing re-runs [load] after a short debounce.
class RemoteSearchList<T> extends StatefulWidget {
  const RemoteSearchList({
    super.key,
    required this.load,
    required this.itemBuilder,
    required this.searchName,
    required this.searchHint,
    required this.errorText,
    required this.emptyText,
    this.toolbar,
    this.listHeader,
    this.onLoaded,
  });

  /// Receives the trimmed search text, or null when it is empty.
  final Future<List<T>> Function(String? search) load;
  final Widget Function(BuildContext context, T item) itemBuilder;
  final String searchName;
  final String searchHint;
  final String errorText;
  final String emptyText;

  final Widget Function(bool loading, List<T> items)? toolbar;

  final Widget? listHeader;

  final void Function(List<T> items)? onLoaded;

  @override
  State<RemoteSearchList<T>> createState() => _RemoteSearchListState<T>();
}

class _RemoteSearchListState<T> extends State<RemoteSearchList<T>>
    with TextControllersOwner<RemoteSearchList<T>> {
  late final _search = textController();
  Timer? _debounce;

  List<T> _items = const [];
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  void _onSearchChanged(String value) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), _load);
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    final query = _search.text.trim();
    try {
      final items = await widget.load(query.isEmpty ? null : query);
      if (!mounted) return;
      setState(() {
        _items = items;
        _loading = false;
      });
      widget.onLoaded?.call(items);
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = serverErrorMessage(e);
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: AppSpacing.s12,
      children: [
        CustomTextField(
          name: widget.searchName,
          controller: _search,
          hint: widget.searchHint,
          prefixIcon: LucideIcons.search,
          dense: true,
          showValidationError: false,
          onChanged: _onSearchChanged,
        ),
        ?widget.toolbar?.call(_loading, _items),
        ConstrainedBox(
          constraints: const BoxConstraints(maxHeight: 340),
          child: _body(context),
        ),
      ],
    );
  }

  Widget _body(BuildContext context) {
    if (_loading) {
      return const Padding(
        padding: AppInsets.v32,
        child: Center(child: AppLoader(size: 22)),
      );
    }

    if (_error != null) {
      return Padding(
        padding: AppInsets.v24,
        child: Text(
          widget.errorText,
          textAlign: TextAlign.center,
          style: AppText.body(
            context,
          ).copyWith(color: context.appColors.madder),
        ),
      );
    }

    if (_items.isEmpty) {
      return Padding(
        padding: AppInsets.v24,
        child: Text(
          widget.emptyText,
          textAlign: TextAlign.center,
          style: AppText.bodyMuted(context),
        ),
      );
    }

    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ?widget.listHeader,
          for (final item in _items) widget.itemBuilder(context, item),
        ],
      ),
    );
  }
}
