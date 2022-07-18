#culture="id-ID"
ConvertFrom-StringData @'
  General_Success                     = Keluar dari skrip dengan kode 0
  General_Answer                      = Jawaban

  InitLocale_General_echo_1           = Sistem otomatis atur bahasa skrip ke
  InitLocale_General_echo_2           = .
  InitLocale_General_prompt           = Apakah kamu ingin mengubah ke bahasa lainnya?
  InitLocale_List_echo                = Bahasa yang tersedia sekarang:
  InitLocale_Replace_prompt           = Tulis kode bahasa. Tekan tombol Enter/Return untuk membiarkan pengaturan
  InitLocale_Replace_success          = Berhasil mengubah bahasa skrip menjadi

  LocaleTable_cultureCode             = Kode Bahasa
  LocaleTable_descEn                  = Nama Inggris
  LocaleTable_descLoc                 = Nama Asal
  LocaleTable_contributors            = Kontributor

  InitScript_echo                     = Apakah Anda ingin menginisialisasi skrip (Windows perlu dijalankan sebagai admin)? (y/n)
  InitScript_success                  = Skrip berhasil diinisialisasi.Harap jalankan kembali skrip secara normal (tanpa berjalan sebagai admin)

  GetOS_IsWindows_echo                = Anda menggunakan Windows
  GetOS_IsLinux_echo                  = Anda menggunakan Linux
  GetOS_IsMac_echo                    = Anda menggunakan macOS
  GetOS_Unknown_e2                    = Anda menggunakan OS yang tidak diketahui, silakan gunakan OS yang didukung: Windows, Linux, atau macOS

  GetAdmin_IsWindows_success          = Skrip sedang berjalan sebagai administrator
  GetAdmin_IsWindows_e1               = Skrip tidak berjalan sebagai administrator, harap pastikan untuk berjalan sebagai administrator

  GetNotRoot_General_success          = Skrip tidak berjalan sebagai root
  GetNotRoot_General_e1               = Skrip sedang berjalan sebagai root, harap pastikan untuk berjalan sebagai non-root

  GetAdminNegate_IsWindows_e1         = Skrip sedang berjalan sebagai administrator, harap pastikan untuk tidak berjalan sebagai administrator
  GetAdminNegate_IsWindows_success    = Skrip tidak berjalan sebagai administrator

  CheckInternet_General_echo          = Memeriksa jika internet terhubung
  CheckInternet_General_success       = Internet tersedia
  CheckInternet_General_e6            = Internet tidak tersedia

  GetModule_General_echo              = Memeriksa apakah modul yang diperlukan telah diinstal...
  GetModule_Module_Installed_success  = terinstal
  GetModule_Module_Installed_e3       = belum terinstal, menginstal...

  OutFile_General_echo                = Membuat berkas buildInit_success
  OutFile_General_success             = Berkas buildinit_success sukses dibuat

  LintFile_Init                       = Melakukan pengecekan skrip PowerShell menggunakan Invoke-ScriptAnalyzer di direktori saat ini secara rekursif
  LintFile_Warning                    = Invoke-ScriptAnalyzer menemukan peringatan dalam satu atau lebih skrip. Periksa lintResult.txt untuk informasi lebih lanjut
  LintFile_Success                    = Invoke-ScriptAnalyzer tidak menemukan peringatan di semua skrip
  LintFile_FileRemoved                = Berkas lintresult.txt dihapus

  Beautify_Init                       = Mengformat skrip PowerShell menggunakan PowerShell-Beautifier di direktori saat ini secara rekursif
  Beautify_Success                    = PowerShell-Beautifier sukses memformat semua skrip
'@
