/* author
   myaasiinh@gmail.com
*/

import '/config/themes/app_colors.dart';
import '/core/extension/context_extension.dart';
import '/core/helper/validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Widget kustom untuk form input teks ([TextFormField]).
///
/// Menyediakan berbagai macam konfigurasi seperti label, ikon,
/// validasi, warna, dan gaya teks agar mudah digunakan kembali.
class SkyFormField extends StatelessWidget {
  /// Konstruktor untuk membuat [SkyFormField].
  const SkyFormField({
    super.key,
    this.label,
    this.hint,
    this.maxLength,
    this.maxLines = 1,
    this.onPress,
    this.endIcon,
    this.isRequired = false,
    this.validator,
    this.validators,
    this.controller,
    this.keyboardType,
    this.icon,
    this.backgroundColor,
    this.textColor = Colors.grey,
    this.hintColor = Colors.grey,
    this.inputFormatters,
    this.onFieldSubmitted,
    this.initialValue,
    this.onChanged,
    this.readOnly = false,
    this.validate = false,
    this.enabled,
    this.endText,
    this.disableBorder = false,
    this.prefixWidget,
    this.disabledBorder,
    this.style,
    this.hintStyle,
  });

  /// Teks label yang ditampilkan di atas form field.
  final String? label;
  /// Teks petunjuk (placeholder) yang ditampilkan saat form kosong.
  final String? hint;
  /// Teks yang ditampilkan di bagian akhir form (sebagai akhiran).
  final String? endText;
  /// Kontroler untuk mengelola nilai input teks.
  final TextEditingController? controller;
  /// Jenis keyboard yang akan ditampilkan.
  final TextInputType? keyboardType;
  /// Ikon di bagian awal form field.
  final IconData? icon;
  /// Widget ikon kustom di bagian akhir form field.
  final Widget? endIcon;
  /// Batas maksimal panjang karakter yang dapat dimasukkan.
  final int? maxLength;
  /// Jumlah baris maksimal untuk input teks.
  final int? maxLines;
  /// Fungsi panggilan balik ketika form ditekan.
  final VoidCallback? onPress;
  /// Menandakan apakah field ini wajib diisi atau tidak.
  final bool isRequired;
  /// Fungsi validasi kustom tunggal.
  final String? Function(String?)? validator;
  /// Daftar fungsi validasi.
  final List<FormFieldValidator<String>>? validators;
  /// Aturan format input, seperti angka saja.
  final List<TextInputFormatter>? inputFormatters;
  /// Warna latar belakang form field.
  final Color? backgroundColor;
  /// Warna teks pada input.
  final Color? textColor;
  /// Warna teks petunjuk (hint).
  final Color? hintColor;
  /// Jika bernilai `true`, form hanya bisa dibaca.
  final bool readOnly;
  /// Fungsi panggilan balik saat menekan tombol submit di keyboard.
  final Function(String)? onFieldSubmitted;
  /// Fungsi panggilan balik saat teks berubah.
  final Function(String)? onChanged;
  /// Menentukan status awal untuk memicu validasi saat kosong.
  final bool validate;
  /// Nilai teks awal pada form field.
  final String? initialValue;
  /// Widget kustom yang diletakkan di bagian awal form.
  final Widget? prefixWidget;
  /// Menentukan apakah border (garis batas) akan disembunyikan.
  final bool disableBorder;
  /// Menentukan apakah input ini aktif atau tidak.
  final bool? enabled;
  /// Gaya border yang digunakan saat input dinonaktifkan.
  final InputBorder? disabledBorder;
  /// Gaya teks untuk input.
  final TextStyle? style;
  /// Gaya teks untuk teks petunjuk (hint).
  final TextStyle? hintStyle;

