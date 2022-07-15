#culture=de-DE
ConvertFrom-StringData @'
    InitLocale_General_echo_1   = 🌐 Das System hat die Sprache für das Skript automatisch auf
    InitLocale_General_echo_2   = gesetzt.
    InitLocale_General_prompt   = Möchten Sie die Sprache in eine andere ändern?
    InitLocale_List_echo        = Derzeit verfügbare Sprachen:
    InitLocale_Replace_prompt   = 🔤 Sprachcode schreiben. Drücken Sie die Enter/Eingabetaste, um die Sprache beizubehalten.
    InitLocale_Replace_success  = ✅ Die Skriptsprache wurde erfolgreich auf

    LocaleTable_cultureCode     = Sprachcode
    LocaleTable_descEn          = Englischer Name
    LocaleTable_descLoc         = Lokaler Name
    LocaleTable_contributors    = Mitwirkende

    Header_GeneralInfo          = Allgemeine Informationen
    Header_Customizations       = Anpassungen
    Header_Intro                = Einführung
    Header_Cards                = Karten
    Header_Staff_1              = Erster Mitarbeiter
    Header_Staff_2              = Zweiter Mitarbeiter
    Header_Staff_3              = Dritter Mitarbeiter
    Header_Staff_4              = Vierter Mitarbeiter
    Header_Staff_5              = Fünfter Personal

    Question_Edition_Title      = 🔤 Titel der Ausgabe
    Question_Edition_Emoji      = 😄 Emoji ausgeben, Enter zum Überspringen
    Question_Edition_IsSingle   = ❓ Umfasst die Ausgabe nur einen Titel? Standard, n (y/n)
    Question_Edition_Count      = 🔢 Antwortgrenze, Standard, 100
    Question_Edition_Start      = 📆 Startdatum, Format, JJJJ-MM-TT; Beispiel,
    Question_Edition_End        = 📆 Enddatum, Format, JJJJ-MM-TT; Beispiel,
    Question_Edition_Default    = ; Standard,
    Question_Edition_Staff      = 👤 Gesamtzahl der beitragenden Mitarbeiter, Standard, 1; Max, 5

    Question_Locale_Set         = 🌐 Welches Titelformat bevorzugen Sie? Standard, romaji (romaji/english)
    Question_Locale_success     = ✅ Erfolgreich ausgewähltes Titelformat:

    Question_Banner_Uri         = 🖼️  URL des Bannerbildes
    Question_Banner_Title       = 🔤 Titel des auf dem Banner verwendeten Werks
    Question_Banner_Creator     = 👤 MAL-Benutzername des Erstellers des Banners, ohne @-Zeichen

    Question_Color              = 🖌️  Farbe des Thread in Hex-Code mit #-Zeichen, Beispiel, #FFFFFF; Standard, #000000
    Question_DarkMode           = 🌙 Warnung vor Dunkelmodus anzeigen? Standard, y (y/n)

    Question_ID_Custom          = 🔗 Eigene URL einfügen

    Question_Intro_GifUrl       = 🖼️  GIF-URL für Einleitungstext
    Question_Intro_Text         = ✏️  Schreiben Sie den Einleitungstext. Verwenden Sie {{ und }} für den Text, den Sie einfärben möchten, und ^@ für eine neue Zeile.

    Prompt_ToCopy               = 📋 Bitte markieren und kopieren Sie das Ergebnis:
    Prompt_MALId_Insert         = 🔢 Geben Sie die MAL-ID des Titels ein, geben Sie 0 für eine benutzerdefinierte Eingabe ein.
    Prompt_Move_Section         = ⌨️  Geben Sie eine beliebige Taste ein, um zum nächsten Abschnitt zu gelangen.
    Prompt_Exit_Script          = ⌨️  Tippen Sie eine beliebige Taste zum Beenden

    Generate_Title_Success      = ✅ Erfolgreich den Titel generiert
    Generate_Intro_Success      = ✅ Erfolgreich generierter Einleitungstext als:
    Generate_BBCode_Success     = ✅ Erfolgreich generierter Hauptbeitrag
    Generate_GFXRequest_Success = ✅ Erfolgreich generierter GFX/Deliverer Anfragen-Ecke Beitrag

    Attention_File_Created_1    = 💁 Wir haben die erzeugte Datei auch unter
    Attention_File_Created_2    = gespeichert, bitte überprüfen Sie es.

    Selected_Banner_Title       = ✅ Erfolgreich den richtigen Titel für das Banner von MAL geholt als:
    Selected_Card_Title         = ✅ Erfolgreich den richtigen Titel für die Karte aus MAL geholt als:

    Echo_ID_Custom              = Sie haben sich für 0 für die benutzerdefinierte ID-Eingabe entschieden. Wir akzeptieren: 1) MAL - Anime, Manga; 2) AniList - Manga; 3) VNDB - Visual Novels; 4) IGDB - Game; 5) Wikipedia - General

    Staff_Username              = 👤 MAL-Benutzername, ohne @-Zeichen
    Staff_Nickname              = 📛 Spitzname
    Staff_Limit_Type            = ⚠️  Grenzwerttyp, Standard, role (role/any)
    Staff_Limit_Any             = 🔢 Kartenlimit für beliebige Rollen
    Staff_Limit_Staff           = 🔢 Kartenlimit für Mitarbeiterrolle
    Staff_Limit_Member          = 🔢 Kartenlimit für reguläre Mitglieder
    Staff_Limit_Total           = 🔢 Insgesamt zu erhaltende Karten, Maximum, 9
    Staff_Allows_Slip_Card      = ❓ Erlaubt der jeweilige Mitarbeiter die Benutzung von Gutscheinen? Standard, y (y/n)
    Staff_Cards_Url             = 🖼️  URL des Kartenbildes
    Staff_Cards_Title           = 🔤 Titel des auf der Karte verwendeten Werks

    Invalid_Staff_Amount        = ❌ Ungültige Personalmenge, automatisch auf 5 gesetzt
    Invalid_Card_Amount         = ❌ Ungültige Kartenmenge, automatisch auf 9 gesetzt
    Invalid_Slip                = ❌ Der Designer erlaubt nicht die Benutzung von Gutscheinen ODER der Muster-Gutschein wurde noch nicht erstellt

'@
