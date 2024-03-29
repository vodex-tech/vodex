import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

enum MiraiPopupMenuMode {
  popupMenu,
  dropDownMenu,
}

enum MiraiShowMode {
  top,
  bottom,
  center,
}

enum MiraiExit {
  fromAll,
  outside,
  inside,
}

class _SearchAttributes<T> {
  List<T> searchList;
  bool showHighLight;
  String mQueryClient;

  _SearchAttributes({
    this.searchList = const [],
    this.showHighLight = false,
    this.mQueryClient = '',
  });
}

OutlineInputBorder _miraiOutlineInputBorderForTextField({
  Color color = Colors.white,
  double borderRadius = 5,
  double borderWidth = 1,
}) {
  return OutlineInputBorder(
    borderRadius: BorderRadius.circular(borderRadius),
    borderSide: BorderSide(
      width: borderWidth,
      color: color,
    ),
  );
}

typedef MiraiDropdownBuilder<T> = Widget Function(int index, T item);

typedef MiraiHighLightDropdownBuilder<T> = Widget Function(
    int index, _SearchAttributes<T> item);

typedef MiraiValueChanged<T> = void Function(T value);

class MiraiPopupMenu<T> extends StatefulWidget {
  MiraiPopupMenu({
    Key? key,
    required this.child,
    this.other,
    this.decoration,
    required this.itemWidgetBuilder,
    this.itemHighLightBuilder,
    required this.children,
    this.mode = MiraiPopupMenuMode.dropDownMenu,
    this.showMode = MiraiShowMode.bottom,
    this.onChanged,
    this.maxHeight = 300,
    this.radius,
    this.enable = true,
    this.showSeparator = true,
    this.showOtherAndItsTextField = false,
    this.onOtherChanged,
    this.exit = MiraiExit.fromAll,
    this.isExpanded,
    this.space = 3,
    this.emptyListMessage,
    this.showSearchTextField = false,
    this.searchDecoration,
    this.searchValidator,
  })  : assert(child.key != null),
        super(key: key);

  /// Child widget that has dropdown menu
  final Widget child;

  /// Drop Down Decoration
  final Decoration? decoration;
  final Widget? other;

  /// itemWidget, is a widget that we display as an item in the list menu
  final MiraiDropdownBuilder<T> itemWidgetBuilder;
  final MiraiHighLightDropdownBuilder<T>? itemHighLightBuilder;

  /// children, is the list that we display in the dropdown
  final List<T> children;

  /// The max height of the dropdown
  final double maxHeight;
  final double? radius;

  /// mode, can have two values: dropDownMenu or popupMenu
  final MiraiPopupMenuMode mode;
  final MiraiShowMode showMode;
  final ValueChanged<T>? onChanged;
  final MiraiExit exit;
  final ValueChanged<bool>? isExpanded;
  final bool enable;
  final bool showSeparator;
  final bool showOtherAndItsTextField;
  final ValueChanged<String>? onOtherChanged;

  /// Space between dropdown and child
  final double space;

  final String? emptyListMessage;

  final bool showSearchTextField;
  final InputDecoration? searchDecoration;
  final FormFieldValidator<String>? searchValidator;

  @override
  _MiraiPopupMenuState<T> createState() => _MiraiPopupMenuState<T>();
}

class _MiraiPopupMenuState<T> extends State<MiraiPopupMenu<T>> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.enable ? _showDropDownMenu : null,
      child: widget.child,
    );
  }

  void _showDropDownMenu() {
    /// Find RenderBox object
    RenderBox renderBox = (widget.child.key as GlobalKey)
        .currentContext
        ?.findRenderObject() as RenderBox;
    Offset position = renderBox.localToGlobal(Offset.zero);

    if (widget.children.isNotEmpty) {
      showCupertinoDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) {
          return _DropDownMenuContent<T>(
            maxHeight: widget.maxHeight,
            radius: widget.radius,
            space: widget.space,
            showMode: widget.showMode,
            itemWidgetBuilder: widget.itemWidgetBuilder,
            mode: widget.mode,
            position: position,
            size: renderBox.size,
            onChanged: widget.onChanged,
            children: widget.children,
            decoration: widget.decoration,
            exit: widget.exit,
            isExpanded: widget.isExpanded,
            showOtherAndItsTextField: widget.showOtherAndItsTextField,
            showSeparator: widget.showSeparator,
            onOtherChanged: widget.onOtherChanged,
            showSearchTextField: widget.showSearchTextField,
            searchDecoration: widget.searchDecoration,
            searchValidator: widget.searchValidator,
          );
        },
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            widget.emptyListMessage ?? 'MiraiDropDown: Empty Children!',
          ),
        ),
      );
    }
  }
}

class _DropDownMenuContent<T> extends StatefulWidget {
  const _DropDownMenuContent({
    super.key,
    required this.children,
    required this.itemWidgetBuilder,
    this.itemHighLightBuilder,
    required this.position,
    required this.size,
    required this.mode,
    required this.showMode,
    this.onChanged,
    required this.maxHeight,
    this.radius,
    required this.showOtherAndItsTextField,
    required this.showSeparator,
    this.onOtherChanged,
    this.exit = MiraiExit.fromAll,
    this.isExpanded,
    required this.space,
    this.decoration,
    this.other,
    this.showSearchTextField = false,
    this.searchDecoration,
    this.searchValidator,
  });

