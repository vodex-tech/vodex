import 'dart:async';

import 'package:admin/src/view/widgets/cells/upload_file.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:admin/src/helper/cell.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:iconsax/iconsax.dart';
import 'package:kr_button/text_button.dart';

class FileField extends StatelessWidget {
  final Cell cell;
  final Function(String) onChanged;

  const FileField({
    super.key,
    required this.cell,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    double? progress;
    return IgnorePointer(
      ignoring: !cell.canEdit,
      child: Padding(
        padding: const EdgeInsets.only(top: 12, bottom: 12),
        child: StatefulBuilder(builder: (context, setState) {
          return KrTextButton(
            onPressed: () async {
              final uploadTask = await getFile();
              if (uploadTask != null) {
                StreamSubscription? subscription;
                uploadTask.then((p0) async {
                  final url = await p0.ref.getDownloadURL();
                  final meta = await p0.ref.getMetadata();
                  cell.sizeOrDuration = meta.size;
                  cell.payload = meta.name.split('.').last;
                  onChanged(url);
                  setState(() {});
                  subscription?.cancel();
                });
                subscription = uploadTask.snapshotEvents.listen((event) async {
                  setState(() {
                    progress = event.bytesTransferred / event.totalBytes * 100;
                    if (progress!.isNaN) {
                      progress = 0;
                    }
                  });
                });
              }
            },
            style: TextButton.styleFrom(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              backgroundColor: Colors.black.withOpacity(0.04),
              alignment: Alignment.center,
            ),
            child: Builder(builder: (_) {
              if (cell.formattedNewValue.isNotEmpty)
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 3),
                        child: Text(
                          cell.formattedNewValue,
                          style: TextStyle(
                            color: Colors.black.withOpacity(0.5),
                            fontSize: 14,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Icon(
                      Iconsax.document_upload,
                      color: Colors.black.withOpacity(0.5),
                      size: 22,
                    ),
                  ],
                );
              if (progress != null) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 3),
                      child: Text(
                        '${progress!.toStringAsFixed(1)}%',
                        style: TextStyle(
                          color: Colors.black.withOpacity(0.5),
                          fontSize: 14,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    SpinKitRing(
                      color: Theme.of(context).primaryColor,
                      size: 18,
                      lineWidth: 2,
                    ),
                  ],
                );
              }
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 3),
                    child: Text(
                      'Upload File',
                      style: TextStyle(
                        color: Colors.black.withOpacity(0.5),
                        fontSize: 14,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Icon(
                    Iconsax.document_upload,
                    color: Colors.black.withOpacity(0.5),
                    size: 22,
                  ),
                ],
              );
            }),
          );
        }),
      ),
    );
  }
}

const _kImageMaxWidthCache = 1000;

class CustomImage extends StatelessWidget {
  const CustomImage({
    Key? key,
    this.url,
    this.radius,
    this.onEmptyOrNull,
    this.onLoading,
    this.onError,
    this.width,
    this.height,
    this.padding,
    this.fit,
    this.onTap,
    this.loadingRadius,
    this.shimmerSize,
    this.borderRadius,
    this.bytes,
  }) : super(key: key);

  final String? url;
  final Uint8List? bytes;
  final String? onEmptyOrNull;
  final double? radius;
  final double? loadingRadius;
  final Widget? onLoading;
  final Widget? onError;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? padding;
  final BoxFit? fit;
  final Size? shimmerSize;
  final Function()? onTap;
  final BorderRadiusGeometry? borderRadius;

  @override
  Widget build(BuildContext context) {
    if ((url == null || url!.isEmpty) &&
        bytes == null &&
        (onEmptyOrNull == null || onEmptyOrNull!.isEmpty)) {
      return Padding(
        padding: padding ?? EdgeInsets.zero,
        child: Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            borderRadius: borderRadius ?? BorderRadius.circular(radius ?? 0),
            color: Colors.grey.shade200,
          ),
          child: const Center(
            child: ErrorImage(),
          ),
        ),
      );
    }
    Widget image;
    if (bytes != null) {
      image = Image.memory(
        bytes!,
        fit: fit,
        errorBuilder: (context, error, stackTrace) =>
            Center(child: onError ?? ErrorImage()),
      );
    } else {
      image = CachedNetworkImage(
        imageUrl: url != null && url!.isNotEmpty ? url! : onEmptyOrNull ?? '',
        placeholder: (context, url) => _onLoading(context),
        errorWidget: (context, url, error) {
          return Center(child: onError ?? const ErrorImage());
        },
        memCacheWidth: _kImageMaxWidthCache,
        maxWidthDiskCache: _kImageMaxWidthCache,
        fit: fit,
      );
    }
    image = SizedBox(
      width: width,
      height: height,
      child: image,
    );
    if (onTap != null) {
      image = InkWell(
        onTap: onTap,
        child: image,
      );
    }
    if (radius != null) {
      image = ClipRRect(
        borderRadius: borderRadius ?? BorderRadius.circular(radius!),
        child: image,
      );
    }
    return Padding(
      padding: padding ?? EdgeInsets.zero,
      child: image,
    );
  }

  Widget _onLoading(BuildContext context) {
    if (onLoading != null) return onLoading!;
    return Center(
      child: SpinKitRing(
        color: Theme.of(context).primaryColor,
        size: 40,
        lineWidth: 4,
      ),
    );
  }
}

class ErrorImage extends StatelessWidget {
  const ErrorImage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Icon(
      Icons.error_outline,
      color: Colors.grey,
      size: 40,
    );
  }
}
