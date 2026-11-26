import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:wonkrumdm/Core/Constants/Enums/global.dart';
import 'package:wonkrumdm/Core/Constants/ext.dart';
import 'package:wonkrumdm/Core/Theme/wonkru_theme.dart';
import 'package:wonkrumdm/Core/Extensions/list.dart';
import 'package:wonkrumdm/Core/Mixins/state_tools.dart';

class CustomDropdown extends StatefulWidget {
  const CustomDropdown({
    super.key,
    required this.data,
    required this.name,
    this.child,
    this.selected,
    this.onChanged,
    this.onInit,
    this.onTap,
    this.isExpanded,
    this.selectedText,
    this.margin,
    this.height,
    this.width,
    this.info,
    this.multiSelect = false,
    this.searchable = false,
    this.searchHint = "Ara...",
    this.onScan,
    this.required = false,
    this.labelText = "",
  });
  final Map<String, dynamic> data;
  final String name;
  final Widget? child;
  final List<String>? selected;
  final String? selectedText;
  final Function(String value, List<String> keys, List<String> values)? onChanged;
  final Function(String value, List<String> keys, List<String> values)? onInit;
  final Function(bool value)? onTap;
  final bool? isExpanded;
  final EdgeInsets? margin;
  final double? height;
  final double? width;
  final String? info;
  final bool multiSelect;
  final bool searchable;
  final String searchHint;
  final Function(String? value)? onScan;
  final bool required;
  final String labelText;

  @override
  State<CustomDropdown> createState() => _CustomDropdownState();
}

class _CustomDropdownState extends State<CustomDropdown> with StateTools {
  List<String> selectedKeys = [];
  List<String> selectedValues = [];
  String selectedText = "";

  bool open = false;
  String searchQuery = "";
  List<String> filteredKeys = [];

  final key = GlobalKey();
  final TextEditingController searchController = TextEditingController();

  late RenderBox box;
  double y = 0;
  late Offset position;

