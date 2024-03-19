import 'dart:io';

import 'package:admin/admin.dart';
import 'package:admin/data/file.dart';
import 'package:datasource/datasource.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:kr_paginate_firestore/paginate_firestore.dart';
import 'package:logic_study/view/components/shimmer.dart';
import 'package:logic_study/theme/colors.dart';
import 'package:path_provider/path_provider.dart';
import 'controller.dart';
import 'package:open_file/open_file.dart';

int y = 0;

class FilesList extends GetView<VideoController> {
  const FilesList({super.key});

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(builder: (context, setState) {
      return KrPaginateFirestore(
        key: ValueKey(controller.chapter.value!.id + y.toString()),
        useInsideScrollView: true,
        itemBuilder: (context, docs, index) {
          final e = docs.elementAt(index).data() as AttachmentFile;
          return Column(
            children: [
              FileTile(e, onEdit: () => setState(() => ++y)),
              if (index == docs.length - 1 && controller.isAdmin) ...[
                _AddButton(() => setState(() {
                      ++y;
                    })),
              ] else if (index == docs.length - 1)
                const SafeArea(top: false, child: SizedBox(height: 20)),
            ],
          );
        },
        query: controller.filesQuery,
        itemBuilderType: PaginateBuilderType.listView,
        separator: const SizedBox(height: 12),
        initialLoader: ListView.separated(
          itemCount: 3,
          shrinkWrap: true,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          separatorBuilder: (context, index) {
            return const SizedBox(height: 12);
          },
          itemBuilder: (context, index) {
            return const _PlaceHolder();
          },
        ),
        bottomLoader: const Padding(
          padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
          child: _PlaceHolder(),
        ),
        onEmpty: Padding(
            padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Center(child: Text('لا توجد ملفات')),
                if (controller.isAdmin) _AddButton(() => setState(() {})),
              ],
            )),
      );
    });
  }
}

class FileTile extends GetView<VideoController> {
  FileTile(
    this.attachment, {
    required this.onEdit,
    super.key,
  });

  final AttachmentFile attachment;
  final Function() onEdit;

  formatSize(int size) {
    if (size > 1000000) {
      return '${(size / 1000000).toStringAsFixed(2)} MB';
    } else if (size > 1000) {
      return '${(size / 1000).toStringAsFixed(2)} KB';
    } else {
      return '$size B';
    }
  }

  late final FileDownloader downloader = FileDownloader(attachment);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (!controller.canPlayAttachment(attachment)) {
          return;
        }
        downloader.downloadFileWithProgress();
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Row(
          children: [
            Obx(() => Stack(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: Icon(
                        downloader.status.value == DownlaodStatus.downloaded
                            ? Icons.insert_drive_file
                            : Icons.download,
                        color: Colors.grey.shade700,
                        size: 20,
                      ),
                    ),
                    if (!controller.canPlayAttachment(attachment))
                      Positioned.fill(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: Icon(
                            Iconsax.lock,
                            color: Colors.grey.shade700,
                          ),
                        ),
                      )
                    else if (downloader.status.value ==
                        DownlaodStatus.downloading)
                      Positioned.fill(
                        child: CircularProgressIndicator(
                          value: downloader.progress.value,
                          valueColor:
                              const AlwaysStoppedAnimation(AppColors.primary),
                          strokeWidth: 2,
                        ),
                      ),
                  ],
                )),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    attachment.title,
                    style: const TextStyle(
                      color: Color(0xFF1D2130),
                      fontSize: 14,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    formatSize(attachment.size),
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                    ),
                    textDirection: TextDirection.ltr,
                  ),
                ],
              ),
            ),
            if (controller.isAdmin)
              IconButton(
                onPressed: () async {
                  final res = await edit<AttachmentFile>(
                      attachment, FileDataGridProvider(attachment));
                  if (res != null) onEdit();
                },
                icon: const Icon(Icons.more_vert_rounded, color: Colors.grey),
              ),
          ],
        ),
      ),
    );
  }
}

class _PlaceHolder extends StatelessWidget {
  const _PlaceHolder();

  @override
  Widget build(BuildContext context) {
    return const ShimmerBloc(size: Size(double.maxFinite, 80), radius: 8);
  }
}

class _AddButton extends GetView<VideoController> {
  const _AddButton(this.onSave);

  final Function() onSave;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: TextButton(
          onPressed: () async {
            final attachment = AttachmentFile(
              chapterId: controller.chapter.value!.id,
              title: '',
              fileUrl: '',
              size: 0,
              extension: '',
              isFree: false,
            );
            final res = await edit<AttachmentFile>(
                attachment, FileDataGridProvider(attachment));
            if (res == true) onSave();
          },
          style: TextButton.styleFrom(
            foregroundColor: Colors.black,
            backgroundColor: Colors.grey.shade100,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(color: Colors.grey.shade300),
            ),
            fixedSize: const Size(double.maxFinite, 50),
            textStyle: const TextStyle(
              fontSize: 14,
            ),
          ),
          child: const Text('إضافة ملف جديد'),
        ),
      ),
    );
  }
}

enum DownlaodStatus { notDownloaded, downloading, downloaded }

class FileDownloader {
  final AttachmentFile attachment;

  FileDownloader._(this.attachment) {
    isDownloaded();
  }

  static final _cache = <String, FileDownloader>{};

  factory FileDownloader(AttachmentFile attachment) {
    return _cache.putIfAbsent(
        attachment.id, () => FileDownloader._(attachment));
  }

  final RxDouble progress = 0.0.obs;
  final Rx<DownlaodStatus> status = DownlaodStatus.notDownloaded.obs;

  isDownloaded() async {
    final appDocDir = await getDownloadsDirectory();
    final File file =
        File('${appDocDir!.path}/${attachment.id}.${attachment.extension}');
    if (file.existsSync()) {
      status.value = DownlaodStatus.downloaded;
    } else {
      status.value = DownlaodStatus.notDownloaded;
    }
  }

  Future<void> downloadFileWithProgress() async {
    if (status.value == DownlaodStatus.downloaded) {
      try {
        final path = await getDownloadsDirectory();
        OpenFile.open('${path!.path}/${attachment.id}.${attachment.extension}');
      } catch (e) {
        print(e);
      }
      return;
    }
    status.value = DownlaodStatus.downloading;
    try {
      Dio dio = Dio();
      final response = await dio.get(
        attachment.fileUrl,
        onReceiveProgress: (received, total) {
          if (total != -1) {
            progress.value = received / total;
          }
        },
        options: Options(
          responseType: ResponseType.bytes,
          followRedirects: false,
          validateStatus: (status) {
            return status! < 500;
          },
        ),
      );

      final path = await getDownloadsDirectory();
      final file =
          File('${path!.path}/${attachment.id}.${attachment.extension}');
      await file.writeAsBytes(response.data!);

      status.value = DownlaodStatus.downloaded;
      Get.snackbar('تم التحميل', 'تم تحميل الملف بنجاح');
    } catch (e) {
      Get.snackbar('خطأ', 'حدث خطأ أثناء تحميل الملف');
      status.value = DownlaodStatus.notDownloaded;
    }
  }
}
