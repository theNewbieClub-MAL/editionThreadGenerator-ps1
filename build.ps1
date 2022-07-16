#!/usr/bin/env pwsh

# Script taken from github:ryuuganime/animeJson-ps1

# ===============
# Script Metadata
# ===============

$version = "v.0.0.1"

# =====
# Intro
# =====

Clear-Host
Write-Host "Script Builder",$version -ForegroundColor Blue
Write-Host ""

# ===================
# Import Localization
# ===================

$localeName = (Get-Culture).Name

# Write a warning when user used locale that doesn't translated yet.
if (-not (Test-Path -Path ./Translations/$localeName)) {
  Write-Host "Uh-oh. We can not find the localization file for $($localeName) ($((Get-Culture).DisplayName)), so we temporarily replace it to English (US)" -ForegroundColor Red
  Write-Host "You can change the locale in next prompt"
  $localeName = "en-US"
  Write-Host ""
}

Import-LocalizedData -BindingVariable i18n -UICulture $localeName -BaseDirectory ./Translations

Write-Host $i18n.InitLocale_General_echo_1," ",$localeName," (",(Get-Culture -Name $localeName).DisplayName,")","$(if("." -eq $i18n.InitLocale_General_echo_2){"$($i18n.InitLocale_General_echo_2) "} else {" $($i18n.InitLocale_General_echo_2) "})",$i18n.InitLocale_General_prompt -ForegroundColor Yellow -Separator ""
Write-Host ""
Write-Host $i18n.InitLocale_List_echo

# Implement JSON Table instead listing from `Get-ChildItem`.
$i18nIndex = Get-Content ./Translations/index.json
$i18nIndex | ConvertFrom-Json | Format-Table @{ L = $i18n.LocaleTable_cultureCode; E = { $_.cultureCode } },@{ L = $i18n.LocaleTable_descEn; E = { $_. "desc-En" } },@{ L = $i18n.LocaleTable_descLoc; E = { $_. "desc-Loc" } },@{ L = $i18n.LocaleTable_contributors; E = { $_.contributors } }

$changeLocale = Read-Host -Prompt $i18n.InitLocale_Replace_Prompt

if (-not ($changeLocale)) {
  Import-LocalizedData -BindingVariable i18n -UICulture $localeName -BaseDirectory ./Translations
  $changeLocale = $localeName
} elseif ("exit" -eq $changeLocale) {
  Clear-Host
  exit
} else {
  Import-LocalizedData -BindingVariable i18n -UICulture $changeLocale -BaseDirectory ./Translations
}

Write-Host $i18n.InitLocale_Replace_success,$changeLocale -ForegroundColor Green

# ==============
# Core Variables
# ==============

$whoAmI = whoami

# =========
# Core Functions
# =========

function Get-NotRoot {
  if ($whoAmI -ne "root") {
    Write-Host $i18n.GetNotRoot_General_success -ForegroundColor Green
  } else {
    Write-Host $i18n.GetNotRoot_General_e1 -ForegroundColor Red
    exit 1 # User did not run the script as administrator/root
  }
}

function Invoke-Init {
  # ==============================
  # Check if modules are installed
  # ==============================
  Write-Host ""
  Write-Host $i18n.GetModule_General_echo

  # PowerShell Beautifier
  if (Get-InstalledModule -Name PowerShell-Beautifier) {
    Write-Host "github:DTW-DanWard/PowerShell-Beautifier",$i18n.GetModule_Module_Installed_success -ForegroundColor Green
  } else {
    Write-Host ""
    Write-Host "github:DTW-DanWard/PowerShell-Beautifier",$i18n.GetModule_Module_Installed_e3 -ForegroundColor Red
    Install-Module -Name PowerShell-Beautifier
  }

  if (Get-InstalledModule -Name PSScriptAnalyzer) {
    Write-Host "github:PowerShell/PSScriptAnalyzer",$i18n.GetModule_Module_Installed_success -ForegroundColor Green
  } else {
    Write-Host ""
    Write-Host "github:PowerShell/PSScriptAnalyzer",$i18n.GetModule_Module_Installed_e3 -ForegroundColor Red
    Install-Module -Name PSScriptAnalyzer -Reinstall
  }
}

# =====================
# Request on first init
# =====================

$checkInitFile = Test-Path -Path "buildInit_success"

