#culture="en-US"
ConvertFrom-StringData @'
  General_Success                     = Exit script with 0

  InitLocale_General_echo_1           = System automatically set the language for the script to
  InitLocale_General_echo_2           = .
  InitLocale_General_prompt           = Do you want to change the language to else?
  InitLocale_List_echo                = Currently available languages:
  InitLocale_Replace_prompt           = Write language code. Press enter/return key to keep the language
  InitLocale_Replace_success          = Successfuly changed the script language to

  LocaleTable_cultureCode             = Language Code
  LocaleTable_descEn                  = English Name
  LocaleTable_descLoc                 = Local Name
  LocaleTable_contributors            = Contributors

  InitScript_echo                     = Do you want to initialize script (Windows requires to run as admin)? (y/n)
  InitScript_success                  = Script initialized successfully. Please rerun the script normally (without running as admin)

  GetOS_IsWindows_echo                = You are using Windows
  GetOS_IsLinux_echo                  = You are using Linux
  GetOS_IsMac_echo                    = You are using macOS
  GetOS_Unknown_e2                    = You are using an unknown OS, please use a supported OS: Windows, Linux, or macOS

  GetAdmin_IsWindows_success          = Script is running as administrator
  GetAdmin_IsWindows_e1               = Script is not running as administrator, please to make sure to run as administrator

  GetNotRoot_General_success          = Script is not running as root
  GetNotRoot_General_e1               = Script is running as root, please to make sure to run as non-root

  GetAdminNegate_IsWindows_e1         = Script is running as administrator, please to make sure to not run as administrator
  GetAdminNegate_IsWindows_success    = Script is not running as administrator

  CheckInternet_General_echo          = Checking if internet connected
  CheckInternet_General_success       = Internet is available
  CheckInternet_General_e6            = Internet is not available

  GetModule_General_echo              = Checking if modules are installed...
  GetModule_Module_Installed_success  = is installed
  GetModule_Module_Installed_e3       = is not installed, installing...

  OutFile_General_echo                = Creating buildInit_success file
  OutFile_General_success             = buildInit_success file created successfully

  LintFile_Init                       = Linting PowerShell scripts using Invoke-ScriptAnalyzer in the current directory recursively
  LintFile_Warning                    = Invoke-ScriptAnalyzer found warning/s in one or more scripts. Check lintResult.txt for more information
  LintFile_Success                    = Invoke-ScriptAnalyzer found no warning in all scripts
  LintFile_FileRemoved                = Removed lintResult.txt file

  Beautify_Init                       = Beautifying PowerShell scripts using PowerShell-Beautifier in the current directory recursively
  Beautify_Success                    = PowerShell-Beautifier formatted all scripts successfully
'@
