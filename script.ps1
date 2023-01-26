﻿#!/usr/bin/env pwsh

# Load Common Parameters
[CmdletBinding()]
Param()

If ($PSVersionTable.Major -lt 6) {
  $PSDefaultParameterValues['Out-File:Encoding'] = 'utf8'
}

# ===============
# Script Metadata
# ===============

$version = "2.0.1"         # Script Version

$gfxAdmin = "nattadasu"     # GFX Administator
$gfxDeputy = "Annie_Law"     # GFX Deputy

# =================================
# Modules, Functions, and Variables
# =================================

$moduleDir = (Get-ChildItem -Path "./Modules/").FullName
ForEach ($file in $moduleDir) {
  Import-Module "$($file)"
  Write-Verbose -Message "$file is loaded"
}

$cardSlip = Import-PowerShellDataFile -Path './Resources/slipCards.psd1'

# =================
# Initialize Script
# =================

# MOTD
# ----
Clear-Host
Write-Verbose -Message "Loading MOTD"
Write-Header -Message "The Newbie Club: Card Edition Post Generator v.$($version)" -ForegroundColor Blue
Write-Host "Licensed under MIT, 🐱 GitHub: https://github.com/theNewbieClub-MAL/editionThreadGenerator-ps1`n" -ForegroundColor Blue

# Locale Import
# -------------
$localeName = (Get-Culture).Name

# Write a warning when user used locale that doesn't translated yet.
If (-Not (Test-Path -Path ./Translations/$localeName)) {
  Write-Host "Uh-oh. We can not find the localization file for $($localeName) ($((Get-Culture).DisplayName)), so we temporarily replace it to English (US)" -ForegroundColor Red
  Write-Host "You can change the locale in next prompt`n"
  $localeName = "en-US"
}

Import-LocalizedData -BindingVariable i18n -UICulture $localeName -BaseDirectory ./Translations

Write-Host $i18n.InitLocale_General_echo_1, " ", $localeName, " (", (Get-Culture -Name $localeName).DisplayName, ")", "$(If("." -eq $i18n.InitLocale_General_echo_2){"$($i18n.InitLocale_General_echo_2) "} Else {" $($i18n.InitLocale_General_echo_2) "})", $i18n.InitLocale_General_prompt -ForegroundColor Yellow -Separator ""
Write-Host "`n$($i18n.InitLocale_List_echo)"

# Implement JSON Table instead listing from `Get-ChildItem`.
$i18nIndex = Get-Content ./Translations/index.json
$i18nIndex | ConvertFrom-Json | Format-Table @{ L = $i18n.LocaleTable_cultureCode; E = { $_.cultureCode } }, @{ L = $i18n.LocaleTable_descEn; E = { $_. "desc-En" } }, @{ L = $i18n.LocaleTable_descLoc; E = { $_. "desc-Loc" } }, @{ L = $i18n.LocaleTable_contributors; E = { $_.contributors } }

$changeLocale = Read-Host -Prompt $i18n.InitLocale_Replace_Prompt

If (-Not ($changeLocale)) {
  Import-LocalizedData -BindingVariable i18n -UICulture $localeName -BaseDirectory ./Translations
  $changeLocale = $localeName
}
ElseIf ("exit" -eq $changeLocale) {
  Clear-Host
  Exit
}
Else {
  Import-LocalizedData -BindingVariable i18n -UICulture $changeLocale -BaseDirectory ./Translations
}

Write-Host $i18n.InitLocale_Replace_success, $changeLocale -ForegroundColor Green