  @override
  Widget build(BuildContext context) {
    // Menyiapkan daftar formatter untuk input
    final formatters = <TextInputFormatter>[
      // Membatasi panjang teks sesuai parameter
      LengthLimitingTextInputFormatter(maxLength),
    ];
    // Jika ada inputFormatters tambahan, gabungkan ke daftar utama
    if (inputFormatters != null) {
      formatters.addAll(inputFormatters!);
    }

    /// Menginisialisasi nilai awal pada kontroler jika tersedia dan kontroler kosong
    if (controller != null && controller?.text == '' && initialValue != null) {
      controller?.text = initialValue.toString();
    }

    // Mengembalikan widget TextFormField bawaan Flutter dengan penyesuaian
    return TextFormField(
      // Mengatur status aktif
      enabled: enabled,
      // Panggilan balik saat ditekan
      onTap: onPress,
      // Status baca-saja
      readOnly: readOnly,
      // Berpindah ke form selanjutnya saat selesai diedit
      onEditingComplete: () => FocusScope.of(context).nextFocus(),
      // Menyambungkan kontroler
      controller: controller,
      // Menentukan tipe keyboard
      keyboardType: keyboardType,
      // Mengatur batas karakter
      maxLength: maxLength,
      // Mengatur jumlah baris
      maxLines: maxLines,
      // Mengatur nilai awal (jika tidak pakai kontroler)
      initialValue: (controller == null) ? initialValue : null,
      // Panggilan balik untuk aksi submit keyboard
      onFieldSubmitted: onFieldSubmitted,
      // Panggilan balik ketika input berubah
      onChanged: onChanged,
      // Mengatur tampilan (dekorasi) input
      decoration: InputDecoration(
        // Mengaktifkan latar warna
        filled: true,
        // Warna latar belakang
        fillColor: backgroundColor,
        // Mode padding yang lebih padat
        isDense: true,
        // Menyembunyikan atau menampilkan border dasar
        border: disableBorder ? InputBorder.none : null,
        // Menyembunyikan atau menampilkan border ketika fokus
        focusedBorder: disableBorder ? InputBorder.none : null,
        // Border khusus ketika dinonaktifkan
        disabledBorder: disabledBorder,
        // Menentukan ikon bagian depan
        prefixIcon: (prefixWidget != null)
            ? prefixWidget
            : (icon != null)
                ? Icon(icon, size: 25)
                : null,
        // Menentukan widget/teks di bagian akhir
        suffixIcon: (endText == null)
            ? endIcon
            : Align(
                widthFactor: 1,
                alignment: Alignment.centerRight,
                child: Text(
                  endText.toString(),
                  // Gaya teks untuk teks akhir
                  style: context.typography.subtitle4.copyWith(
                    color: Colors.grey,
                  ),
                ),
              ),
        // Pesan error jika wajib diisi dan kosong
        errorText: validate ? 'Field cannot be empty!' : null,
        // Menentukan teks petunjuk (placeholder)
        hintText: hint,
        // Menentukan label teks
        labelText: (label != null) ? label : null,
        // Gaya teks untuk label ketika berada di atas field
        floatingLabelStyle: TextStyle(color: textColor),
        // Gaya teks label secara umum
        labelStyle: context.typography.body2.copyWith(color: hintColor),
        // Gaya teks petunjuk
        hintStyle:
            hintStyle ?? context.typography.body2.copyWith(color: hintColor),
      ),
      // Gaya teks yang diketik pengguna
      style: style,
      // Mengatur fungsi validasi
      validator: validator ??
          // Menggabungkan beberapa validasi secara berantai
          Validator.list([
            // Menambahkan validasi wajib isi jika isRequired true
            if (isRequired) Validator.required(),
            // Menggabungkan seluruh validator dari list
            ...?validators,
          ]),
      // Menerapkan pembatasan dan format input
      inputFormatters: formatters,
    );
  }
}

/// Widget kustom khusus untuk input kata sandi (password).
///
/// Membawa fitur keamanan standar seperti penyembunyian teks
/// dan parameter-parameter serupa dengan [SkyFormField].
class SkyPasswordFormField extends StatelessWidget {
  /// Konstruktor untuk membuat [SkyPasswordFormField].
  const SkyPasswordFormField({
    required this.hint,
    required this.validator,
    required this.controller,
    super.key,
    this.label,
    this.onPress,
    this.endIcon,
    this.errorText,
    this.hiddenText = true,
    this.onSaved,
    this.onChanged,
    this.isRequired = true,
    this.validators,
    this.icon,
    this.backgroundColor,
    this.textColor = AppColors.primary,
    this.hintColor = Colors.grey,
    this.maxLength,
    this.onSubmit,
    this.endText,
    this.initialValue,
    this.style,
    this.disableBorder = false,
    this.enabled,
    this.disabledBorder,
    this.prefixWidget,
  });

  /// Label untuk form kata sandi.
  final String? label;
  /// Teks petunjuk untuk pengisian.
  final String? hint;
  /// Teks akhiran untuk ditampilkan di bagian akhir form.
  final String? endText;
  /// Kontroler untuk mengambil nilai password.
  final TextEditingController? controller;
  /// Ikon di bagian depan (prefix).
  final IconData? icon;
  /// Widget di bagian belakang (suffix), umumnya untuk tombol lihat password.
  final Widget? endIcon;
  /// Fungsi ketika form disentuh/ditekan.
  final VoidCallback? onPress;
  /// Batas maksimal panjang password.
  final int? maxLength;
  /// Fungsi panggilan balik ketika data disimpan dalam state form.
  final String? Function(String?)? onSaved;
  /// Fungsi panggilan balik setiap ada perubahan input.
  final String? Function(String?)? onChanged;
  /// Fungsi panggilan balik ketika menekan submit pada keyboard.
  final String? Function(String?)? onSubmit;
  /// Status apakah kolom ini wajib diisi.
  final bool isRequired;
  /// Fungsi validasi tunggal bawaan/kustom.
  final String? Function(String?)? validator;
  /// Daftar kumpulan fungsi validasi.
  final List<FormFieldValidator<String>>? validators;
  /// Pesan error kustom untuk ditampilkan secara eksplisit.
  final String? errorText;
  /// Menyembunyikan karakter dengan titik/bintang (default true).
  final bool hiddenText;
  /// Warna latar form kata sandi.
  final Color? backgroundColor;
  /// Warna teks password.
  final Color? textColor;
  /// Warna teks petunjuk.
  final Color? hintColor;
  /// Nilai awal password yang akan ditampilkan.
  final String? initialValue;
  /// Gaya kustom teks password.
  final TextStyle? style;
  /// Widget kustom yang diletakkan di bagian awal form.
  final Widget? prefixWidget;
  /// Menghilangkan border jika bernilai `true`.
  final bool disableBorder;
  /// Menentukan apakah input interaktif atau tidak.
  final bool? enabled;
  /// Gaya border ketika state disabled.
  final InputBorder? disabledBorder;

