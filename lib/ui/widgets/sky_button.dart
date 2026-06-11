import '/config/themes/app_colors.dart';
import '/core/extension/context_extension.dart';
import 'package:flutter/material.dart';

/* author
   myaasiinh@gmail.com
*/

/// Widget [SkyButton] adalah tombol default pada proyek ini dengan warna utama aplikasi (primary color).
/// Dapat diubahsuai sesuai dengan kebutuhan dan parameter yang telah disediakan.
class SkyButton extends StatelessWidget {
  /// Konstruktor untuk inisialisasi instance [SkyButton].
  /// Membutuhkan parameter [text] dan [onPressed].
  const SkyButton({
    required this.text,
    required this.onPressed,
    super.key,
    this.icon,
    this.color = AppColors.primary,
    this.iconColor,
    this.textColor,
    this.height = 48,
    this.width = double.infinity,
    this.fontSize,
    this.fontWeight,
    this.borderRadius,
    this.elevation,
    this.margin,
    this.padding,
    this.wrapContent = false,
    this.borderColor,
    this.borderWidth,
    this.leading,
    this.outlineMode = false,
    this.radiusValue = 8,
    this.child,
    this.gradient,
    this.enabled = true,
    this.isLoading = false,
  });

  /// Background color of button (Warna latar belakang tombol). Nilai default-nya adalah warna primary (utama).
  final Color color;

  /// Text color of button (Warna font teks tombol). Nilai default di fallback akan menghasilkan putih.
  final Color? textColor;

  /// Border color of button (Warna garis tepi atau outline tombol).
  final Color? borderColor;

  /// Text color of leading icon (Warna yang digunakan untuk ikon bawaan (leading) pada tombol).
  final Color? iconColor;

  /// Action or function that called when button pressed (Aksi atau callback fungsi yang dijalankan saat tombol ditekan).
  final VoidCallback? onPressed;

  /// Display text in button (String teks untuk ditampilkan di bagian dalam label tombol).
  final String? text;

  /// Width shape of button (Tinggi tombol). Nilai dasar (default) diset ke 48.
  final double? height;

  /// Width shape of button, default value is match parent (Lebar dari tombol). Nilai dasar diset memenuhi bentang selebar-lebarnya (double.infinity).
  final double? width;

  /// Lebar ketebalan border tombol, biasanya digunakan saat outlineMode aktif.
  final double? borderWidth;

  /// The size of text button (Ukuran font khusus untuk teks di dalam tombol).
  final double? fontSize;

  /// Border radius of the button (Konfigurasi sudut batas untuk lengkungan custom, jika tidak ada fallback ke radiusValue).
  final BorderRadiusGeometry? borderRadius;

  /// The radius of the button shape (Nilai double standar untuk melengkungkan setiap sudut tombol). Default: 8.
  final double radiusValue;

  /// Elevation value of button (Tingkat elevasi (bayangan) dari widget material tombol tersebut).
  final double? elevation;

  /// Leading icon inside button (Ikon bawaan berupa Material IconData untuk ditampilkan).
  final IconData? icon;

  /// Leading icon with Widget (Ikon custom berbentuk widget yang lebih leluasa dari tipe data IconData).
  final Widget? leading;

  /// Font weight text and icon inside button (Ketebalan huruf label dan ikon di dalam tombol).
  final FontWeight? fontWeight;

  /// Ruang kosong di sisi luar (margin) dari keseluruhan widget Container pembungkus tombol.
  final EdgeInsetsGeometry? margin;

  /// Ruang kosong di sisi dalam (padding) dari komponen teks label tombol.
  final EdgeInsetsGeometry? padding;

  /// Width of button (Konfigurasi pembungkusan. Jika diset ke `true`, tombol hanya akan membungkus seluas dari konten dalamnya saja tanpa memenuhi lebar maksimal).
  final bool wrapContent;

  /// Change style button to outline mode (Flag indikator. Jika `true` maka tombol akan memiliki warna latar belakang transparan/tema latar dan memakai warna `color` untuk border saja).
  final bool outlineMode;

  /// Widget inside the button (Komponen child kustom yang ditempel ke elemen dalam, meski tidak selalu digunakan dalam implementasi ElevateButton.icon dasar ini).
  final Widget? child;

  /// The option to change button color (Konfigurasi opsional untuk menggunakan gradient warna (degradasi warna jamak) ketimbang color solid polos pada background tombol).
  final Gradient? gradient;

  /// Wether the button is can be clicked or not (Status indikator apakah tombol tersebut dapat diklik. Apabila bernilai `false`, maka tombol nonaktif (disabled)).
  final bool enabled;

  /// Wether the button is in loading state or not (Status indikator jika aplikasi sedang memuat proses. Jika `true`, teks akan diganti dengan elemen loading lingkaran kecil (CircularProgressIndicator)).
  final bool isLoading;