  final List<T> children;
  final MiraiDropdownBuilder<T> itemWidgetBuilder;
  final MiraiHighLightDropdownBuilder<T>? itemHighLightBuilder;
  final Offset position;
  final Size size;
  final ValueChanged<T>? onChanged;
  final MiraiPopupMenuMode mode;
  final MiraiShowMode showMode;
  final double maxHeight;
  final double? radius;
  final bool showOtherAndItsTextField;
  final bool showSeparator;
  final ValueChanged<String>? onOtherChanged;
  final MiraiExit exit;
  final ValueChanged<bool>? isExpanded;
  final double space;
  final Decoration? decoration;
  final Widget? other;

  final bool showSearchTextField;
  final InputDecoration? searchDecoration;
  final FormFieldValidator<String>? searchValidator;

  @override
  _DropDownMenuContentState<T> createState() => _DropDownMenuContentState<T>();
}

class _DropDownMenuContentState<T> extends State<_DropDownMenuContent<T>>
    with SingleTickerProviderStateMixin {
  /// Let's create animation
  late AnimationController _animationController;
  late Animation<double> _animation;

  /// ListView controller
  final ScrollController _scrollController = ScrollController();

  /// Search Children
  ValueNotifier<_SearchAttributes<T>> searchChildren =
      ValueNotifier<_SearchAttributes<T>>(
    _SearchAttributes<T>(),
  );

  ///  Search Controller
  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );

    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOut,
      ),
    );

    /// Copy children to searchChildren.value.searchList
    searchChildren.value.searchList = List.from(widget.children);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _animationController.forward();
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final Size sizeScreen = MediaQuery.of(context).size;
    return Directionality(
      textDirection: TextDirection.ltr,
      child: WillPopScope(
        onWillPop: () async {
          _closePopup(context: context, action: null);
          return false;
        },
        child: GestureDetector(
          onTap: () => (widget.exit == MiraiExit.fromAll ||
                  widget.exit == MiraiExit.outside)
              ? _closePopup(context: context, action: null)
              : null,
          child: Material(
            elevation: 0,
            type: MaterialType.transparency,
            child: Container(
              height: sizeScreen.height,
              width: sizeScreen.width,
              color: Colors.transparent,
              child: Stack(
                children: [
                  Positioned(
                    right: (sizeScreen.width - widget.position.dx) -
                        widget.size.width,
                    top: widget.showMode == MiraiShowMode.bottom
                        ? widget.position.dy + widget.space + widget.size.height
                        : widget.showMode == MiraiShowMode.center
                            ? Get.height / 2 - widget.maxHeight / 2
                            : null,
                    bottom: widget.showMode == MiraiShowMode.top
                        ? sizeScreen.height - widget.position.dy + widget.space
                        : widget.showMode == MiraiShowMode.center
                            ? Get.height / 2 - widget.maxHeight / 2
                            : null,
                    child: AnimatedBuilder(
                      animation: _animationController,
                      builder: (context, child) {
                        return Transform.scale(
                          scale: _animation.value,
                          alignment: widget.showMode == MiraiShowMode.center
                              ? Alignment.center
                              : widget.showMode != MiraiShowMode.top
                                  ? Alignment.topCenter
                                  : Alignment.bottomCenter,
                          child: Opacity(
                            opacity: _animation.value,
                            child: child,
                          ),
                        );
                      },
                      child: Container(
                        height: widget.children.length > 20
                            ? 300
                            : widget.maxHeight,
                        width: widget.size.width - 1,
                        decoration: widget.decoration ??
                            BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                                  BorderRadius.circular(widget.radius ?? 5),
                              border: Border.all(
                                color: const Color(0xFFCECECE),
                                width: 0.5,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(.1),
                                  blurRadius: 8,
                                ),
                              ],
                            ),
                        child: ValueListenableBuilder<_SearchAttributes<T>>(
                          valueListenable: searchChildren,
                          builder: (_, _SearchAttributes<T> children, __) {
                            return Scrollbar(
                              thumbVisibility: true,
                              controller: _scrollController,
                              radius: const Radius.circular(20),
                              child: ListView.separated(
                                controller: _scrollController,
                                shrinkWrap: true,
                                padding: EdgeInsets.zero,
                                itemCount: children.searchList.length +
                                    (widget.showOtherAndItsTextField ? 1 : 0) +
                                    (widget.showSearchTextField ? 1 : 0),
                                itemBuilder: (_, int index) {
                                  return itemBuilderReturn(children, index);
                                },
                                separatorBuilder: (_, int index) {
                                  if (widget.showSeparator) {
                                    return buildSeparator();
                                  } else {
                                    return const SizedBox.shrink();
                                  }
                                },
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget itemBuilderReturn(_SearchAttributes<T> children, int index) {
    if (!widget.showOtherAndItsTextField) {
      if (widget.showSearchTextField) {
        if (index == 0 && widget.showSearchTextField) {
          return buildSearchTextField(context);
        } else {
          return buildItemToReturn(
            index - 1,
            children,
          );
        }
      } else {
        return buildItemToReturn(index, children);
      }
    } else {
      if (index !=
          children.searchList.length + (widget.showSearchTextField ? 1 : 0)) {
        if (widget.showSearchTextField) {
          if (index == 0) {
            return buildSearchTextField(context);
          } else {
            return buildItemToReturn(
              index - 1,
              children,
            );
          }
        } else {
          return buildItemToReturn(index, children);
        }
      } else {
        return buildOtherWidget();
      }
    }
  }

  ElevatedButton buildItemToReturn(int index, _SearchAttributes<T> children) {
    return ElevatedButton(
      onPressed: () => onTapChild(index),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ).copyWith(elevation: MaterialStateProperty.all(0)),
      child: widget.itemWidgetBuilder(
        index,
        children.searchList[index],
      ),
    );
  }

  Container buildSearchTextField(BuildContext context) {
    return Container(
      height: 40,
      margin: const EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 8,
      ),
      child: TextFormField(
        controller: searchController,
        textAlignVertical: TextAlignVertical.center,
        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: Theme.of(context).primaryColorDark,
            ),
        cursorColor: Theme.of(context).primaryColorDark,
        decoration: widget.searchDecoration ??
            InputDecoration(
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.all(12),
              hintText: 'Search...',
              border: _miraiOutlineInputBorderForTextField(),
            ),
        validator: widget.searchValidator,
        textInputAction: TextInputAction.next,
        onFieldSubmitted: (_) {},
        onChanged: (String text) {
          searchSubscription(text);
        },
      ),
    );
  }

  MiraiKeyboardVisibilityBuilder buildOtherWidget() {
    return MiraiKeyboardVisibilityBuilder(
      builder: (context, child, isKeyboardVisible) {
        if (isKeyboardVisible) {
          _scrollController.jumpTo(
            _scrollController.position.maxScrollExtent,
          );
        }
        return Container(
          color: Colors.red,
          child: Padding(
            padding: EdgeInsets.only(
              bottom: isKeyboardVisible ? 46 : 0,
            ),
            child: widget.other,
          ),
        );
      },
    );
  }

  Container buildSeparator() {
    return Container(
      height: 1,
      color: const Color(0xFF707070).withOpacity(0.2),
    );
  }

  void _closePopup({required BuildContext context, required T? action}) {
    widget.isExpanded?.call(false);
    _animationController.reverse().whenComplete(() {
      if (action != null) widget.onChanged?.call(action);
      Navigator.pop(context);
    });
  }

  void onTapChild(int index) {
    if (widget.exit == MiraiExit.fromAll || widget.exit == MiraiExit.inside) {
      _closePopup(
        context: context,
        action: searchChildren.value.searchList[index],
      );
    } else {
      widget.onChanged?.call(searchChildren.value.searchList[index]);
    }
    setState(() => selectedIndex = index);
  }

  void clearTextController() {
    searchController.clear();
    searchChildren.value.showHighLight = true;
    searchChildren.value.mQueryClient = '';
    searchChildren.value.searchList = List.from(widget.children);
  }

  void searchSubscription(String query) {
    _SearchAttributes<T> searchAttributes = _SearchAttributes<T>();
    if (query.isNotEmpty) {
      searchAttributes.showHighLight = true;
      searchAttributes.mQueryClient = query;

      final results = widget.children.where((child) =>
          ((child is String) ? child : child.toString())
              .toLowerCase()
              .contains(query));
      searchAttributes.searchList = List.from(results);
    } else {
      searchAttributes.showHighLight = false;
      searchAttributes.mQueryClient = '';
      searchAttributes.searchList = List.from(widget.children);
    }
    searchChildren.value = searchAttributes;
  }
}

class MiraiKeyboardVisibilityBuilder extends StatefulWidget {
  final Widget? child;
  final Widget Function(
    BuildContext context,
    Widget? child,
    bool isKeyboardVisible,
  ) builder;

  const MiraiKeyboardVisibilityBuilder({
    Key? key,
    this.child,
    required this.builder,
  }) : super(key: key);

  @override
  MiraiKeyboardVisibilityBuilderState createState() =>
      MiraiKeyboardVisibilityBuilderState();
}

class MiraiKeyboardVisibilityBuilderState
    extends State<MiraiKeyboardVisibilityBuilder> with WidgetsBindingObserver {
  bool _isKeyboardVisible =
      WidgetsBinding.instance.window.viewInsets.bottom > 0.0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeMetrics() {
    final bottomInset = WidgetsBinding.instance.window.viewInsets.bottom;
    final newValue = bottomInset > 0.0;
    if (newValue != _isKeyboardVisible) {
      setState(() {
        _isKeyboardVisible = newValue;
      });
    }
  }

  @override
  Widget build(BuildContext context) => widget.builder(
        context,
        widget.child,
        _isKeyboardVisible,
      );
}
