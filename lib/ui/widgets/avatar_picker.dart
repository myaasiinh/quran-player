import 'package:quran_player/ui/widgets/sky_appbar.dart';
import 'dart:io';

import '/core/helper/bottom_sheet_helper.dart';
import '/core/helper/media_helper.dart';
import '/ui/widgets/media/attachments_source_bottom_sheet.dart';
import '/ui/widgets/sky_image.dart';
import 'package:flutter/material.dart';

/// Widget yang digunakan untuk memilih dan menampilkan gambar avatar.
/// Memiliki fitur untuk menampilkan gambar dari path lokal, gambar placeholder
/// berdasarkan inisial nama, serta tombol untuk mengedit atau menghapus avatar.
class AvatarPicker extends StatelessWidget {
  /// Konstruktor untuk membuat widget [AvatarPicker].
  const AvatarPicker({
    required this.onAvatarSelected,
    super.key,
    this.imagePath,
    this.editWidget,
    this.hideRemove = false,
    this.enabled = true,
    this.namePlaceholder,
    this.onRemoveImage,
    this.editIcon,
    this.editBackgroundColor,
  });

  /// Path menuju file gambar yang dipilih.
  final String? imagePath;

  /// Nama yang digunakan untuk menghasilkan inisial pada gambar placeholder
  /// jika [imagePath] bernilai null.
  final String? namePlaceholder;

  /// Widget khusus untuk digunakan sebagai tombol edit.
  final Widget? editWidget;

  /// Ikon khusus untuk tombol edit (digunakan jika [editWidget] bernilai null).
  final Widget? editIcon;

  /// Warna latar belakang untuk tombol edit.
  final Color? editBackgroundColor;

  /// Jika bernilai true, akan menyembunyikan tombol hapus gambar.
  final bool hideRemove;

  /// Menandakan apakah picker ini aktif dan bisa diklik oleh pengguna.
  final bool enabled;

  /// Callback yang dipanggil saat pengguna berhasil memilih sebuah gambar avatar.
  final void Function(File) onAvatarSelected;

  /// Callback yang dipanggil saat pengguna menghapus gambar avatar yang sedang ditampilkan.
  final VoidCallback? onRemoveImage;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 80,
      width: 80,
      child: Stack(
        children: [
          // Menampilkan gambar avatar utama
          GestureDetector(
            onTap: enabled ? _onPickAvatar : null,
            child: SkyImage(
              width: 80,
              height: 80,
              shapeImage: ShapeImage.oval,
              src: imagePath ??
                  (namePlaceholder != null
                      ? MediaHelper.generateAvatarByName(
                          namePlaceholder.toString(),
                        )
                      : AppImages.imgPlaceholderUser),
            ),
          ),
          // Menampilkan tombol edit yang ada di pojok kanan bawah
          Container(
            alignment: Alignment.bottomRight,
            child: GestureDetector(
              onTap: enabled ? _onPickAvatar : null,
              child: editWidget ??
                  Container(
                    width: 24,
                    height: 24,
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: editBackgroundColor ?? Colors.white,
                      borderRadius: const BorderRadius.all(Radius.circular(30)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withValues(alpha: 0.2),
                          spreadRadius: 2,
                          blurRadius: 1,
                        ),
                      ],
                    ),
                    child: editIcon ??
                        const Icon(
                          Icons.mode_edit,
                          size: 15.9,
                          color: Colors.black,
                        ),
                  ),
            ),
          ),
          // Menampilkan tombol hapus jika gambar ada dan tidak disembunyikan
          if (imagePath != null && !hideRemove)
            GestureDetector(
              onTap: onRemoveImage,
              child: Container(
                alignment: Alignment.bottomRight,
                child: Container(
                  width: 24,
                  height: 24,
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: const BorderRadius.all(Radius.circular(30)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withValues(alpha: 0.2),
                        spreadRadius: 2,
                        blurRadius: 1,
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.close_rounded,
                    size: 15.9,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  /// Menampilkan bottom sheet untuk memilih sumber lampiran (kamera/galeri).
  Future<void> _onPickAvatar() async {
    await BottomSheetHelper.bar(
      child: AttachmentsSourceBottomSheet(
        allowMultiple: false,
        withImageCompression: true,
        onAttachmentsSelected: onAvatarSelected,
        onMultipleAttachmentsSelected: (results) {},
      ),
    );
  }
}
