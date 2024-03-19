import 'package:flutter/material.dart';

Future<T?> showBottomDialog<T>(
  BuildContext context, {
  required String title,
  required Widget child,
  bool? isDismissible,
  double? maxHeight,
  EdgeInsetsGeometry? padding,
  bool? enableDrag,
}) async {
  return showModalBottomSheet<T>(
    context: context,
    useRootNavigator: true,
    barrierColor: Colors.black.withOpacity(0.24),
    backgroundColor: Colors.transparent,
    isDismissible: isDismissible ?? true,
    enableDrag: enableDrag ?? isDismissible ?? true,
    isScrollControlled: true,
    useSafeArea: true,
    constraints: BoxConstraints(
      minHeight: 200,
      maxHeight: MediaQuery.of(context).size.height,
    ),
    builder: (ctx) {
      return Stack(
        children: [
          Positioned.fill(
            child: GestureDetector(
              onTap: () => Navigator.of(context, rootNavigator: true).pop(),
              child: Container(
                color: Colors.transparent,
              ),
            ),
          ),
          Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
            ),
            margin: const EdgeInsets.only(top: 60),
            constraints: const BoxConstraints(
              minHeight: 140,
            ),
            child: SafeArea(
              bottom: false,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsetsDirectional.only(
                      top: 8,
                      start: 16,
                      end: 8,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsetsDirectional.only(start: 8),
                          child: Text(
                            title,
                            style: const TextStyle(
                              fontSize: 18,
                              height: 1,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: () =>
                              Navigator.of(context, rootNavigator: true).pop(),
                          style: TextButton.styleFrom(
                            minimumSize: const Size(10, 10),
                            foregroundColor: Colors.grey,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50),
                            ),
                          ),
                          child: const Icon(
                            Icons.close,
                            size: 26,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Flexible(
                    child: Padding(
                      padding: padding ??
                          const EdgeInsetsDirectional.only(
                            top: 15,
                            end: 16,
                            start: 16,
                          ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Flexible(child: child),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      );
    },
  );
}
