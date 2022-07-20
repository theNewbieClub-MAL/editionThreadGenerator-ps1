#culture="de-DE"
ConvertFrom-StringData @'
  General_Success                     = Drücken Sie 0, um das Skript zu beenden
  General_Answer                      = Antwort

  InitLocale_General_echo_1           = System hat die Sprache automatisch auf
  InitLocale_General_echo_2           = gesetzt.
  InitLocale_General_prompt           = Möchten Sie die Sprache ändern?
  InitLocale_List_echo                = Aktuell verfügbare Sprachen:
  InitLocale_Replace_prompt           = Sprachcode eingeben. Eingabe/return drücken, um die Sprache zu behalten.
  InitLocale_Replace_success          = Erfolgreich Sprache geändert zu

  LocaleTable_cultureCode             = Sprachcode
  LocaleTable_descEn                  = Englischer Name
  LocaleTable_descLoc                 = Lokaler Name
  LocaleTable_contributors            = Mitwirkende

  InitScript_echo                     = Möchten Sie das Skript initialisieren (braucht Administratorrechte bei Windows)? (y/n)
  InitScript_success                  = Skript wurde erfolgreich initialisiert. Bitte führen Sie das Skript erneut aus (ohne Administratorrechte)

  GetOS_IsWindows_echo                = Sie benutzen Windows
  GetOS_IsLinux_echo                  = Sie benutzen Linux
  GetOS_IsMac_echo                    = Sie benutzen macOS
  GetOS_Unknown_e2                    = Sie benutzen ein unbekanntes Betriebssystem, bitte benutzen Sie eines der unterstützten: Windows, Linux, oder macOS

  GetAdmin_IsWindows_success          = Skript wird mit Administratorrechten ausgeführt
  GetAdmin_IsWindows_e1               = Skript wird nicht mit Administratorrechten ausgeführt. Bitte gehen Sie sicher, dass das Skript mit Administratorrechten ausgeführt wird

  GetNotRoot_General_success          = Skript wird ohne Root-Rechte ausgeführt.
  GetNotRoot_General_e1               = Skript wird mit Root-Rechen ausgeführt. Bitte gehen Sie sicher, das Skript ohne Root-Rechte auszuführen

  GetAdminNegate_IsWindows_e1         = Skript wird mit Administratorrechten ausgeführt. Bitte gehen Sie sicher, das Skript nicht mit Administratorrechten auszuführen
  GetAdminNegate_IsWindows_success    = Skript wird nicht mit Administratorrechten ausgeführt

  CheckInternet_General_echo          = Prüfe, ob eine Internetverbindung verfügbar ist
  CheckInternet_General_success       = Internetverbindung verfügbar
  CheckInternet_General_e6            = Internetverbindung nicht verfügbar

  GetModule_General_echo              = Prüfe, ob Module installiert sind...
  GetModule_Module_Installed_success  = installiert
  GetModule_Module_Installed_e3       = nicht installiert, installiere...

  OutFile_General_echo                = Erstelle buildInit_success Datei
  OutFile_General_success             = buildInit_success Datei erfolgreich erstellt

  LintFile_Init                       = Linte PowerShell Skripte mithilfe von Invoke-ScriptAnalyzer rekursiv im aktuellen Verzeichnis
  LintFile_Warning                    = Invoke-ScriptAnalyzer hat eine oder mehrere Warnungen in einem oder mehreren Skripten gefunden. Öffne lintResult.txt für mehr Informationen
  LintFile_Success                    = Invoke-ScriptAnalyzer hat keine Warnungen in jeglichen Skripten gefunden
  LintFile_FileRemoved                = lintResult.txt Datei entfernt

  Beautify_Init                       = Verschönert PowerShell Skripte mithilfe von PowerShell-Beautifier rekursiv im aktuellen Verzeichnis
  Beautify_Success                    = PowerShell-Beautifier hat alle Skripte erfolgreich formatiert
'@