  @override
  void initState() {
    super.initState();

    if (widget.data.isEmpty) {
      selectedText = widget.selectedText ?? "---";
      return;
    }

    selectedKeys = widget.selected ?? [widget.data.keys.first];
    filteredKeys = widget.data.keys.toList();

    selectedText = widget.selectedText ?? "---";
    if (selectedKeys.isNotEmpty) {
      selectedText = "";
    }

    for (var key in selectedKeys) {
      selectedText += widget.data[key] ?? "---";
      if (key != selectedKeys.last) {
        selectedText += ", ";
      }

      selectedValues.add(widget.data[key]);
    }

    if (!widget.multiSelect && selectedKeys.isNotEmpty) {
      ic.setValue(widget.name, selectedKeys.first);
    } else if (widget.multiSelect) {
      ic.setValue(widget.name, selectedKeys.join(","));
    }

    open = widget.isExpanded ?? false;
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (widget.onInit != null) {
        widget.onInit!(selectedValues.join(","), selectedKeys, selectedValues);
      }
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  void _filterData(String query) {
    setState(() {
      searchQuery = query;
      if (query.isEmpty) {
        filteredKeys = widget.data.keys.toList();
      } else {
        filteredKeys = widget.data.keys
            .where((key) => widget.data[key].toString().toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  bool infoVisible = false;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (widget.labelText.isNotEmpty)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.labelText + (widget.required ? " *" : ""),
                style: WonkruText.body(12, color: WonkruColors.creamDim),
              ),
              if (widget.info != null)
                InkWell(
                  onTap: () {
                    bottomMessage(widget.info!, type: MessageType.info);
                  },
                  child: Icon(Icons.info_outline, color: WonkruColors.grayLight, size: 20),
                ),
            ],
          ),
        InkWell(
          onTap: () {
            if (widget.onTap != null) {
              widget.onTap!(open);
            }
            setState(() {
              open = !open;
              if (open && widget.searchable) {
                searchQuery = "";
                filteredKeys = widget.data.keys.toList();
                searchController.clear();
              }
            });
            hideKeyboard();
          },
          child: Container(
            width: context.width,
            decoration: BoxDecoration(
              color: WonkruColors.bg2,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: WonkruColors.creamBorder, width: 1),
              boxShadow: [BoxShadow(color: WonkruColors.creamFaint, blurRadius: 2, offset: Offset(0, 3))],
            ),
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    selectedText,
                    style: WonkruText.body(13, color: WonkruColors.cream),
                  ),
                ),
                Icon(Icons.arrow_downward, color: WonkruColors.creamDim, size: 16),
              ],
            ),
          ),
        ),
        if (open)
          Container(
            margin: EdgeInsets.only(top: 10, right: 10, left: 10, bottom: 10),
            decoration: BoxDecoration(
              color: WonkruColors.bg2,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [BoxShadow(color: WonkruColors.creamFaint, blurRadius: 2, offset: Offset(0, 3))],
            ),
            width: widget.width,
            constraints: BoxConstraints(maxHeight: widget.height ?? .5.sh, minWidth: 100),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (widget.searchable)
                  Container(
                    decoration: BoxDecoration(
                      color: WonkruColors.creamFaint,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: WonkruColors.creamBorder, width: 1),
                    ),
                    child: TextField(
                      controller: searchController,
                      onChanged: _filterData,
                      decoration: InputDecoration(
                        hintText: widget.searchHint,
                        hintStyle: WonkruText.body(12, color: WonkruColors.creamDim),
                        prefixIcon: Icon(Icons.search, color: WonkruColors.grayLight, size: 18),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 14),
                        isDense: true,
                      ),
                      style: WonkruText.body(12, color: WonkruColors.cream),
                    ),
                  ),
                Flexible(
                  child: SingleChildScrollView(
                    physics: BouncingScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: filteredKeys
                          .map(
                            (key) => InkWell(
                              onTap: () {
                                if (widget.multiSelect) {
                                  if (selectedKeys.contains(key)) {
                                    selectedKeys.remove(key);
                                  } else {
                                    selectedKeys.add(key);
                                  }
                                  selectedText = selectedKeys.map((e) => widget.data[e]).join(", ");
                                } else {
                                  selectedText = widget.data[key];
                                  selectedKeys = [key];
                                  ic.setValue(widget.name, key);
                                }
                                if (!widget.multiSelect) {
                                  open = false;
                                  setState(() {});
                                }

                                if (widget.onChanged != null) {
                                  widget.onChanged!(key, selectedKeys, selectedValues);
                                }
                                hideKeyboard();
                              },
                              child: Container(
                                margin: EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                                decoration: BoxDecoration(
                                  color: selectedKeys.contains(key)
                                      ? WonkruColors.accentDim
                                      : Colors.transparent,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    borderRadius: BorderRadius.circular(6),
                                    onTap: () {
                                      if (widget.multiSelect) {
                                        if (selectedKeys.contains(key)) {
                                          selectedKeys.remove(key);
                                        } else {
                                          selectedKeys.add(key);
                                        }
                                        selectedText = selectedKeys.map((e) => widget.data[e]).join(", ");
                                      } else {
                                        selectedText = widget.data[key];
                                        selectedKeys = [key];
                                        ic.setValue(widget.name, key);
                                      }
                                      if (!widget.multiSelect) {
                                        open = false;
                                        setState(() {});
                                      }

                                      if (widget.onChanged != null) {
                                        widget.onChanged!(key, selectedKeys, selectedValues);
                                      }
                                      hideKeyboard();
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                                      child: Row(
                                        children: [
                                          if (selectedKeys.contains(key))
                                            Icon(Icons.check, color: WonkruColors.accent, size: 16)
                                          else
                                            Container(
                                              width: 16,
                                              height: 16,
                                              decoration: BoxDecoration(
                                                border: Border.all(color: WonkruColors.creamBorder, width: 1),
                                                borderRadius: BorderRadius.circular(2),
                                              ),
                                            ),
                                          SizedBox(width: 8),
                                          Expanded(
                                            child: AutoSizeText(
                                              widget.data[key],
                                              maxLines: 1,
                                              minFontSize: 8,
                                              overflow: TextOverflow.ellipsis,
                                              style: WonkruText.body(13, color: selectedKeys.contains(key) ? WonkruColors.accent : WonkruColors.creamDim, weight: selectedKeys.contains(key) ? FontWeight.w600 : FontWeight.w400),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          )
                          .toList()
                          .seperatedBy(
                            Container(
                              width: 0.9.sw,
                              height: 0.5,
                              margin: EdgeInsets.symmetric(vertical: 2),
                              color: WonkruColors.creamBorder,
                            ),
                          ),
                    ),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}