# zimbra-monitor-queue

Repositori ini berisi kumpulan skrip *bash shell* yang berguna untuk memantau antrian email (`mailq`) dan *log* otentikasi Zimbra. Jika terdeteksi anomali, skrip ini akan mengirimkan notifikasi ke Telegram.

## Fitur

* **Pemantauan `mailq`**: Skrip `check-mail-queue.sh` secara berkala memeriksa *queue length* email yang tertunda di `mailq`. Jika jumlahnya melebihi *threshold* yang ditentukan, skrip akan mengirimkan notifikasi ke Telegram.
* **Pemantauan *failed login* Zimbra**: Skrip `check-mail-queue.sh` memantau *authentication logs* Zimbra untuk mendeteksi upaya *login* yang gagal. Jika ada terlalu banyak upaya *login* yang gagal dari alamat IP yang sama dalam periode waktu tertentu, skrip akan mengirimkan notifikasi ke Telegram beserta daftar alamat IP yang mencurigakan.

## Cara Penggunaan

1. **Prasyarat:**
    * Pastikan Anda telah menginstal `bash`, `mailq`, `grep`, `awk`, dan `curl` di sistem Anda.
    * Anda perlu membuat *bot* Telegram dan mendapatkan *token*-nya.
    * Anda perlu mendapatkan *chat ID* Telegram tempat Anda ingin menerima notifikasi.
2. **Konfigurasi:**
    * Salin contoh konfigurasi `config.example.sh` menjadi `config.sh` dan sesuaikan nilainya dengan pengaturan Anda.
    * Atur *token* Telegram, *chat ID*, *threshold*, dan pengaturan lainnya di `config.sh`.
3. **Menjalankan Skrip:**
    * Jalankan skrip `check-mail-queue.sh` dan `check-mail-queue.sh` secara manual atau atur agar dijalankan secara berkala menggunakan `cron`.

Kontribusi
Silakan kirim pull request jika Anda ingin berkontribusi pada repositori ini.

Informasi Tambahan
Skrip ini dirancang untuk berjalan di sistem Linux yang menjalankan Zimbra.
Pastikan Anda memiliki izin yang cukup untuk mengakses mailq dan log Zimbra.
Gunakan skrip ini dengan hati-hati dan pahami risiko yang terkait sebelum menggunakannya di lingkungan produksi.
