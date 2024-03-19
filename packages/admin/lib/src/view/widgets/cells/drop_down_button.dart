import 'package:admin/src/helper/cell.dart';
import 'package:admin/src/view/widgets/cells/text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:kr_builder/kr_builder.dart';
import 'package:kr_pull_down_button/pull_down_button.dart';

import 'drop_down_package.dart';

class DropDownButton extends StatefulWidget {
  const DropDownButton({
    super.key,
    required this.cell,
    this.onChanged,
  });

  final Cell cell;
  final Function(String)? onChanged;

  @override
  State<DropDownButton> createState() => _DropDownButtonState();
}

class _DropDownButtonState extends State<DropDownButton> {
  late String selectedValue = widget.cell.formattedNewValue;
  late final _controller = TextEditingController(text: selectedValue);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return KrFutureBuilder<List<String>>(
      initialData: widget.cell.options,
      future:
          widget.cell.optionsAsync?.call() ?? Future.value(widget.cell.options),
      onLoading: Stack(
        alignment: Alignment.center,
        children: [
          Opacity(
            opacity: 0.6,
            child: DataTextField(
              controller: _controller,
              canEdit: false,
              cell: widget.cell,
              suffixIcon: Icons.arrow_drop_down,
            ),
          ),
          SpinKitRing(
            color: Theme.of(context).primaryColor,
            size: 22,
            lineWidth: 2,
          )
        ],
      ),
      builder: (options) {
        if (options.length > 8) {
          return DropDownMore(
            hint: widget.cell.title,
            items: options,
            initialValue: widget.cell.formattedNewValue,
            controller: _controller,
            onChanged: (value) {
              _controller.text = value;
              widget.onChanged?.call(value);
            },
          );
        }
        return PullDownButton(
            routeTheme: PullDownMenuRouteTheme(
              width: widget.cell.minWidth ?? (Get.width - 40),
              backgroundColor: Colors.white,
            ),
            itemBuilder: (context) => options
                .map((e) => PullDownMenuItem(
                      title: e,
                      itemTheme: const PullDownMenuItemTheme(
                        textStyle: TextStyle(
                          color: Colors.black,
                        ),
                      ),
                      onTap: () {
                        _controller.text = e;
                        widget.onChanged?.call(e);
                      },
                    ))
                .toList(),
            applyOpacity: true,
            buttonBuilder: (context, showMenu) {
              return GestureDetector(
                onTap: () {
                  FocusScope.of(context).unfocus();
                  showMenu();
                },
                behavior: HitTestBehavior.opaque,
                child: IgnorePointer(
                  child: DataTextField(
                    controller: _controller,
                    canEdit: false,
                    cell: widget.cell,
                    suffixIcon: Icons.arrow_drop_down,
                  ),
                ),
              );
            });
      },
    );
  }
}

class DropDownMore extends StatefulWidget {
  const DropDownMore({
    super.key,
    required this.onChanged,
    required this.hint,
    required this.items,
    required this.initialValue,
    this.maxHeight,
    this.showSearch = true,
    this.controller,
  });

  final Function(String) onChanged;
  final String hint;
  final List<String> items;
  final String initialValue;
  final double? maxHeight;
  final bool showSearch;
  final TextEditingController? controller;

  @override
  State<DropDownMore> createState() => _DropDownMoreState();
}

class _DropDownMoreState extends State<DropDownMore> {
  String? _value;
  late final _controller =
      widget.controller ?? TextEditingController(text: widget.initialValue);

  @override
  void initState() {
    if (widget.initialValue.isNotEmpty) _value = widget.initialValue;
    super.initState();
  }

  @override
  void dispose() {
    if (widget.controller == null) _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MiraiPopupMenu<String>(
      maxHeight: widget.maxHeight ?? 600,
      radius: 20,
      children: widget.items,
      showMode: MiraiShowMode.center,
      showSearchTextField: widget.showSearch,
      showSeparator: false,
      onChanged: (value) => setState(() {
        _value = value;
        widget.onChanged(value);
        _controller.text = value;
      }),
      isExpanded: (x) async {
        Get.focusScope?.unfocus();
      },
      searchDecoration: InputDecoration(
        hintText: widget.hint,
        hintStyle: const TextStyle(color: Colors.grey),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 10,
        ),
        isDense: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: Colors.grey.shade300,
          ),
        ),
      ),
      emptyListMessage: widget.hint,
      itemWidgetBuilder: (index, item) => Directionality(
        textDirection: TextDirection.ltr,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 10.0,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                item,
                style: TextStyle(
                  color: _value == item
                      ? Theme.of(context).primaryColor
                      : Colors.black,
                ),
              ),
            ],
          ),
        ),
      ),
      child: Container(
        color: Colors.transparent,
        key: GlobalKey(),
        child: IgnorePointer(
          child: DataTextField(
            controller: _controller,
            canEdit: false,
            suffixIcon: Icons.arrow_drop_down,
            cell: CellText(
              widget.initialValue,
              id: '',
            ),
          ),
        ),
      ),
    );
  }
}