  /// Meng-override proses rendering pembentukan Widget pada framework.
  @override
  Widget build(BuildContext context) {
    // Membungkus sebuah tombol di dalam Container untuk memberikan konfigurasi tambahan seperti lebar, margin, atau efek degradasi yang tidak disupport dasar tombol Flutter.
    return Container(
      // Jika mode wrapContent = true, biarkan ukuran tombol seukuran konten child, jika false gunakan lebar spesifik [width] dari constructor (default infinity).
      width: wrapContent ? null : width,
      height: wrapContent ? null : height,
      // Menerapkan margin dari argumen.
      margin: margin,
      // Menyuntikkan dekorasi BoxDecoration untuk efek custom (terutama terkait gradasi warna latar belakang Container dan radius).
      decoration: BoxDecoration(
        gradient: gradient, // Menerapkan gradient jika ada nilai parameternya.
        borderRadius: borderRadius ?? BorderRadius.circular(radiusValue), // Set border radius menggunakan variabel borderRadius, jika tak ada gunakan radiusValue.
      ),
      // Menerapkan widget tombol jenis ElevatedButton lengkap dengan ikon pada framwork Flutter versi dasar.
      child: ElevatedButton.icon(
        // Bagian argumen icon menggunakan Widget khusus dari Visibility
        icon: Visibility(
          visible: leading != null || icon != null, // Menampilkan ikon hanya jika leading atau icon bernilai tak null.
          // Menampilkan leading widget kalau ada, jika null maka gunakan widget Icon() standar.
          child: leading ??
              Icon(
                icon,
                // Logika Pewarnaan Ikon: Jika outlineMode, ikon diberi warna `color`. Jika tidak, diberi warna putih default, atau diset secara eksplisit.
                color: iconColor ?? (outlineMode ? color : Colors.white),
              ),
        ),
        // Bagian argument penanganan klik: hanya dapat diproses apabila tombol enabled dan tak dalam proses isLoading.
        onPressed: (enabled && !isLoading) ? onPressed : null,
        // Dekorasi styling elemen dasar dari tombol menggunakan fungsi ElevatedButton.styleFrom.
        style: ElevatedButton.styleFrom(
          elevation: elevation, // Men-set bayangan/elevasi komponen visual.
          // Pengaturan warna latar dari ElevatedButton (dibedakan dengan gradient container induk):
          // Jika gradient aktif, jadikan background color tombol utama transparan, agar gradasi latar belakang Container kelihatan.
          // Jika outlineMode aktif, maka background mengikuti warna background scaffold framework (warna layar belakang aplikasi).
          // Jika mode solid, pakaikan warna `color` spesifik.
          backgroundColor: gradient != null
              ? Colors.transparent
              : outlineMode
                  ? Theme.of(context).scaffoldBackgroundColor
                  : color,
          // Mengatur konfigurasi padding tombol jika memiliki/tidak ikon.        
          padding: (icon != null || leading != null)
              ? const EdgeInsets.symmetric(horizontal: 10, vertical: 10)
              : const EdgeInsets.fromLTRB(0, 10, 10, 10),
          // Memodifikasi format bentuk tombol menggunakan border yang dilengkungkan pada RoundedRectangleBorder.
          shape: RoundedRectangleBorder(
            borderRadius: borderRadius ?? BorderRadius.circular(radiusValue), // Melengkungkan sudut frame bentuknya.
            // Konfigurasi garis luar outline.
            side: BorderSide(
              // Jika enabled dan menggunakan outlineMode, gunakan borderColor dan color.
              // Namun jika disabled atau solidMode, biarkan pinggiran border side disembunyikan pakai warna transparan.
              color: enabled
                  ? outlineMode
                      ? borderColor ?? color
                      : borderColor ?? Colors.transparent
                  : Colors.transparent,
              width: borderWidth ?? 1.5, // Ketebalan outline, default 1.5.
            ),
          ),
        ),
        // Widget label dari konten tombol, dibungkus Container untuk kontrol styling tambahan pada child-nya.
        label: Container(
          padding: padding, // Padding kustom untuk container label khusus ini.
          // Menggunakan FittedBox sebagai child tunggal untuk membatasi ruang komponen label agar tulisan teksnya melakukan auto resize mengecil (Scale down) ketika container-nya tidak memiliki cukup lebar.
          child: FittedBox(
            fit: BoxFit.scaleDown, // Teks yang melewati batas ruang akan di zoom in/scale down supaya muat.
            // Memeriksa status loading. Jika iya, tampilkan indikator melingkar (CircularProgressIndicator).
            child: isLoading
                ? const SizedBox(
                    height: 20, // Memperkecil tinggi dari widget loading supaya sesuai letak dalam tombol.
                    width: 20, // Memperkecil lebar widget loading.
                    child: CircularProgressIndicator(
                      strokeWidth: 2, // Ketebalan lingkaran loader.
                      color: Colors.white, // Indikator loader diset warna putih.
                    ),
                  )
                // Sebaliknya (tidak sedang loading), tampilkan widget teks label tombol reguler.
                : Text(
                    text ?? '', // Munculkan teks stringnya.
                    textAlign: TextAlign.center, // Perataan tengah pada widget teks.
                    // Set styling tulisan dengan template subtitle4 dan modifikasi tertentu.
                    style: context.typography.subtitle4.copyWith(
                      fontSize: fontSize,
                      fontWeight: fontWeight,
                      // Logika kontrol warna khusus teks: jika disable, teks menjadi warna abu-abu agak redup.
                      // Jika aktif dan solid: textColor jika ada, jika tidak warna putih.
                      // Jika aktif dan outline mode: textColor atau color outline spesifiknya.
                      color: (!enabled)
                          ? Colors.grey.shade400
                          : textColor ??
                              (outlineMode ? color : textColor ?? Colors.white),
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}
