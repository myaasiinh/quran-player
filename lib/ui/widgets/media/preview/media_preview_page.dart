import '/ui/widgets/media/determine_media_widget.dart';
import '/ui/widgets/sky_image.dart';
import 'package:flutter/material.dart';

/* author
   myaasiinh@gmail.com
*/
class MediaPreviewPage extends StatelessWidget {
  const MediaPreviewPage({
    required this.src,
    super.key,
    this.isAsset = true,
    this.title,
    this.titleStyle,
    this.forceImage = false,
    this.forceVideo = false,
    this.forceFile = false,
  });
  final String src;
  final bool isAsset;
  final String? title;
  final TextStyle? titleStyle;
  final bool forceImage;
  final bool forceVideo;
  final bool forceFile;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(title ?? '', style: titleStyle),
      ),
      backgroundColor: Colors.black,
      body: DetermineMediaWidget(
        path: src,
        forceFile: forceFile,
        forceImage: forceImage,
        forceVideo: forceVideo,
        image: Center(
          child: SkyImage(src: src, isAsset: isAsset),
        ),
        // Set this widget if want to show file preview
        file: const SizedBox.shrink(),
        // Set this widget if want to show video preview
        video: const SizedBox.shrink(),
        // Set this widget if want to show custom unknown preview
        unknown: const SizedBox.shrink(),
      ),
    );
  }
}