# ==================
# Start Script Logic
# ==================
Function Invoke-Card {
  # General Information
  # -------------------
  Clear-Host
  Write-Header -Message $i18n.Header_GeneralInfo -ForegroundColor Blue

  # Title
  $Edition_title = Read-Host -Prompt $i18n.Question_Edition_Title
  If (!($Edition_title)) { $Edition_title = "CHANGE TITLE BEFORE PUBLICATION" }
  Write-Verbose -Message "Title set to $($Edition_title)"

  $Edition_emoji = Read-Host -Prompt $i18n.Question_Edition_Emoji
  If (!($Edition_emoji)) { $Edition_emoji = "⚠️" }
  Write-Verbose -Message "Emoji set to $($Edition_emoji)"

  # Is the editon only covers one title of media?
  Do {
    $Edition_isSingle = Read-Host -Prompt $i18n.Question_Edition_IsSingle
    If (!($Edition_isSingle)) { $Edition_isSingle = "n" }
  } While (-Not ($Edition_isSingle -match "^(y|n)$"))
  If ($Edition_isSingle -eq "n") {
    Write-Verbose -Message "Edition has multiple titles"
  }
  Else {
    Write-Verbose -Message "Edition only for one title"
  }

  # Allowed total requests
  Do {
    $Edition_count = Read-Host -Prompt $i18n.Question_Edition_Count
    If (!($Edition_count)) { $Edition_count = "100" }
  } Until ($Edition_count -ge 1)
  Write-Verbose -Message "Edition only allows up to $($Edition_count) requests"

  # Date input
  Do {
    $Edition_startInput = Read-Host -Prompt "$($i18n.Question_Edition_Start) $(Get-Date -Format yyyy-MM-dd)$($i18n.Question_Edition_Default) $(Get-Date -Format yyyy-MM-dd)"
    If (!($Edition_startInput)) { $Edition_startInput = "$(Get-Date -Format yyyy-MM-dd)" }
  } While (!($Edition_startInput -As [DateTime]))
  Write-Verbose -Message "Start date set to $($Edition_startInput)"

  Do {
    $Edition_endInput = Read-Host -Prompt "$($i18n.Question_Edition_End) $(Get-Date -Format yyyy-MM-dd)$($i18n.Question_Edition_Default) $(Get-Date (Get-Date $Edition_startInput).AddDays(4) -Format yyyy-MM-dd)"
    If (!($Edition_endInput)) { $Edition_endInput = "$(Get-Date (Get-Date $Edition_startInput).AddDays(4) -Format yyyy-MM-dd)" }
  } While (!($Edition_endInput -As [DateTime]))
  Write-Verbose -Message "End date set to $($Edition_endInput)"

  # Ask total staff participating and validate if >= 1 & <= 5
  Do {
    $Edition_staffCount = Read-Host -Prompt $i18n.Question_Edition_Staff
    If (!($Edition_staffCount)) { $Edition_staffCount = 1 }
  } Until ($Edition_staffCount -ge 1 -And $Edition_staffCount -le 5)
  Write-Verbose -Message "Staff participated to this edition set to $($Edition_staffCount)"

  # Customizations
  # --------------
  Write-Host ""
  Write-Header -Message "$($i18n.Header_Customizations)" -ForegroundColor Blue

  If ($Edition_isSingle -eq "n") {
    Do {
      $Locale_set = Read-Host -Prompt $i18n.Question_Locale_Set
      If (!($Locale_set)) { $Locale_set = "romaji" }
    } While (!($Locale_set -Match '^(romaji|english)$'))
  }
  If (!($Locale_set)) { $Locale_set = "romaji" }
  Write-Verbose -Message "Locale set to $($Locale_set)"

  # Banner
  $Banner_imageUrl = Read-Host -Prompt $i18n.Question_Banner_Uri
  If (!($Banner_imageUrl)) {
    $Banner_randomized = Get-RandomBanner
    $Banner_imageUrl = "https://etgps1.thenewbieclub.my.id/Resources/Banners/$($Banner_randomized)"
    $Banner_creator = "$(Get-WorkStaff -FileName $Banner_randomized)"
    If ($Edition_isSingle -eq "n") {
      $Banner_malId = "0"
      $Banner_customUrl = "https://github.com/theNewbieClub-MAL/editionThreadGenerator-ps1"
      $Banner_titleResult = "Placeholder"
    }
    Write-Verbose -message "Banner is not set, automatically use placeholder instead"
  }
  Else {
    $Banner_creator = Read-Host -Prompt $i18n.Question_Banner_Creator
    If ($Edition_isSingle -eq "n") {
      $Banner_titleQuery = Read-Host -Prompt $i18n.Question_Banner_Title
      Find-MAL -SearchQuery $Banner_titleQuery

      $Banner_malId = Read-Host -Prompt $i18n.Prompt_MALId_Insert
      If (!($Banner_malId)) { $Banner_malId = "0" }
      If ($Banner_malId -eq "0") {
        Write-Host $i18n.Echo_ID_Custom -ForegroundColor Yellow
        $Banner_customUrl = Read-Host -Prompt $i18n.Question_ID_Custom
        $Banner_titleResult = $Banner_titleQuery
      }
      Else {
        $Banner_titleResult = If ($Locale_set -eq "romaji") {
          Get-MALTitle -MALId $Banner_malId
        }
        ElseIf ($Locale_set -eq "english") {
          Get-MALTitle -MALId $Banner_malId -English
        }
        Write-Host $i18n.Selected_Banner_Title, $Banner_titleResult -ForegroundColor Green
      }
    }
  }

  # Set thread color
  $Thread_color = Read-Host -Prompt $i18n.Question_Color
  If (-Not ($Thread_color)) { $Thread_color = "#000000" }
  Write-Verbose -Message "Thread color set to $($Thread_color)" 

  # Show dark mode warning
  $DarkMode_warn = Read-Host -Prompt $i18n.Question_DarkMode
  If (-Not ($DarkMode_warn)) { $DarkMode_warn = "y" }
  If ($DarkMode_warn -eq "y") {
    Write-Verbose -Message "Dark mode warning is enabled"
  }
  Else {
    Write-Verbose -Message "Dark mode warning is disabled"
  }

  # Introduction Text
  # -----------------

  # GIF
  $Intro_gif = Read-Host -Prompt $i18n.Question_Intro_GifUrl
  Write-Verbose -Message "Intro GIF URL set to $($Intro_gif)"

  # Text
  $textHeader = $i18n.Question_Intro_Text_Header
  $textHeader | Out-File -FilePath IntroText.temp.bbcode -Encoding UTF8 
  If ($IsWindows -or ((Get-WmiObject Win32_OperatingSystem).Caption -like "*Windows*")) {
    notepad IntroText.temp.bbcode
  }
  ElseIf ($IsLinux) {
    If (Get-Command "gedit" -ErrorAction SilentlyContinue) {
      gedit IntroText.temp.bbcode
    }
    ElseIf (Get-Command "gnome-text-editor" -ErrorAction SilentlyContinue) {
      gnome-text-editor IntroText.temp.bbcode
    }
    ElseIf (Get-Command "kwrite" -ErrorAction SilentlyContinue) {
      kwrite IntroText.temp.bbcode
    }
    ElseIf (Get-Command "mousepad" -ErrorAction SilentlyContinue) {
      mousepad IntroText.temp.bbcode
    }
    ElseIf (Get-Command "nano" -ErrorAction SilentlyContinue) {
      Start-Sleep -Seconds 3
      nano IntroText.temp.bbcode
    }
    ElseIf (Get-Command "vim" -ErrorAction SilentlyContinue) {
      Start-Sleep -Seconds 3
      vim IntroText.temp.bbcode
    }
    ElseIf (Get-Command "vi" -ErrorAction SilentlyContinue) {
      Start-Sleep -Seconds 3
      vi IntroText.temp.bbcode
    }
    Else {
      Write-Host $i18n.Question_Intro_Text_NoProg -ForegroundColor Red
      Exit
    }
  }
  ElseIf ($IsMacOS) {
    If (Get-Command "open" -ErrorAction SilentlyContinue) {
      open IntroText.temp.bbcode
    }
    ElseIf (Get-Command "nano" -ErrorAction SilentlyContinue) {
      nano IntroText.temp.bbcode
    }
    ElseIf (Get-Command "vim" -ErrorAction SilentlyContinue) {
      vi IntroText.temp.bbcode
    }
    Else {
      Write-Host $i18n.Question_Intro_Text_NoProg -ForegroundColor Red
      Exit
    }
  }
  Else {
    Write-Host "Unsupported OS" -ForegroundColor Red
    Exit
  }
  Read-Host $i18n.Question_Intro_Text

  $Intro_text = Get-Content -Path IntroText.temp.bbcode -Raw
  If ($Intro_text) {
    $Intro_text = $Intro_text -replace "$($i18n.Question_Intro_Text_Header)(`r)?`n", ""
    $Intro_text = $Intro_text -replace "`r`n", "`n"
    $Intro_text = $Intro_text -replace "{{", "[color=$Thread_color]"
    $Intro_text = $Intro_text -replace "}}", "[/color]"

    Write-Host $i18n.Generate_Intro_Success
    Write-Host $Intro_text
  }
  Else {
    Write-Host $i18n.Generate_Intro_Fail -ForegroundColor Red
  }

  Write-Verbose -Message "Updating JSON variable"
  $textLine = If (!$Intro_text) { $Null } Else { ($Intro_text | Measure-Object -Line).Lines }
  $json = [ordered]@{
    document       = [ordered]@{
      scriptVersion = [string]$version
      gfxStaff      = [ordered]@{
        admin  = [string]$gfxAdmin
        deputy = [string]$gfxDeputy
      }
    }
    metadata       = [ordered]@{
      title        = [string]$Edition_title
      emoji        = $Edition_emoji
      isSingle     = If ($Edition_isSingle -eq "y") { $true } Else { $false }
      allowedReply = [int]$Edition_count
      date         = [ordered]@{
        start = [string]$Edition_startInput
        end   = [string]$Edition_endInput
      }
      staffCount   = [int]$Edition_staffCount
    }
    customizations = [ordered]@{
      titleLocale  = $Locale_set
      banner       = [ordered]@{
        imageUrl  = $Banner_imageUrl
        creator   = [string]$Banner_creator
        malId     = If (!$Banner_malId) { $null } Else { [int]$Banner_malId }
        customUrl = If (!$Banner_customUrl) { $null } Else { [string]$Banner_customUrl }
        title     = If ($Edition_isSingle -eq "y") { $null } Else { [string]$Banner_titleResult }
      }
      threadColor  = [string]$Thread_color
      darkModeWarn = If ($DarkMode_Warn -eq "y") { $true } Else { $false }
      intro        = [ordered]@{
        gifUrl = If (!$Intro_gif) { $null } Else { [string]$Intro_gif }
        text   = If (!$Intro_text) { $null } Else { [string]$Intro_text }
        # if $intro_text is available, count how much lines it has in switch
        # if $intro_text is not available, set to null
        pixel  = Switch ($textLine) {
          $Null { $null }
          5 { 93 }
          6 { 112 }
          7 { 132 }
          8 { 152 }
          9 { 172 }
          10 { 192 }
          11 { 212 }
          Default {
            If ($textLine -gt 11) {
              212
            }
            ElseIf ($textLine -lt 5) {
              93
            }
            Else {
              $null
            }
          }
        }
      }
    }
    staff          = [PsCustomObject]@()
  }

  # =====
  # Contributed Staff and Cards
  # =====

  # Staff Information
  # -----------------

  Write-Host ""
  Write-Header -Message $i18n.Header_Cards -ForegroundColor Blue

  For ($staff = 1; $staff -le $Edition_staffCount; $staff++) {
    # Add backward compatible header
    Switch ($staff) {
      1 { $staffHeader = $i18n.Header_Staff_1 }
      2 { $staffHeader = $i18n.Header_Staff_2 }
      3 { $staffHeader = $i18n.Header_Staff_3 }
      4 { $staffHeader = $i18n.Header_Staff_4 }
      5 { $staffHeader = $i18n.Header_Staff_5 }
    }

    Write-Host ""
    Write-Header -Message $staffHeader -Separator "-"

    Do {
      $staffUsername = Read-Host -Prompt $i18n.Staff_Username
    } Until ($staffUsername.Length -le 13) # Follows MyAnimeList specs
    Write-Verbose -Message "Staff #$($staff) username set to $($staffUsername)"

    $staffNickname = Read-Host -Prompt "$($i18n.Staff_Nickname) $($staffUsername)"
    If (!($staffNickname)) { $staffNickname = $staffUsername }
    Write-Verbose -Message "Staff #$($staff) nickname set to $($staffNickname)"

    Do {
      $limitType = Read-Host -Prompt $i18n.Staff_Limit_Type
      If (!($limitType)) { $limitType = "role" }
    } While (!($limitType -Match '^(role|any)$'))
    Write-Verbose -Message "Staff #$($staff) limit type set to $($limitType)"

    # Check slip card status
    If (!($cardSlip.$staffUsername)) {
      Write-Error -Message $i18n.Invalid_Slip -ErrorAction Continue
      $isAllowSlip = "null"
      Write-Verbose -Message "Staff #$($staff) does not offer slip"
    }
    Else {
      Do {
        $isAllowSlip = Read-Host -Prompt $i18n.Staff_Allows_Slip_Card
        If (!($isAllowSlip)) { $isAllowSlip = "y" }
      } While (!($isAllowSlip -Match '^(y|n)$'))
      If ($isAllowSlip -eq "y") {
        Write-Verbose -Message "Staff #$($staff) allows slip card"
      }
      Else {
        Write-Verbose -Message "Staff #$($staff) does not allow slip card"
      }
    }

    # Set card Limit
    Do {
      $totalCards = Read-Host -Prompt $i18n.Staff_Limit_Total
      $totalCards = [Int]$totalCards
    } Until (($totalCards -ge 1) -And ($totalCards -le 9))
    Write-Verbose -Message "Staff #$($staff) total card limit set to $($totalCards)"

    If ($limitType -eq "role") {
      Do {
        $memberLimit = Read-Host -Prompt $i18n.Staff_Limit_Member
      } Until (($memberLimit -ge 1) -And ($memberLimit -le $totalCards))
      Write-Verbose -Message "Staff #$($staff) member card limit set to $($memberLimit)"

      Do {
        $staffLimit = Read-Host -Prompt $i18n.Staff_Limit_Staff
      } Until (($staffLimit -ge 1) -And ($staffLimit -le $totalCards))
      $anyLimit = "null"
      Write-Verbose -Message "Staff #$($staff) staff card limit set to $($staffLimit)"
    }
    Else {
      Do {
        $anyLimit = Read-Host -Prompt $i18n.Staff_Limit_Any
      } Until (($anyLimit -ge 1) -And ($anyLimit -le $totalCards))
      $staffLimit = "null"
      $memberLimit = "null"
      Write-Verbose -Message "Staff #$($staff) any card limit set to $($anyLimit)"
    }

    $staffData = [ordered]@{
      username      = [string]$staffUsername
      nickname      = [string]$staffNickname
      isSlipAllowed = If ($isAllowSlip -eq "y") { $true } Else { $false }
      limitType     = $limitType
      totalCards    = $totalCards
      limits        = [ordered]@{
        any    = $anyLimit
        member = $memberLimit
        staff  = $staffLimit
      }
      cards         = [PsCustomObject]@()
    }

    # Cards
    # -----

    For ($card = 1; $card -le $totalCards; $card++) {
      Write-Host ""
      Write-Header -Message "$($i18n.Header_Card) ($($card))" -Separator "-" -ForegroundColor Yellow

      $imageUri = Read-Host -Prompt $i18n.Staff_Cards_Url, "($($card))"
      If (!($imageUri)) {
        $randomPlaceHolder = Get-RandomCard
        $imageUri = "https://etgps1.thenewbieclub.my.id/Resources/Cards/$($randomPlaceHolder)"
        $malId = "0"
        $customUrl = "https://github.com/theNewbieClub-MAL/editionThreadGenerator-ps1"
        $titleResult = "Placeholder"
      }
      Write-Verbose -Message "Staff #$($staff) card #$($card) image URL set to $($imageUri)"

      # Lookup formatted title name for card source
      If ($Edition_isSingle -eq 'n') {
        Do {
          $titleQuery = Read-Host -Prompt $i18n.Staff_Cards_Title
        } While (($titleQuery -eq '') -Or ($Null -eq $titleQuery))
        
        Find-MAL -SearchQuery $titleQuery
        
        # Get MAL ID

        Do {
          $malId = Read-Host -Prompt $i18n.Prompt_MALId_Insert
          If (!($malId)) { $malId = "0" }
        } While (!($malId -Match '^[\d]+$'))

        If ($malId -eq "0") {
          Write-Host $i18n.Echo_ID_Custom -ForegroundColor Yellow
          $customUrl = Read-Host -Prompt $i18n.Question_ID_Custom
          $titleResult = $titleQuery
        }
        Else {
          $titleResult = If ($Locale_set -eq "romaji") {
            Get-MALTitle -MALId $malId
          }
          Else {
            Get-MALTitle -MALId $malId -English
          }
          Write-Verbose "MAL:$($malID) - $($titleResult) is selected"
        }
      }

      # Append Result
      $staffData.cards += [ordered]@{
        imageUri  = [string]$imageUri
        malId     = If (($malId -eq '0') -Or ($malId -eq 0)) { "null" } Else { $malId }
        customUrl = If (($malId -eq 0) -Or ($malId -eq 0)) { $customUrl } Else { "null" }
        title     = If ($Edition_isSingle -eq "n") { $titleResult } Else { $Edition_title }
      }
    }
    Write-Verbose -Message "Updating staff #$($staff) card list"
    $json.staff += $staffData
  }

  Write-Verbose -Message "Saving variables to savedata.json"
  $json | ConvertTo-Json -Depth 99 | Out-File -FilePath ./savedata.json
}

