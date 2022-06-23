#culture=id-ID
ConvertFrom-StringData @'
    InitLocale_General_echo_1   = 🌐 Sistem otomatis atur bahasa skrip ke
    InitLocale_General_echo_2   = .
    InitLocale_General_prompt   = Apakah kamu ingin mengubah ke bahasa lainnya?
    InitLocale_List_echo        = Bahasa yang tersedia sekarang:
    InitLocale_Replace_prompt   = 🔤 Tulis kode bahasa. Tekan tombol Enter/Return untuk membiarkan pengaturan
    InitLocale_Replace_success  = ✅ Berhasil mengubah bahasa skrip menjadi

    LocaleTable_cultureCode     = Kode Bahasa
    LocaleTable_descEn          = Nama Inggris
    LocaleTable_descLoc         = Nama Asal
    LocaleTable_contributors    = Kontributor

    Header_GeneralInfo          = Informasi Umum
    Header_Customizations       = Kustomisasi
    Header_Intro                = Pengantar
    Header_Cards                = Kartu
    Header_Staff_1              = Staf Pertama
    Header_Staff_2              = Staf Kedua
    Header_Staff_3              = Staf Ketiga
    Header_Staff_4              = Staf Keempat
    Header_Staff_5              = Staf Kelima

    Question_Edition_Title      = 🔤 Judul edisi
    Question_Edition_Emoji      = 😄 Simbol/emoji edisi, Enter untuk melewati
    Question_Edition_IsSingle   = ❓ Apakah edisi hanya mencakup satu judul? Default, n (y/n)
    Question_Edition_Count      = 🔢 Limit balasan (reply), Default, 100
    Question_Edition_Start      = 📆 Tanggal mulai, Format, YYYY-MM-DD; Contoh:
    Question_Edition_End        = 📆 Tanggal selesai, Format, YYYY-MM-DD; Contoh:
    Question_Edition_Staff      = 👤 Total staf bergabung, Default, 1

    Question_Locale_Set         = 🌐 Format judul mana yang kamu utamakan? Default, romaji (romaji/english)
    Question_Locale_success     = ✅ Berhasil memilih format judul menggunakan:

    Question_Banner_Uri         = 🖼️  Link gambar banner
    Question_Banner_Title       = 🔤 Judul karya yang digunakan di banner
    Question_Banner_Creator     = 👤 Nama pengguna MAL pembuat banner, tanpa simbol @

    Question_Color              = 🖌️  Kode warna hex untuk thread dengan simbol #, Contoh, #FFFFFF; Default, #000000
    Question_DarkMode           = 🌙 Tampilkan peringatan mode gelap? Default, y (y/n)

    Question_ID_Custom          = 🔗 Masukkan tautan kustom kamu

    Question_Intro_GifUrl       = 🖼️  Tautan gambar GIF untuk teks pengantar
    Question_Intro_Text         = ✏️  Tuliskan teks pengantar. Gunakan {{ dan }} pada awal dan akhir teks yang kamu ingin warnai, beserta ^@ untuk membuat baris baru

    Prompt_ToCopy               = 📋 Silakan pilih dan salin hasil:
    Prompt_MALId_Insert         = 🔢 Ketik nomor ID MAL karya, ketik 0 untuk memasukkan secara manual
    Prompt_Move_Section         = ⌨️  Tekan tombol apapun untuk pindah ke bagian selanjutnya
    Prompt_Exit_Script          = ⌨️  Tekan tombol apapun untuk keluar dari skrip

    Generate_Title_Success      = ✅ Berhasil membuat judul
    Generate_Intro_Success      = ✅ Berhasil membuat teks pengantar sebagai:
    Generate_BBCode_Success     = ✅ Berhasil membuat teks post utama
    Generate_GFXRequest_Success = ✅ Berhasil membuat post Pusat Permintaan GFX/Pengiriman

    Attention_File_Created_1    = 💁 Kami juga sudah menyimpan berkas yang digenerasi otomatis ke
    Attention_File_Created_2    = , mohon diperiksa.

    Selected_Banner_Title       = ✅ Berhasil mengambil penamaan judul resmi dari MAL untuk banner, yakni:
    Selected_Card_Title         = ✅ Berhasil mengambil penamaan judul resmi dari MAL untuk kartu, yakni:

    Echo_ID_Custom              = Kamu memilih 0 untuk penggunaan tautan kustom. Kami menerima: 1) MAL - anime, manga; 2) AniList - manga; 3) VNDB - Visual Novels; 4) IGDB - Game; 5) Wikipedia - Umum

    Staff_Username              = 👤 Nama pengguna MAL, tanpa simbol @
    Staff_Nickname              = 📛 Nama panggilan
    Staff_Limit_Type            = ⚠️  Jenis limit, Default, role (role/any)
    Staff_Limit_Any             = 🔢 Limit kartu untuk seluruh (any) peran
    Staff_Limit_Staff           = 🔢 Limit kartu untuk para staf
    Staff_Limit_Member          = 🔢 Limit kartu untuk para member
    Staff_Limit_Total           = 🔢 Total kartu yang dapat dipilih, Maksimum, 9
    Staff_Cards_Url             = 🖼️  Tautan gambar kartu
    Staff_Cards_Title           = 🔤 Judul karya yang digunakan di kartu

    Invalid_Staff_Amount        = ❌ Jumlah staff tidak sah, otomatis akan diatur menjadi 5
    Invalid_Card_Amount         = ❌ Jumlah kartu tidak sah, otomatis akan diatur menjadi 9
'@
