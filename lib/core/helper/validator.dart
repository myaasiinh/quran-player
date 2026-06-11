import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Kelas tersegel [Validate] yang menyediakan fungsi validasi dasar.
/// 
/// Kelas ini tidak dapat diinstansiasi atau diwarisi secara langsung.
/// Tujuannya adalah untuk mengelompokkan logika validasi umum secara modular.
sealed class Validate {
  /// Mengembalikan sebuah [FormFieldValidator] berbasis ekspresi reguler (Regex).
  /// 
  /// [regex] adalah pola reguler yang harus dicocokkan dengan nilai input dari field.
  /// [err] adalah pesan kesalahan yang akan dikembalikan apabila nilai tidak sesuai dengan pola.
  static FormFieldValidator<String> regex({
    required RegExp regex,
    required String err,
  }) {
    // Mengembalikan fungsi closure (validator) yang menerima parameter [v] berupa input pengguna
    return (v) {
      // Memeriksa apakah input teks tidak null dan sesuai dengan pola Regex yang telah ditetapkan
      if (v != null && regex.hasMatch(v)) {
        // Mengembalikan nilai null jika validasi berhasil (yang berarti tidak ada error)
        return null;
      } else {
        // Mengembalikan string pesan error jika inputan gagal divalidasi
        return err;
      }
    };
  }
}

/// Kelas statis [Validator] yang berisi sekumpulan fungsi atau metode  
/// untuk memudahkan validasi input form khusus, seperti validasi email, password, dll.
class Validator {
  /// Menggabungkan beberapa [FormFieldValidator] bertipe [T] ke dalam satu validator tunggal.
  /// 
  /// Cara kerjanya adalah dengan memproses setiap list [validators] secara berurutan.
  /// Jika terdapat satu validator yang gagal memenuhi syarat, fungsi ini akan langsung berhenti
  /// lalu mengembalikan pesan error pertama yang tertangkap dari kumpulan validator tersebut.
  static FormFieldValidator<T> list<T>(List<FormFieldValidator<T>> validators) {
    // Mengembalikan fungsi closure yang menangkap input kandidat yaitu [valueCandidate]
    return (valueCandidate) {
      // Melakukan perulangan di setiap fungsi validator pada list
      for (final validator in validators) {
        // Menyimpan hasil pemanggilan validasi kandidat untuk dicek kondisinya
        final validatorResult = validator.call(valueCandidate);
        // Apabila ada hasil pengembalian yang bukan null (berarti terdapat error validasi)
        if (validatorResult != null) {
          // Fungsi berhenti lalu mengembalikan string message dari error validator ini
          return validatorResult;
        }
      }
      // Mengembalikan nilai null apabila data lolos di semua tahapan validasi yang dilist
      return null;
    };
  }

  /// Validator dasar untuk memastikan bahwa input teks tidak dibiarkan kosong (wajib diisi).
  /// 
  /// Anda bisa memberikan string [message] pesan kesalahan yang bersifat opsional/kustom.
  /// Apabila dibiarkan kosong, ia menggunakan pesan terjemahan bawaan dari `txt_field_cannot_be_empty`.
  static FormFieldValidator<String> required({String? message}) {
    // Fungsi menerima nilai string parameter masukan dari widget TextField
    return (value) {
      // Mengecek apakah string null, atau setelah spasi kosongnya dihapus (trim) malah tidak ada hurufnya
      if (value == null || value.trim().isEmpty) {
        // Kembalikan error default bila message null, atau kembalikan message itu sendiri
        return message ?? 'txt_field_cannot_be_empty'.tr;
      }
      // Tidak ada error, berarti inputan pengguna valid
      return null;
    };
  }

  /// Validator yang memastikan bahwa data format penulisan nama diisi dengan logis dan sesuai kaidah.
  /// 
  /// Format penulisan hanya membolehkan karakter huruf abjad dan beberapa tanda baca umum
  /// seperti titik, koma, spasi, serta tanda hubung yang sering ada di penamaan gelar atau marga.
  /// [err] adalah teks peringatan error modifikasi yang opsional.
  static FormFieldValidator<String> name({String? err}) {
    // Mendefinisikan regulasi format regex untuk kelayakan string nama orang
    final regex = RegExp(
      r"^[a-zA-Z]+(([',. -][a-zA-Z ])?[a-zA-Z]*)*[a-zA-Z]\s*$",
    );
    // Menggunakan pemanggil Validate.regex untuk memproses pola regex di atas
    return Validate.regex(regex: regex, err: err ?? 'txt_valid_name'.tr);
  }

  /// Validator khusus untuk memastikan bahwa penulisan format alamat surel (email) adalah valid.
  /// 
  /// [err] adalah parameter untuk mengubah pesan teks yang ditimbulkan apabila salah (opsional).
  static FormFieldValidator<String> email({String? err}) {
    // Mendefinisikan regulasi regex untuk struktur surel standar seperti namasaya@domain.com
    final regex = RegExp(r'^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+');
    // Meneruskan pemrosesan regex kepada subkelas Validate.regex beserta keterangan err
    return Validate.regex(regex: regex, err: err ?? 'txt_valid_email'.tr);
  }

