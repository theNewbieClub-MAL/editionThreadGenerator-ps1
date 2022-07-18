#culture="ms-MY"
ConvertFrom-StringData @'
  General_Success                     = Keluar dari skrip dengan kod 0
  General_Answer                      = Jawapan

  InitLocale_General_echo_1           = Sistem menetapkan bahasa skrip secara automatik ke
  InitLocale_General_echo_2           = .
  InitLocale_General_prompt           = Adakah anda mahu menukar ke bahasa lain?
  InitLocale_List_echo                = Bahasa tersedia sekarang:
  InitLocale_Replace_prompt           = Tulis kod bahasa. Tekan kekunci Enter/Return untuk membiarkan tetapan
  InitLocale_Replace_success          = Berjaya mengubah bahasa skrip ke dalam

  LocaleTable_cultureCode             = Kode Bahasa
  LocaleTable_descEn                  = Nama Inggeris
  LocaleTable_descLoc                 = Nama Asal
  LocaleTable_contributors            = Penyumbang

  InitScript_echo                     = Adakah anda ingin memulakan skrip (Windows perlu dijalankan sebagai pentadbir)? (y/n)
  InitScript_success                  = Skrip berjaya diasaskan. Tolong mulakan skrip kembali secara normal (tanpa berjalan sebagai pentadbir)

  GetOS_IsWindows_echo                = Anda gunakan Windows
  GetOS_IsLinux_echo                  = Anda gunakan Linux
  GetOS_IsMac_echo                    = Anda gunakan macOS
  GetOS_Unknown_e2                    = Anda gunakan OS yang tidak diketahui, sila gunakan OS yang disokong: Windows, Linux, atau MacOS

  GetAdmin_IsWindows_success          = Skrip dijalankan sebagai pentadbir
  GetAdmin_IsWindows_e1               = Skrip tidak dijalankan sebagai pentadbir, sila pastikan untuk dijalankan sebagai pentadbir

  GetNotRoot_General_success          = Skrip tidak dijalankan sebagai root
  GetNotRoot_General_e1               = Skrip berjalan sebagai root, sila pastikan untuk tidak dijalankan sebagai root (non-root)

  GetAdminNegate_IsWindows_e1         = Skrip berjalan sebagai pentadbir, pastikan anda tidak dijalankan sebagai pentadbir
  GetAdminNegate_IsWindows_success    = Skrip tidak dijalankan sebagai pentadbir

  CheckInternet_General_echo          = Periksa sama ada internet disambungkan
  CheckInternet_General_success       = Internet tersedia
  CheckInternet_General_e6            = Internet tidak tersedia

  GetModule_General_echo              = Periksa sama ada modul yang diperlukan telah dipasang...
  GetModule_Module_Installed_success  = dipasang
  GetModule_Module_Installed_e3       = tidak dipasang, pasang...

  OutFile_General_echo                = Buat fail buildInit_success
  OutFile_General_success             = Fail buildinit_success berjaya dibuat

  LintFile_Init                       = Memeriksa skrip PowerShell dengan menggunakan Invoke-ScriptAnalyzer dalam direktori semasa
  LintFile_Warning                    = Invoke-ScriptAnalyzer mendapati amaran dalam satu atau lebih skrip. Semak lintresult.txt untuk maklumat lanjut
  LintFile_Success                    = Invoke-ScriptAnalyzer tidak menemui amaran dalam semua skrip
  LintFile_FileRemoved                = Fail lintresult.txt dipadamkan

  Beautify_Init                       = Format skrip PowerShell menggunakan PowerShell-Beautifier dalam direktori semasa
  Beautify_Success                    = PowerShell-Beautifier berjaya memformat semua skrip
'@
