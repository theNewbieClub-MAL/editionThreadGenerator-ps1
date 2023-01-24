#culture=ms-MY
ConvertFrom-StringData @'
  InitLocale_General_echo_1   = 🌐 Sistem menetapkan bahasa skrip secara automatik ke
  InitLocale_General_echo_2   = .
  InitLocale_General_prompt   = Adakah anda mahu menukar ke bahasa lain?
  InitLocale_List_echo        = Bahasa tersedia sekarang:
  InitLocale_Replace_prompt   = 🔤 Tulis kod bahasa. Tekan kekunci Enter/Return untuk membiarkan tetapan
  InitLocale_Replace_success  = ✅ Berjaya mengubah bahasa skrip ke dalam

  LocaleTable_cultureCode     = Kode Bahasa
  LocaleTable_descEn          = Nama Inggeris
  LocaleTable_descLoc         = Nama Asal
  LocaleTable_contributors    = Penyumbang

  Header_GeneralInfo          = Maklumat Umum
  Header_Customizations       = Penyesuaian
  Header_Intro                = Pengenalan
  Header_Cards                = Kad
  Header_Card                 = Kad
  Header_Staff_1              = Kakitangan Pertama
  Header_Staff_2              = Kakitangan Kedua
  Header_Staff_3              = Kakitangan Ketiga
  Header_Staff_4              = Kakitangan Keempat
  Header_Staff_5              = Kakitangan Kelima

  Question_Load_JSON_Session  = ❓ Kami menemui sesi terakhir disimpan pada direktori. Adakah anda mahu memuatkan fail simpan (y) atau buat fail baharu (n)? Lalai, n (y/n)

  Question_Edition_Title      = 🔤 Tajuk edisi
  Question_Edition_Emoji      = 😄 Simbol/emoji edisi, Enter untuk melangkau
  Question_Edition_IsSingle   = ❓ Apa edisi hanya merangkumi satu tajuk? Lalai, n (y/n)
  Question_Edition_Count      = 🔢 Had balasan (reply), Lalai, 100
  Question_Edition_Start      = 📆 Tarikh mula, Format, YYYY-MM-DD; Contoh,
  Question_Edition_End        = 📆 Tarikh siap, Format, YYYY-MM-DD; Contoh,
  Question_Edition_Default    = ; Lalai,
  Question_Edition_Staff      = 👤 Jumlah kakitangan yang mengambil bahagian, Lalai, 1

  Question_Locale_Set         = 🌐 Format tajuk mana yang anda keutamaan? Lalai, romaji (romaji/english)
  Question_Locale_success     = ✅ Berjaya memilih format tajuk menggunakan:

  Question_Banner_Uri         = 🖼️  Pautan imej spanduk
  Question_Banner_Title       = 🔤 Tajuk kerja yang digunakan pada sepanduk
  Question_Banner_Creator     = 👤 Nama pengguna MAL pembuat spanduk, tanpa simbol @

  Question_Color              = 🖌️  Kod warna hex untuk thread dengan simbol #, Contoh, #FFFFFF; Lalai, #000000
  Question_DarkMode           = 🌙 Tunjukkan amaran mod gelap? Lalai, y (y/n)

  Question_ID_Custom          = 🔗 Masukkan pautan tersuai anda

  Question_Intro_GifUrl       = 🖼️  Pautan imej gif untuk teks pengenalan
  Question_Intro_Text         = ✏️  Tulis teks pengenalan menggunakan aplikasi editor yang kami lancarkan. Simpan fail, keluar dari aplikasi, kemudian tekan enter/return untuk meneruskan ke langkah seterusnya
  Question_Intro_Text_Header  = # Untuk menyerlahkan teks, sertakan {{ dan }} dalam teks yang ingin anda serlahkan.
  Question_Intro_Text_Error   = ❌ Anda tidak menulis sebarang teks. Anda boleh membetulkan teks kemudian dalam fail savefile yang kami buat, namun, anda perlu mempunyai pengetahuan asas tentang JSON.
  Question_Intro_Text_NoProg  = ❌ Kami tidak menemui sebarang editor teks yang dipasang pada sistem anda, sila pasang satu dan cuba lagi.

  Prompt_ToCopy               = 📋 Sila pilih dan salin hasilnya:
  Prompt_MALId_Insert         = 🔢 Taipkan nombor ID Karya MAL, ketik 0 untuk memasukkan secara tersuai
  Prompt_Move_Section         = ⌨️  Tekan butang mana -mana untuk bergerak ke bahagian seterusnya
  Prompt_Exit_Script          = ⌨️  Tekan butang mana -mana untuk keluar dari skrip

  Generate_Title_Success      = ✅ Berjaya membuat tajuk
  Generate_Intro_Success      = ✅ Berjaya membuat teks pengenalan sebagai:
  Generate_BBCode_Success     = ✅ Berjaya membuat teks pos utama
  Generate_GFXRequest_Success = ✅ Berjaya membuat pos Pusat Permintaan GFX/Penghantaran

  Attention_File_Created_1    = 💁 Kami juga telah menyimpan fail yang dihasilkan secara automatik kepada
  Attention_File_Created_2    = , sila periksa.

  Selected_Banner_Title       = ✅ Berjaya mengambil penamaan gelaran rasmi dari MAL ke spanduk, iaitu:
  Selected_Card_Title         = ✅ Berjaya mengambil penamaan gelaran rasmi dari MAL ke kad, iaitu:

  Echo_ID_Custom              = Anda memilih 0 untuk penggunaan pautan tersuai. Kami terima: 1) MAL - anime, manga; 2) AniList - manga; 3) VNDB - Visual Novels; 4) IGDB - Permainan; 5) Wikipedia - Umum

  Staff_Username              = 👤 Nama pengguna MAL, tanpa simbol @
  Staff_Nickname              = 📛 Nama samaran, Lalai,
  Staff_Limit_Type            = ⚠️  Jenis had, Lalai, role (role/any)
  Staff_Limit_Any             = 🔢 Had kad untuk semua (any) peranan
  Staff_Limit_Staff           = 🔢 Had kad untuk kakitangan
  Staff_Limit_Member          = 🔢 Had kad untuk ahli kelab
  Staff_Limit_Total           = 🔢 Jumlah kad yang boleh dipilih, Maksimum, 9
  Staff_Allows_Slip_Card      = ❓ Apa kakitangan membolehkan slip kad dapat digunakan? Lalai, y (y/n)
  Staff_Cards_Url             = 🖼️  Pautan imej kad
  Staff_Cards_Title           = 🔤 Tajuk kerja yang digunakan pada kad

  Invalid_Staff_Amount        = ❌ Bilangan kakitangan tidak sah, secara automatik akan diatur hingga 5
  Invalid_Card_Amount         = ❌ Bilangan kad yang tidak sah, akan diatur secara automatik hingga 9
  Invalid_Slip                = ❌ Kakitangan ini mungkin tidak menyediakan perkhidmatan slip kad ATAU kartu sampel belum dibuat
'@