# Check if savedata.json is available

Clear-Host

If (Test-Path -Path './savedata.json') {
  $readJson = Read-Host -Prompt $i18n.Question_Load_JSON_Sessiom
  If (!($readJson)) { $readJson = "n" }
}
Else {
  $readJson = "n"
}

If ($readJson -eq "n") {
  Invoke-Card
}

$loadJson = Get-Content -Path './savedata.json' -Raw
$json = ConvertFrom-Json $loadJson

Clear-Host

# List Backward compactible variable
# ----------------------------------

# Divide objects
# ----------------------------------- #
$jsonDocument = $json.document        #
$jsonData = $json.metadata        #
$jsonConfig = $json.customizations  #
$jsonStaff = $json.staff           #
# ----------------------------------- #

$Banner_creator = $jsonConfig.banner.creator
$Banner_customUrl = $jsonConfig.banner.customUrl
$Banner_imageUrl = $jsonConfig.banner.imageUrl
$Banner_malId = $jsonConfig.banner.malId
$Banner_titleQuery = $jsonConfig.banner.title
$Banner_titleResult = $Banner_titleQuery
$DarkMode_Warn = If ($True -eq $jsonConfig.darkModeWarn) { "y" } Else { "n" }
$Edition_count = $jsonData.allowedReply
$Edition_emoji = $jsonData.emoji
$Edition_end = Get-Date $jsonData.date.end -Format "MMMM d, yyyy"
$Edition_isSingle = If ($True -eq $jsonData.isSingle) { "y" } Else { "n" }
$Edition_staffCount = $jsonData.staffCount
$Edition_start = Get-Date $jsonData.date.start -Format "MMMM d, yyyy"
$Edition_title = $jsonData.title
$gfxAdmin = $jsonDocument.gfxStaff.admin
$gfxDeputy = $jsonDocument.gfxStaff.deputy
$Intro_gif = $jsonConfig.intro.gifUrl
$intro_textFormat = $jsonConfig.intro.text
$Thread_color = $jsonConfig.threadColor