  @override
  Widget build(BuildContext context) {
    // Inisialisasi awal nilai kontroler jika kosong namun nilai awal tersedia
    if (controller != null && controller?.text == '' && initialValue != null) {
      controller?.text = initialValue.toString();
    }
    return TextFormField(
      // Memindahkan fokus otomatis ketika selesai mengedit
      onEditingComplete: () => FocusScope.of(context).nextFocus(),
      // Menghubungkan TextEditingController
      controller: controller,
      // Mengatur nilai awal bila tidak memakai kontroler
      initialValue: (controller == null) ? initialValue : null,
      // Konfigurasi dekorasi tampilan
      decoration: InputDecoration(
        // Menentukan apakah form memiliki warna pengisi
        filled: true,
        // Menentukan warna background form
        fillColor: backgroundColor,
        // Mengubah layout agar sedikit lebih ramping
        isDense: true,
        // Menghilangkan border dalam kondisi normal jika diminta
        border: disableBorder ? InputBorder.none : null,
        // Menghilangkan border dalam kondisi fokus jika diminta
        focusedBorder: disableBorder ? InputBorder.none : null,
        // Pengaturan border saat disabled
        disabledBorder: disabledBorder,
        // Pesan kesalahan
        errorText: errorText,
        // Widget ikon awal
        prefixIcon: (prefixWidget != null)
            ? prefixWidget
            : (icon != null)
                ? Icon(icon, size: 25)
                : null,
        // Widget ikon akhir, contohnya ikon mata
        suffixIcon: (endText == null)
            ? endIcon
            : Align(
                widthFactor: 1,
                alignment: Alignment.centerRight,
                child: Text(
                  endText.toString(),
                  style: context.typography.subtitle4,
                ),
              ),
        // Placeholder petunjuk
        hintText: hint,
        // Label teks di atas form
        labelText: (label != null) ? label : null,
        // Gaya label mengambang
        floatingLabelStyle: TextStyle(color: textColor),
        // Gaya teks untuk label
        labelStyle: context.typography.body2.copyWith(color: hintColor),
        // Gaya teks untuk placeholder petunjuk
        hintStyle: context.typography.body2.copyWith(color: hintColor),
      ),
      // Menyembunyikan input (biasanya digunakan untuk password)
      obscureText: hiddenText,
      // Batasan panjang karakter
      maxLength: maxLength,
      // Panggilan untuk perubahan input
      onChanged: onChanged,
      // Panggilan untuk menyimpan form
      onSaved: onSaved,
      // Panggilan klik pada input field
      onTap: onPress,
      // Panggilan aksi sumbit keyboard
      onFieldSubmitted: onSubmit,
      // Memvalidasi data yang dimasukkan pengguna
      validator: validator ??
          Validator.list([
            if (isRequired) Validator.required(),
            ...?validators,
          ]),
      // Menerapkan gaya input teks
      style: style,
    );
  }
}

/// Widget kecil untuk menampilkan satu kriteria persyaratan kata sandi.
///
/// Akan menampilkan tanda centang hijau jika valid,
/// atau tanda silang abu-abu jika belum valid.
class RegisterPasswordRequirement extends StatelessWidget {
  /// Konstruktor pembuatan UI kriteria kata sandi.
  const RegisterPasswordRequirement({
    required this.isValid,
    required this.message,
    super.key,
  });

  /// Indikator apakah persyaratan ini telah terpenuhi (valid).
  final bool isValid;
  /// Teks pesan/keterangan persyaratan (misalnya "Minimal 8 karakter").
  final String message;

  @override
  Widget build(BuildContext context) {
    // Menyusun posisi ikon dan teks secara horizontal
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Menampilkan ikon berdasarkan status kevalidan
        if (isValid)
          const Icon(Icons.check_circle_outline, color: Colors.green)
        else
          const Icon(Icons.close, color: Colors.grey),
        // Jarak antar ikon dan teks pesan
        const SizedBox(width: 5),
        // Membungkus pesan teks untuk menangani teks multi-baris
        Expanded(
          child: Text(
            message,
            // Memberikan warna hijau jika terpenuhi, abu-abu jika tidak
            style: TextStyle(color: isValid ? Colors.green : Colors.grey),
          ),
        ),
      ],
    );
  }
}
