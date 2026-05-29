import '/ui/widgets/media/determine_media_widget.dart';
import '/ui/widgets/sky_appbar.dart';
import '/ui/widgets/sky_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/* author
   myaasiinh@gmail.com
*/
class MediaListPreviewPage extends StatelessWidget {
  const MediaListPreviewPage({required this.mediaUrls, super.key});
  final List<String> mediaUrls;

  @override
  Widget build(BuildContext context) {
    final children = <Widget>[];

    for (final item in mediaUrls) {
      children
        ..add(
          DetermineMediaWidget(
            path: item,
            image: SkyImage(src: item, enablePreview: true),
            // Set this widget if want to show file preview
            file: const SizedBox.shrink(),
            // Set this widget if want to show video preview
            video: const SizedBox.shrink(),
            // Set this widget if want to show custom unknown preview
            unknown: const SizedBox.shrink(),
          ),
        )
        ..add(const Divider());
    }
    return Scaffold(
      appBar: SkyAppBar.primary(title: '${'txt_preview'.tr} ${'txt_media'.tr}'),
      body: SingleChildScrollView(child: Column(children: children)),
    );
  }
}