# ===============
# Generate BBCODE
# ===============

# Post Title
# ----------
Write-Host $i18n.Generate_Title_Success -ForegroundColor Green
Write-Header -Message $i18n.Prompt_ToCopy -ForegroundColor Yellow
Write-Host ""

Write-Host "[CARDS][OPEN] $($Edition_emoji) $($Edition_title)"

Write-Host ""
Write-Host "=============" -ForegroundColor Yellow
Read-Host -Prompt $i18n.Prompt_Move_Section

# Post Body
# ---------
Clear-Host

Write-Host $i18n.Generate_BBCode_Success -ForegroundColor Green
Write-Header -Message $i18n.Prompt_ToCopy -ForegroundColor Yellow

$result = @"
[color=$($Thread_color)][center][img]$($Banner_imageUrl)[/img]
[size=80][i][b]$(if($Edition_isSingle -eq "y") { "Banner by @$($Banner_creator)" } Else { "[url=$(if($Banner_malId -eq 0) {"$($Banner_customUrl)]$($Banner_titleResult)[/url]"} Else {"https://myanimelist.net/anime/$($Banner_malId)]$($Banner_titleResult)[/url]"}) banner by @$($Banner_creator)" })　　　　　　　　　　　　　　　　　[url=https://nttds.my.id/tnc-cardfaq]What is a card?[img]https://nttds.my.id/extLink.svg[/img][/url]　　　　　　　　　　　　　　　　　Spaces Remaining: [color=#000000]$($Edition_count)[/color][/b][/i][/size]
$(If ($DarkMode_warn -eq "n") {"`n`n"} Else {@"
[color=white][size=105][b]If you can read this message, please consider to temporarily disable dark mode. Thanks!
Ignore if you're using 3rd party app with auto recolor text support.[/b][/size][/color]
"@})
[quote][b]Edition starts[/b]: [color=#000000]$($Edition_start)[/color] | [b]Edition ends[/b]: [color=#000000]$($Edition_end)[/color][/quote][/center][size=120]
　[size=230]💬 [b]Introduction[/b][/size]
[quote][list][color=#000000]$(If (!$intro_textFormat) { "[center]" })[img$(If ($intro_textFormat) { " align=right height=$($json.customizations.intro.pixel)" })]$($Intro_gif)[/img]$(If (!$intro_textFormat) { "[/center]" })$(If (-Not ($Intro_textFormat)) {} Else {@"

[i]$($Intro_textFormat)[/i]
"@})[/color][/list][/quote]
　[size=230]🏛️ [b]Rules[/b][/size]
[quote]
[center][size=90]⚠️ [b]Make sure to follow all rules stated below before continue![/b] ⚠️[/size][/center][list=1][*][color=#000000]Request your cards by [u]commenting on this forum thread[/u] and using a list number instead of naming the card.[/color]
[*][color=#000000]Do not request cards if you have no intention of saving them AND/OR request for someone else.[/color]
[*][color=#000000]Please [b]follow the format and respect the limits given by each card maker[/b], or the request will be deleted.[/color]
[*][color=#000000]Due to our current automation limitation, [b]do not change or remove query names[/b]. We will warn you if find any infringement.[/color]
[*][color=#000000]If you want to claim additional card(s) using slip card AND/OR bonus by requirement from designer, please use plus symbol (+) on additional card(s).[/color]
[*][color=#000000]In cases where your username is long and ensure your name fits, it's advised to [b]leave a short name/nickname no more than 12 characters/words[/b].[/color]
[*][color=#000000]Nickname is prioritized for card naming than username if filled.[/color]
[*][color=#000000][b]Editions are limited to $($Edition_count) requests[/b], so it's first come, first served![/color]
[*][color=#000000]If you have any question regarding requesting the cards, how it works, or any general questions, please check [url=https://myanimelist.net/forum/?topicid=1983981]Card Guide and FAQ[/url] forum thread.[/color]
[*][color=#000000]To check delivery progress, please refer to [url=https://myanimelist.net/forum/?topicid=1981019]Card Delivery Tracking[/url] thread.[/color]
[/list][/quote]
　[size=230]🖊️ [b]Template Format[/b][/size]
[quote][size=90]
[center]⚠️ [b]Please to insert text(s) after (on the right of) [[i][/i]/b] tags![/b] ⚠️
Remember: Nickname will be prioritized than username for card naming if filled[/center]
[color=#000000][code]
[size=90][b]Username: [/b]
[b]Nickname: [/b]
[b]Role: [/b]Member
[b]Deliver to: [/b]Profile Comment/Private Message/Blog Post
[b][i]—Cards by—[/i][/b]
"@

$result += ForEach ($staff in $jsonStaff) {
  "`n$($staff.nickname):"
}

$result += @"
 `n——
[b]Comments: [/b]
[b]Edition Suggestion: [/b]
[/size]
[/code]
[/color][/size][/quote]
　[size=230]🔍 [b]Example/Result[/b][/size]
[quote][color=#000000][size=75]
[img]https://etgps1.thenewbieclub.my.id/Headers/heading.png[/img]
[url=https://myanimelist.net/profile/un1corn_tnc][img align=left]https://etgps1.thenewbieclub.my.id/Headers/profile.png[/img][/url][size=20]
[/size][b]Username: [/b]un1corn_tnc
[b]Nickname: [/b] -
[b]Role: [/b]Member
[b]Deliver to: [/b]Profile Comment
[b][i]—Cards by—[/i][/b]
"@

$result += ForEach ($staff in $jsonStaff) {
  $slipCard = If ($True -eq $staff.isSlipAllowed) {
    $username = $staff.username
    " [spoiler=slip][img]$($cardSlip.$username)[/img][/spoiler]"
  }
  "`n$($staff.nickname): $((1..$staff.limits.member | ForEach-Object {Get-Random -Minimum 1 -Maximum $staff.totalCards} | Sort-Object -Unique) -Join ', ')$($slipCard)"
}

$result += @"
`n——
[b]Comments: [/b]
[b]Edition Suggestion: [/b]$( If ( $Edition_staffCount -eq 5) { "`n" } Else {""} ) $( If ( $Edition_staffCount -eq 4) { "`n`n" } Else {""} ) $( If ( $Edition_staffCount -eq 3) { "`n`n`n" } Else {""} ) $( If ( $Edition_staffCount -eq 2) { "`n`n`n`n" } Else {""} ) $( If ( $Edition_staffCount -eq 1) { "`n`n`n`n`n" } Else {""} )
[/size][size=80][right][color=#1d439b]Report[/color] - [color=#1d439b]Quote[/color][/right][/size]
[/color][/quote]
　[size=230]💳 [b]Cards[/b][/size]
[color=#000000][center]
"@

$result += ForEach ($staff in $jsonStaff) {
  $table = @"
[tr][th]1$( If ($Edition_isSingle -eq "n") {" | [url=$(if(($Null -eq $staff.cards[0].malId) -Or ($staff.cards[0].malId -eq 0)) {$staff.cards[0].customUrl} Else {"https://myanimelist.net/anime/$($staff.cards[0].malId)"})]$($staff.cards[0].title)[/url]"})[/th] $(If (!($Null -eq $staff.cards[1])) { "[th]2$( If ($Edition_isSingle -eq "n") { " | [url=$( If (($Null -eq $staff.cards[1].malId) -Or ($staff.cards[1].malId -eq 0)){ $staff.cards[1].customUrl } Else { "https://myanimelist.net/anime/$($staff.cards[1].malId)" } )]$($staff.cards[1].title)[/url][/th]" } Else { "[/th]" } )" })[/tr]
[tr][td][img]$($staff.cards[0].imageUri)[/img][/td]$(If (!($Null -eq $staff.cards[1])) {" [td][img]$($staff.cards[1].imageUri)[/img][/td]"})[/tr]$(If (!($Null -eq $staff.cards[2])) {@"

[tr][th]3$( If ($Edition_isSingle -eq "n") {" | [url=$(if(($Null -eq $staff.cards[2].malId) -Or ($staff.cards[2].malId -eq 0)) {$staff.cards[2].customUrl} Else {"https://myanimelist.net/anime/$($staff.cards[2].malId)"})]$($staff.cards[2].title)[/url]"})[/th] $(If (!($Null -eq $staff.cards[3])) { "[th]4$( If ($Edition_isSingle -eq "n") { " | [url=$( If (($Null -eq $staff.cards[3].malId) -Or ($staff.cards[3].malId -eq 0)){ $staff.cards[3].customUrl } Else { "https://myanimelist.net/anime/$($staff.cards[3].malId)" } )]$($staff.cards[3].title)[/url][/th]" } Else { "[/th]" } )" })[/tr]
[tr][td][img]$($staff.cards[2].imageUri)[/img][/td]$(If (!($Null -eq $staff.cards[3])) {" [td][img]$($staff.cards[3].imageUri)[/img][/td]"})[/tr]
"@})$(If (!($Null -eq $staff.cards[4])) {@"

[tr][th]5$( If ($Edition_isSingle -eq "n") {" | [url=$(if(($Null -eq $staff.cards[4].malId) -Or ($staff.cards[4].malId -eq 0)) {$staff.cards[4].customUrl} Else {"https://myanimelist.net/anime/$($staff.cards[4].malId)"})]$($staff.cards[4].title)[/url]"})[/th] $(If (!($Null -eq $staff.cards[5])) { "[th]6$( If ($Edition_isSingle -eq "n") { " | [url=$( If (($Null -eq $staff.cards[5].malId) -Or ($staff.cards[5].malId -eq 0)){ $staff.cards[5].customUrl } Else { "https://myanimelist.net/anime/$($staff.cards[5].malId)" } )]$($staff.cards[5].title)[/url][/th]" } Else { "[/th]" } )" })[/tr]
[tr][td][img]$($staff.cards[4].imageUri)[/img][/td]$(If (!($Null -eq $staff.cards[5])) {" [td][img]$($staff.cards[5].imageUri)[/img][/td]"})[/tr]
"@})$(If (!($Null -eq $staff.cards[6])) {@"

[tr][th]7$( If ($Edition_isSingle -eq "n") {" | [url=$(if(($Null -eq $staff.cards[6].malId) -Or ($staff.cards[6].malId -eq 0)) {$staff.cards[6].customUrl} Else {"https://myanimelist.net/anime/$($staff.cards[6].malId)"})]$($staff.cards[6].title)[/url]"})[/th] $(If (!($Null -eq $staff.cards[7])) { "[th]8$( If ($Edition_isSingle -eq "n") { " | [url=$( If (($Null -eq $staff.cards[7].malId) -Or ($staff.cards[7].malId -eq 0)){ $staff.cards[7].customUrl } Else { "https://myanimelist.net/anime/$($staff.cards[7].malId)" } )]$($staff.cards[7].title)[/url][/th]" } Else { "[/th]" } )" })[/tr]
[tr][td][img]$($staff.cards[6].imageUri)[/img][/td]$(If (!($Null -eq $staff.cards[7])) {" [td][img]$($staff.cards[7].imageUri)[/img][/td]"})[/tr]
"@})$(If (!($Null -eq $staff.cards[8])) {@"

[tr][th]9 $( If ($Edition_isSingle -eq "n") {" | [url=$(if(($Null -eq $staff.cards[8].malId) -Or ($staff.cards[8].malId -eq 0)) {$staff.cards[8].customUrl} Else {"https://myanimelist.net/anime/$($staff.cards[8].malId)"})]$($staff.cards[8].title)[/url][/th]"} Else {"[/th]"} )
[tr][td][img]$($staff.cards[8].imageUri)[/img][/td][/tr]
"@})
"@
  @"
[quote]
[size=150][b]$($staff.nickname)[/b][/size]
$(If ($staff.limitType -eq "role") {@"
[b]Member:[/b] $($staff.limits.member)/$($staff.totalCards)
[b]Staff:[/b] $($staff.limits.staff)/$($staff.totalCards) $(If ($staff.limits.staff -eq $staff.totalCards) {"(ALL)"})
"@} Else {"[b]Member & Staff[/b]: $($staff.limits.any)/$($staff.totalCards) $(If ($staff.limits.any -eq $staff.totalCards) {"(ALL)"})"} )$(If ("n" -eq $staff.isAllowSlip) {@"

[color=red]Slip card can not be used on this edition[/color]
"@})
[spoiler="cards"]
[table]$($table -replace "`n", "")[/table]
[/spoiler]
[/quote]
"@
}

# Generate Metadata
# -----------------

$Attr_staff = @()

For ($staff = 0; $staff -lt 5; $staff++) {
  If ($Null -eq $jsonStaff[$staff]) {
    $Attr_staff += "0"
  }
  Else {
    $Attr_staff += $jsonStaff[$staff].nickname
  }
}

$Attr_limit = @()

For ($limit = 0; $limit -lt 5; $limit++) {
  If ($Null -eq $jsonStaff[$limit]) {
    $Attr_limit += "0"
  }
  Else {
    If ($jsonStaff[$limit].limitType -eq 'role') {
      $Attr_limit += "$($jsonStaff[$limit].limits.member)|$($jsonStaff[$limit].limits.staff)"
    }
    Else {
      $Attr_limit += "$($jsonStaff[$limit].limits.any)"
    }
  }
}

$Attr_total = @()

For ($ava = 0; $ava -lt 5; $ava++) {
  If ($Null -eq $jsonStaff[$ava]) {
    $Attr_total += "0"
  }
  Else {
    $Attr_total += $jsonStaff[$ava].totalCards
  }
}

$result += @"
[/center][/color]
　[size=180]🎉 [b]Happy Requesting![/b][/size][quote][list][color=#000000][b]From yours truly, the Graphic Design team[/b][/color]
[/list][/quote]
[center][size=80][quote][color=#000000]
[size=150]We're currently looking for new [b]designers/card makers and card delivery[/b] staff!
[img]https://64.media.tumblr.com/d1d7c7b1ba2a80944ae58f896cc03565/tumblr_inline_mpedfqsfBF1qz4rgp.gif[/img] Click [url=https://myanimelist.net/forum/?topicid=1711795][b]here[/b][/url] if you're interested in  joining the team! [img]https://64.media.tumblr.com/7784d381ee5756f89e31aad30dcfec00/tumblr_inline_mpedfns0uS1qz4rgp.gif[/img]
DM @$($gfxAdmin) or @$($gfxDeputy) for any questions[/size]

[/color][/quote]
[color=#000000]Cards made by @$($jsonStaff.username -Join ", @").[/color][/size]
[/center]
[/size][/color]

For internal use only, [i][url=https://pas.thenewbieclub.my.id/tncpas-0001]TNCPAS-0001[/url] Standardized Format[/i]:
[font=monospace]###METADATA
>>>THM>>$($Edition_title)
>>>TEM>>$($Edition_emoji)>>>CLR>>$($Thread_color)
>>>STF>>$($Attr_staff -Join ';')
>>>MAX>>$($Edition_count)
>>>LIM>>$($Attr_limit -Join ';')
>>>AVA>>$($Attr_total -Join ';')
{- Generated with [url=https://github.com/theNewbieClub-MAL/editionThreadGenerator-ps1]GitHub:theNewbieClub-MAL/editionThreadGenerator-ps1[/url]@[i][/i]v$($version) in Powershell on [url=https://www.timeanddate.com/worldclock/converter.html?iso=$(Get-Date ([DateTime]::UtcNow.ToString('')) -Format "yyyyMMddThhmmss")&p1=1440]$([DateTime]::UtcNow.ToString('u').Replace(' ','T'))[/url] -}
###[/font]
"@

Write-Host $result
$result | Out-File -FilePath "Generated.bbcode" -Encoding utf8

Write-Host "=============" -ForegroundColor Yellow
Write-Host $i18n.Attention_File_Created_1, "`"$((Get-Location).Path)/Generated.bbcode`"", $i18n.Attention_File_Created_2 -ForegroundColor Blue -Separator " "
Read-Host -Prompt $i18n.Prompt_Move_Section

# Post GFX Reqeust Field
# ----------------------
Clear-Host

Write-Host $i18n.Generate_GFXRequest_Success -ForegroundColor Green
Write-Header -Message $i18n.Prompt_ToCopy -ForegroundColor Yellow

Write-Host @"
[size=120]　[size=230][color=$($Thread_color)]💬 [b]GFX and Deliverer Staff Request[/b][/color][/size][/size][quote][center]
[size=120][color=$($Thread_color)][i]For GFX staff who hasn't send the format yet, please DM me.[/i][/color][/size]

[spoiler=requests]
[spoiler=template]
[b]If send via MyAnimeList DM:[/b]
[i]Note: Remove [[i][/i]i][[i][/i]/i] from the message if you want to send it as [[i][/i]code] tag[/i]
[code][[i][/i]quote][[i][/i]b]Staff Nickname: [[i][/i]/b]
[[i][/i]b]Delivery: [[i][/i]/b]
[[i][/i]i]—Cards by—[[i][/i]/i]$(ForEach ($staff in $jsonStaff) {
  "`n$($staff.nickname):"
})
--
[[i][/i]b]Comments: [[i][/i]/b]
[[i][/i]b]Edition Suggestion: [[i][/i]/b]
[[i][/i]/quote][/code]

[b]If send via Discord DM:[/b]
[code]``````accesslog
[quote][b]Staff Nickname: [/b]
[b]Delivery: [/b]
[i]—Cards by—[/i]$(ForEach ($staff in $jsonStaff) {
  "`n$($staff.nickname):"
})
--
[b]Comments: [/b]
[b]Edition Suggestion: [/b]
[/quote]``````[/code]
[/spoiler]

[/spoiler]
[/center][/quote]
"@

Write-Host "=============" -ForegroundColor Yellow
Read-Host -Prompt $i18n.Prompt_Exit_Script

# ===========
# Exit Script
# ===========

Clear-Host

exit 0