if ($false -eq $checkInitFile) {

  Write-Host ""
  Write-Host $i18n.InitScript_echo -ForegroundColor Yellow
  $initScriptResponse = Read-Host -Prompt $i18n.General_Answer

  if ($initScriptResponse -eq "y") {

    Clear-Host

    # ==============================
    # Check if connected to internet
    # ==============================

    Write-Host $i18n.CheckInternet_General_echo

    $handshakeNetwork = Test-Connection "www.example.org" -ErrorAction "SilentlyContinue";

    if ($null -eq $handshakeNetwork) {
      Write-Host $i18n.CheckInternet_General_e6 -ForegroundColor Red
      exit 6 # Connection handshake failed
    } else {
      Write-Host $i18n.CheckInternet_General_success -ForegroundColor Green
    }

    # ================================================
    # Check if script is running as root/administrator
    # ================================================

    if ($IsWindows) {
      Write-Host $i18n.GetOS_IsWindows_echo
      if ([Security.Principal.WindowsIdentity]::GetCurrent().Groups -contains 'S-1-5-32-544') {
        Write-Host $i18n.GetAdmin_IsWindows_success -ForegroundColor Green
        Invoke-Init
      }
      else {
        Write-Host $i18n.GetAdmin_IsWindows_e1 -ForegroundColor Red
        exit 1 # User did not run the script as administrator/root
      }
    } elseif ($IsLinux) {
      Write-Host $i18n.GetOS_IsLinux_echo
      Get-NotRoot
      Invoke-Init
    } elseif ($IsMacOS) {
      Write-Host $i18n.GetOS_IsMac_echo
      Get-NotRoot
      Invoke-Init
    } else {
      $i18n.GetOS_Unknown_e2
      exit 2 # User runs the script on unsupported OS
    }

    Write-Host ""
    Write-Host $i18n.GetModule_General_echo
    Out-File -FilePath "buildInit_success" -Encoding utf8 -Append -NoNewline
    Write-Host $i18n.GetModule_General_success -ForegroundColor Green

    Write-Host $i18n.InitScript_success -ForegroundColor Green
    exit 0
  }
}

# =======================
# Negate admin/root check
# =======================

if ($IsWindows) {
  Write-Host $i18n.GetOS_IsWindows_echo
  if ([Security.Principal.WindowsIdentity]::GetCurrent().Groups -contains 'S-1-5-32-544') {
    Write-Host $i18n.GetAdminNegate_IsWindows_e1 -ForegroundColor Red
    exit 1 # User did not run the script as administrator/root
  }
  else {
    Write-Host $i18n.GetAdminNegate_IsWindows_success -ForegroundColor Green
  }
} elseif ($IsLinux) {
  Write-Host $i18n.GetOS_IsLinux_echo
  Get-NotRoot
} elseif ($IsMacOS) {
  Write-Host $i18n.GetOS_IsMac_echo
  Get-NotRoot
} else {
  $i18n.GetOS_Unknown_e2
  exit 2 # User runs the script on unsupported OS
}

# ============================
# Check complete, start script
# ============================

Clear-Host

Write-Host $i18n.LintFile_Init -ForegroundColor Yellow

# Ignore PSAvoidUsingWriteHost as the script is intended to be used for newcomers
$linter = Invoke-ScriptAnalyzer -Recurse -Path . -ExcludeRule PSAvoidUsingWriteHost -Fix | Select-Object "RuleName",Severity,Line,Column

$linter | <#ForEach-Object {$_ -replace "((\[[\d;m]+))", ""} |#> Out-File lintResult.txt

# Check if lint result throw an error
$lintResult = Get-Content lintResult.txt
$containsWord = $lintResult | ForEach-Object { $_ -match "RuleName" }
if ($containsWord -contains $true) {
  Write-Host $i18n.LintFile_Warning -ForegroundColor Red
} else {
  Write-Host $i18n.LintFile_success -ForegroundColor Green

  Remove-Item -Path lintResult.txt -Force -ErrorAction SilentlyContinue
  Write-Host $i18n.LintFile_FileRemoved -ForegroundColor Yellow
}

Write-Host ""
Write-Host $i18n.Beautify_Init -ForegroundColor Yellow
Get-ChildItem -Path . -Include *.ps1,*.psm1,*.psd1 -Recurse | Edit-DTWBeautifyScript -NewLine LF
Write-Host $i18n.Beautify_success -ForegroundColor Green

Write-Host $i18n.General_Success -ForegroundColor Green
exit 0