  /// Validator khusus mengecek apakah pola penulisan angka relevan dengan nomor telepon Indonesia.
  /// 
  /// Nomor diharuskan berawalan '+628', '628', atau '08' yang disusul rentang angka bebas 
  /// hingga mencapai panjang digit minimal dan maksimal sesuai provider telepon negara (7 - 11 digit postfix).
  /// [err] adalah keterangan error kustom jika format menyimpang.
  static FormFieldValidator<String> phone({String? err}) {
    // Menetapkan formula regular ekspresi untuk memverifikasi pola telepon seluler
    final regex = RegExp(r'^(\+628|628|08)[1-9][0-9]{7,11}$');
    // Memanggil verifikator Regex dan memberikan keterangan hasil pengecekan tersebut
    return Validate.regex(regex: regex, err: err ?? 'txt_valid_phone'.tr);
  }

  /// Validator khusus memeriksa batas persyaratan pembentukan kata sandi (password).
  /// 
  /// Secara setelan awal (default) regex ini hanya akan mendeteksi apakah isian password 
  /// telah mencapai panjang minimum yaitu sebanyak 8 karakter.
  /// [err] string peringatan jika user belum memenuhi syarat tersebut.
  static FormFieldValidator<String> password({String? err}) {
    // Regex wajib berisi minimal 8 karakter sembarang berturut-turut
    final regex = RegExp(r'^.*(?=.{8,}).*$');

    /// Berikut ini merupakan kumpulan komentar dokumentasi sebagai contoh penulisan kriteria sandi lebih ketat:
    /// Memiliki 8 karakter dengan minimal 1 Huruf Besar, 1 Huruf Kecil, 1 angka
    // RegExp regex = RegExp(r"^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)[A-Za-z\d!@#$%^&*()_+=-{};:',<.>?`\/\|~-]{8,}$");

    // Minimal 8 karakter, wajib memiliki huruf besar, wajib ada huruf kecil dan ada nomor (sandi standar):
    // RegExp regex = RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)[a-zA-Z\d]{8,}$');

    // Minimal 8 karakter, huruf besar, huruf kecil, dan nomor yang menolerir simbol baca tertentu:
    // RegExp regex = RegExp(r'(?=.*[a-z])(?=.*[A-Z])(?=.*\d)[A-Za-z\d!@#$%^&*()_+=-{};:'",<.>?`\/\|~-]{8,}');

    // Paling ketat, yaitu perpaduan antara huruf besar, kecil, nomor, dan simbol khusus (wajib memiliki semua):
    // RegExp regex = RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[!@#$%^&*()_+=-{};:'",<.>?`\/\|~-])[A-Za-z\d!@#$%^&*()_+=-{};:'",<.>?`\/\|~-]{8,}$');

    // Menjalankan pengecekan format Regex untuk string password dan memberitahukan error.
    return Validate.regex(regex: regex, err: err ?? 'txt_valid_password'.tr);
  }

  /// Validator untuk mendeteksi agar masukan karakter bukan sekedar tulisan berisi jarak/spasi putih.
  /// 
  /// Mencegah isian nakal di mana spasi tanpa teks diloloskan. String diwajibkan berupa karakter non-spasi (S).
  /// [err] teks penjelasan error jika ditemukan kejanggalan.
  static FormFieldValidator<String> notEmpty({String? err}) {
    // Regex deteksi bahwa string wajib dimulai dan diakhiri non-spasi secara berangkai
    final regex = RegExp(r'^\S+$');
    // Melakukan evaluasi karakter kosong dari fungsi Validator.regex bawaan
    return Validate.regex(regex: regex, err: err ?? 'txt_valid_notEmpty'.tr);
  }

  /// Validator kustom yang mengecek bahwa kolom ini isinya identik persis dengan sandi awal.
  /// 
  /// Umumnya digunakan pada kasus kolom (Confirm Password).
  /// [password] adalah isian password pada kolom utama (yang sedang dicocokkan).
  static FormFieldValidator<String> confirmPassword(String password) {
    // Menembalikan blok fungsi parameter nilai isian form dari kolom
    return (value) {
      // Kondisi pertama: periksa jika ia null atau kosong. Jika ya, beri peringatan wajib isi
      if (value == null || value.isEmpty) return 'txt_validation_required'.tr;
      // Kondisi kedua: periksa jikalau rentetan karakternya beda (mismatch) dari password referensi
      if (value != password) return 'txt_validation_password_mismatch'.tr;
      // Berhasil lulus (cocok)
      return null;
    };
  }

  /// Validator perbandingan yang memeriksa kesamaan antara input field form 
  /// dengan variabel objek rujukan dari luar secara eksplisit.
  /// 
  /// [sameAs] adalah rujukan nilai objek untuk dipersamakan.
  /// [err] jika kedua pihak tidak persis sama maka tampilkan keterangan ini.
  static FormFieldValidator<String> sameValue({
    required String sameAs,
    String? err,
  }) {
    // Fungsi inline yang cepat mengeksekusi operasi kesetaraan (equality check)
    return (value) =>
        // Pengecekan logika. Apabila `value` beda dengan `sameAs`, eksekusi nilai error, sebaliknya luluskan null.
        value != sameAs ? (err ?? 'txt_field_is_not_same'.tr) : null;
  }
}
