import 'package:admin/src/controllers/controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:kr_extensions/extension.dart';
import 'package:url_launcher/url_launcher_string.dart';

class DataGridErrorWidget extends StatelessWidget {
  const DataGridErrorWidget({
    super.key,
    required this.message,
    required this.controller,
  });

  final String message;
  final DataController controller;

  @override
  Widget build(
    BuildContext context,
  ) {
    String msg = message;
    final urls = msg.urls.where((e) => e.isURL);
    final hasLink = urls.isNotEmpty;
    if (hasLink) {
      for (final e in urls) {
        msg = msg.replaceAll(e, '');
      }
    }
    return Container(
      padding: const EdgeInsets.all(20),
      constraints: const BoxConstraints(maxWidth: 600),
      child: ListView(
        shrinkWrap: true,
        physics: const ClampingScrollPhysics(),
        children: [
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: Text(
                msg,
                style:
                    const TextStyle(fontSize: 14, fontWeight: FontWeight.w300),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          ...urls.map(
            (e) => Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
                child: TextButton(
                  onPressed: () {
                    launchUrlString(e);
                  },
                  style: TextButton.styleFrom(
                      backgroundColor:
                          Theme.of(context).primaryColor.withOpacity(0.1),
                      foregroundColor: Colors.black,
                      minimumSize: Size.zero,
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      textStyle: const TextStyle(fontWeight: FontWeight.normal),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8))),
                  child: Row(
                    children: [
                      Expanded(
                          child: Text(e,
                              maxLines: 1, overflow: TextOverflow.ellipsis)),
                      IconButton(
                        onPressed: () {
                          Clipboard.setData(ClipboardData(text: e));
                        },
                        icon: const Icon(Iconsax.copy),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Center(
            child: TextButton(
              onPressed: () {
                controller.datasource.handleRefresh();
              },
              style: TextButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor,
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  textStyle: const TextStyle(fontWeight: FontWeight.normal),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8))),
              child: const Text(
                'Retry',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
