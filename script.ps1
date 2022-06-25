#!/usr/bin/env pwsh

# ===============
# Script Metadata
# ===============

$version = "0.1.0"

# MAL Usernames, without @
$gfxAdmin = "nattadasu"
$gfxDeputy = "Annie_Law"

# =================================
# Modules, Functions, and Variables
# =================================

Import-Module "./Modules/jikanmoe.psm1"

$cardSlip = Import-PowerShellDataFile -Path './Resources/slipCards.psd1'

# =====
# Intro
# =====

Clear-Host
Write-Host "The Newbie Club: Card Edition Post Generator v.$($version)" -ForegroundColor Blue
Write-Host "Licensed under MIT, 🐱 GitHub: https://github.com/theNewbieClub-MAL/editionThreadGenerator-ps1" -ForegroundColor Blue
Write-Host ""

# ===================
# Import Localization
# ===================

$localeName = (Get-Culture).Name

# Write a warning when user used locale that doesn't translated yet.
if (-not(Test-Path -Path ./Translations/$localeName)) {
    Write-Host "Uh-oh. We can not find the localization file for $($localeName) ($((Get-Culture).DisplayName)), so we temporarily replace it to English (US)" -ForegroundColor Red
    Write-Host "You can change the locale in next prompt"
    $localeName = "en-US"
    Write-Host ""
}

Import-LocalizedData -BindingVariable i18n -UICulture $localeName -BaseDirectory ./Translations

Write-Host $i18n.InitLocale_General_echo_1," ", $localeName, " (", (Get-Culture).DisplayName, ")", "$(if("." -eq $i18n.InitLocale_General_echo_2){"$($i18n.InitLocale_General_echo_2) "} else {" $($i18n.InitLocale_General_echo_2) "})", $i18n.InitLocale_General_prompt -ForegroundColor Yellow -Separator ""
Write-Host ""
Write-Host $i18n.InitLocale_List_echo

# Implement JSON Table instead listing from `Get-ChildItem`.
$i18nIndex = Get-Content ./Translations/index.json
$i18nIndex | ConvertFrom-JSON | Format-Table @{L=$i18n.LocaleTable_cultureCode;E={$_.cultureCode}}, @{L=$i18n.LocaleTable_descEn;E={$_."desc-En"}}, @{L=$i18n.LocaleTable_descLoc;E={$_."desc-Loc"}}, @{L=$i18n.LocaleTable_contributors;E={$_.contributors}}

Write-Host ""
$changeLocale = Read-Host -Prompt $i18n.InitLocale_Replace_Prompt

if (-not($changeLocale)) {
    Import-LocalizedData -BindingVariable i18n -UICulture $localeName -BaseDirectory ./Translations
    $changeLocale = $localeName
} else {
    Import-LocalizedData -BindingVariable i18n -UICulture $changeLocale -BaseDirectory ./Translations
}

Write-Host $i18n.InitLocale_Replace_success, $changeLocale -ForegroundColor Green

# ============================
# Start Logic - By asking user
# ============================

# General Information
# -------------------
Clear-Host
Write-Host $i18n.Header_GeneralInfo -ForegroundColor Blue
Write-Host "=============" -ForegroundColor Blue

# Title
$Edition_title = Read-Host -Prompt $i18n.Question_Edition_Title
$Edition_emoji = Read-Host -Prompt $i18n.Question_Edition_Emoji
if (-not($Edition_emoji)) { $Edition_emoji = "😄" }

# Is the editon only covers one title of media?
$Edition_isSingle = Read-Host -Prompt $i18n.Question_Edition_IsSingle
if (-not($Edition_isSingle)) { $Edition_isSingle = "n" }

# Count
$Edition_count = Read-Host -Prompt $i18n.Question_Edition_Count
if (-not($Edition_count)) { $Edition_count = "100" }

# Date input
$Edition_startInput = Read-Host -Prompt "$($i18n.Question_Edition_Start) $(Get-Date -Format yyyy-MM-dd)"
$Edition_endInput = Read-Host -Prompt "$($i18n.Question_Edition_End) $(Get-Date -Format yyyy-MM-dd)"
$Edition_start = Get-Date $Edition_startInput -Format "MMMM d, yyyy"
$Edition_end = Get-Date $Edition_endInput -Format "MMMM d, yyyy"

$Edition_staffCount = Read-Host -Prompt $i18n.Question_Edition_Staff
if (-not($Edition_staffCount)) { $Edition_staffCount = "1" } elseif ( $Edition_staffCount -gt 5) {
    Write-Host $i18n.Invalid_Staff_Amount -ForegroundColor Red
    $Edition_staffCount = 5
}

# Customizations
# --------------

Write-Host ""
Write-Host $i18n.Header_Customizations -ForegroundColor Blue
Write-Host "=============" -ForegroundColor Blue

# Set title locale
$Locale_set = Read-Host -Prompt $i18n.Question_Locale_Set
if (-not($Locale_set)) { $Locale_set = "romaji" }
Write-Host $i18n.Question_Locale_success, $Locale_set -ForegroundColor Green

# Banner
$Banner_imageUrl = Read-Host -Prompt $i18n.Question_Banner_Uri
if(-not($Banner_imageUrl)) {
    $Banner_imageUrl = ""
    $Banner_creator = ""
    if ($Edition_isSingle -eq "n") {
        $Banner_malId = "0"
        $Banner_customUrl = "https://github.com/theNewbieClub-MAL/editionThreadGenerator-ps1"
        $Banner_titleResult = "Placeholder"
    }
} else {
    $Banner_creator = Read-Host -Prompt $i18n.Question_Banner_Creator
    if ($Edition_isSingle -eq "n") {
        $Banner_titleQuery = Read-Host -Prompt $i18n.Question_Banner_Title
        Find-MAL -SearchQuery $Banner_titleQuery

        $Banner_malId = Read-Host -Prompt $i18n.Prompt_MALId_Insert
        if (-not($Banner_malId)) { $Banner_malId = "0" }
        if ($Banner_malId -eq "0") {
            Write-Host $i18n.Echo_ID_Custom -ForegroundColor Yellow
            $Banner_customUrl = Read-Host -Prompt $i18n.Question_ID_Custom
            $Banner_titleResult = $Banner_titleQuery
        } else {
            $Banner_titleResult = if ($Locale_set -eq "romaji") {
                Get-MALTitle -MALId $Banner_malId -English $false
            } elseif ($Locale_set -eq "english") {
                Get-MALTitle -MALId $Banner_malId -English $true
            }
            Write-Host $i18n.Selected_Banner_Title, $Banner_titleResult -ForegroundColor Green
        }
    }
}

# Set thread color
$Thread_color = Read-Host -Prompt $i18n.Question_Color
if (-not($Thread_color)) { $Thread_color = "#000000" }

# Show dark mode warning
$DarkMode_warn = Read-Host -Prompt $i18n.Question_DarkMode
if (-not($DarkMode_warn)) { $DarkMode_warn = "y" }

# ============
# Introduction
# ============
Write-Host ""
Write-Host $i18n.Header_Intro -ForegroundColor Blue
Write-Host "=============" -ForegroundColor Blue

# GIF
$Intro_gif = Read-Host -Prompt $i18n.Question_Intro_GifUrl

# Text
$Intro_textRaw = Read-Host -Prompt $i18n.Question_Intro_Text
$Intro_replaceParentheses = $Intro_textRaw -replace("`{`{", "`[color=$Thread_color`]") -replace("`}`}", "`[/color`]")
$Intro_textFormat = $Intro_replaceParentheses.Replace("^@", "`n")

Write-Host $i18n.Generate_Intro_Success -ForegroundColor Green
Write-Host $Intro_textFormat -ForegroundColor Green

# ===========
# Cards Input
# ===========

Write-Host ""
Write-Host $i18n.Header_Cards -ForegroundColor Blue
Write-Host "=============" -ForegroundColor Blue

# Staff 1
# -------

Write-Host ""
Write-Host $i18n.Header_Staff_1 -ForegroundColor Blue
Write-Host "-------------"

$Staff1_username = Read-Host -Prompt $i18n.Staff_Username
$Staff1_nickname = Read-Host -Prompt $i18n.Staff_Nickname
$Staff1_limitType = Read-Host -Prompt $i18n.Staff_Limit_Type

if ($null -eq $cardSlip.$Staff1_username) {
    Write-Host $i18n.Invalid_Slip -ForegroundColor Red
} else {
    $Staff1_isAllowSlip = Read-Host -Prompt $i18n.Staff_Allows_Slip_Card
    if(-not($Staff1_isAllowSlip)) { $Staff1_isAllowSlip = "y" }
}

if (-not($Staff1_limitType)) { $Staff1_limitType = "role" }

if ($Staff1_limitType -eq "role") {
    $Staff1_limitStaff = Read-Host -Prompt $i18n.Staff_Limit_Staff
    $Staff1_limitMember = Read-Host -Prompt $i18n.Staff_Limit_Member
} else {
    $Staff1_limitAny = Read-Host -Prompt $i18n.Staff_Limit_Any
}

$Staff1_totalCards = Read-Host -Prompt $i18n.Staff_Limit_Total
if ($Staff1_totalCards -gt 9) {
    Write-Host $i18n.Invalid_Card_amount -ForegroundColor Red
    $Staff1_totalCards = 9
}

# Card 1
Write-Host ""
$Staff1_cards1_imageUri = Read-Host -Prompt $i18n.Staff_Cards_Url, "(1)"

if ( $Edition_isSingle -eq "n" ) {
    # Search title on MAL
    $Staff1_cards1_titleQuery = Read-Host -Prompt $i18n.Staff_Cards_Title

    Find-MAL -SearchQuery $Staff1_cards1_titleQuery

    # Get MAL ID
    $Staff1_cards1_malId = Read-Host -Prompt $i18n.Prompt_MALId_Insert
    if (-not($Staff1_cards1_malId)) { $Staff1_cards1_malId = "0" }

    # Manually assign url if MAL ID is 0
    if ($Staff1_cards1_malId -eq "0") {
        Write-Host $i18n.Echo_ID_Custom -ForegroundColor Yellow
        $Staff1_cards1_customUrl = Read-Host -Prompt $i18n.Question_ID_Custom
        $Staff1_cards1_titleResult = $Staff1_cards1_titleQuery
    } else {
        $Staff1_cards1_titleResult = if ($Locale_set -eq "romaji") {
            Get-MALTitle -MALId $Staff1_cards1_malId -English $false
        } elseif ($Locale_set -eq "english") {
            Get-MALTitle -MALId $Staff1_cards1_malId -English $true
        }
        Write-Host $i18n.Selected_Card_Title, $Staff1_cards1_titleResult -ForegroundColor Green
    }
}

if ( 2 -le $Staff1_totalCards ) {
    # Card 2
    Write-Host ""
    $Staff1_cards2_imageUri = Read-Host -Prompt $i18n.Staff_Cards_Url, "(2)"

    if ( $Edition_isSingle -eq "n" ) {
        # Search title on MAL
        $Staff1_cards2_titleQuery = Read-Host -Prompt $i18n.Staff_Cards_Title

        Find-MAL -SearchQuery $Staff1_cards2_titleQuery

        # Get MAL ID
        $Staff1_cards2_malId = Read-Host -Prompt $i18n.Prompt_MALId_Insert
        if (-not($Staff1_cards2_malId)) { $Staff1_cards2_malId = "0" }

        # Manually assign url if MAL ID is 0
        if ($Staff1_cards2_malId -eq "0") {
            Write-Host $i18n.Echo_ID_Custom -ForegroundColor Yellow
            $Staff1_cards2_customUrl = Read-Host -Prompt $i18n.Question_ID_Custom
        $Staff1_cards2_titleResult = $Staff1_cards2_titleQuery
        } else {
            $Staff1_cards2_titleResult = if ($Locale_set -eq "romaji") {
                Get-MALTitle -MALId $Staff1_cards2_malId -English $false
            } elseif ($Locale_set -eq "english") {
                Get-MALTitle -MALId $Staff1_cards2_malId -English $true
            }
            Write-Host $i18n.Selected_Card_Title, $Staff1_cards2_titleResult -ForegroundColor Green
        }
    }
}

if ( 3 -le $Staff1_totalCards ) {
    # Card 3
    Write-Host ""
    $Staff1_cards3_imageUri = Read-Host -Prompt $i18n.Staff_Cards_Url, "(3)"

    if ( $Edition_isSingle -eq "n" ) {
        # Search title on MAL
        $Staff1_cards3_titleQuery = Read-Host -Prompt $i18n.Staff_Cards_Title

        Find-MAL -SearchQuery $Staff1_cards3_titleQuery

        # Get MAL ID
        $Staff1_cards3_malId = Read-Host -Prompt $i18n.Prompt_MALId_Insert
        if (-not($Staff1_cards3_malId)) { $Staff1_cards3_malId = "0" }

        # Manually assign url if MAL ID is 0
        if ($Staff1_cards3_malId -eq "0") {
            Write-Host $i18n.Echo_ID_Custom -ForegroundColor Yellow
            $Staff1_cards3_customUrl = Read-Host -Prompt $i18n.Question_ID_Custom
        $Staff1_cards3_titleResult = $Staff1_cards3_titleQuery
        } else {
            $Staff1_cards3_titleResult = if ($Locale_set -eq "romaji") {
                Get-MALTitle -MALId $Staff1_cards3_malId -English $false
            } elseif ($Locale_set -eq "english") {
                Get-MALTitle -MALId $Staff1_cards3_malId -English $true
            }
            Write-Host $i18n.Selected_Card_Title, $Staff1_cards3_titleResult -ForegroundColor Green
        }
    }
}

if ( 4 -le $Staff1_totalCards ) {
    # Card 4
    Write-Host ""
    $Staff1_cards4_imageUri = Read-Host -Prompt $i18n.Staff_Cards_Url, "(4)"

    if ( $Edition_isSingle -eq "n" ) {
        # Search title on MAL
        $Staff1_cards4_titleQuery = Read-Host -Prompt $i18n.Staff_Cards_Title

        Find-MAL -SearchQuery $Staff1_cards4_titleQuery

        # Get MAL ID
        $Staff1_cards4_malId = Read-Host -Prompt $i18n.Prompt_MALId_Insert
        if (-not($Staff1_cards4_malId)) { $Staff1_cards4_malId = "0" }

        # Manually assign url if MAL ID is 0
        if ($Staff1_cards4_malId -eq "0") {
            Write-Host $i18n.Echo_ID_Custom -ForegroundColor Yellow
            $Staff1_cards4_customUrl = Read-Host -Prompt $i18n.Question_ID_Custom
        $Staff1_cards4_titleResult = $Staff1_cards4_titleQuery
        } else {
            $Staff1_cards4_titleResult = if ($Locale_set -eq "romaji") {
                Get-MALTitle -MALId $Staff1_cards4_malId -English $false
            } elseif ($Locale_set -eq "english") {
                Get-MALTitle -MALId $Staff1_cards4_malId -English $true
            }
            Write-Host $i18n.Selected_Card_Title, $Staff1_cards4_titleResult -ForegroundColor Green
        }
    }
}

if ( 5 -le $Staff1_totalCards ) {
    # Card 5
    Write-Host ""
    $Staff1_cards5_imageUri = Read-Host -Prompt $i18n.Staff_Cards_Url, "(5)"

    if ( $Edition_isSingle -eq "n" ) {
        # Search title on MAL
        $Staff1_cards5_titleQuery = Read-Host -Prompt $i18n.Staff_Cards_Title

        Find-MAL -SearchQuery $Staff1_cards5_titleQuery

        # Get MAL ID
        $Staff1_cards5_malId = Read-Host -Prompt $i18n.Prompt_MALId_Insert
        if (-not($Staff1_cards5_malId)) { $Staff1_cards5_malId = "0" }

        # Manually assign url if MAL ID is 0
        if ($Staff1_cards5_malId -eq "0") {
            Write-Host $i18n.Echo_ID_Custom -ForegroundColor Yellow
            $Staff1_cards5_customUrl = Read-Host -Prompt $i18n.Question_ID_Custom
        $Staff1_cards5_titleResult = $Staff1_cards5_titleQuery
        } else {
            $Staff1_cards5_titleResult = if ($Locale_set -eq "romaji") {
                Get-MALTitle -MALId $Staff1_cards5_malId -English $false
            } elseif ($Locale_set -eq "english") {
                Get-MALTitle -MALId $Staff1_cards5_malId -English $true
            }
            Write-Host $i18n.Selected_Card_Title, $Staff1_cards5_titleResult -ForegroundColor Green
        }
    }
}

if ( 6 -le $Staff1_totalCards ) {
    # Card 6
    Write-Host ""
    $Staff1_cards6_imageUri = Read-Host -Prompt $i18n.Staff_Cards_Url, "(6)"

    if ( $Edition_isSingle -eq "n" ) {
        # Search title on MAL
        $Staff1_cards6_titleQuery = Read-Host -Prompt $i18n.Staff_Cards_Title

        Find-MAL -SearchQuery $Staff1_cards6_titleQuery

        # Get MAL ID
        $Staff1_cards6_malId = Read-Host -Prompt $i18n.Prompt_MALId_Insert
        if (-not($Staff1_cards6_malId)) { $Staff1_cards6_malId = "0" }

        # Manually assign url if MAL ID is 0
        if ($Staff1_cards6_malId -eq "0") {
            Write-Host $i18n.Echo_ID_Custom -ForegroundColor Yellow
            $Staff1_cards6_customUrl = Read-Host -Prompt $i18n.Question_ID_Custom
        $Staff1_cards6_titleResult = $Staff1_cards6_titleQuery
        } else {
            $Staff1_cards6_titleResult = if ($Locale_set -eq "romaji") {
                Get-MALTitle -MALId $Staff1_cards6_malId -English $false
            } elseif ($Locale_set -eq "english") {
                Get-MALTitle -MALId $Staff1_cards6_malId -English $true
            }
            Write-Host $i18n.Selected_Card_Title, $Staff1_cards6_titleResult -ForegroundColor Green
        }
    }
}

if ( 7 -le $Staff1_totalCards ) {
    # Card 7
    Write-Host ""
    $Staff1_cards7_imageUri = Read-Host -Prompt $i18n.Staff_Cards_Url, "(7)"

    if ( $Edition_isSingle -eq "n" ) {
        # Search title on MAL
        $Staff1_cards7_titleQuery = Read-Host -Prompt $i18n.Staff_Cards_Title

        Find-MAL -SearchQuery $Staff1_cards7_titleQuery

        # Get MAL ID
        $Staff1_cards7_malId = Read-Host -Prompt $i18n.Prompt_MALId_Insert
        if (-not($Staff1_cards7_malId)) { $Staff1_cards7_malId = "0" }

        # Manually assign url if MAL ID is 0
        if ($Staff1_cards7_malId -eq "0") {
            Write-Host $i18n.Echo_ID_Custom -ForegroundColor Yellow
            $Staff1_cards7_customUrl = Read-Host -Prompt $i18n.Question_ID_Custom
        $Staff1_cards7_titleResult = $Staff1_cards7_titleQuery
        } else {
            $Staff1_cards7_titleResult = if ($Locale_set -eq "romaji") {
                Get-MALTitle -MALId $Staff1_cards7_malId -English $false
            } elseif ($Locale_set -eq "english") {
                Get-MALTitle -MALId $Staff1_cards7_malId -English $true
            }
            Write-Host $i18n.Selected_Card_Title, $Staff1_cards7_titleResult -ForegroundColor Green
        }
    }
}

if ( 8 -le $Staff1_totalCards ) {
    # Card 8
    Write-Host ""
    $Staff1_cards8_imageUri = Read-Host -Prompt $i18n.Staff_Cards_Url, "(8)"

    if ( $Edition_isSingle -eq "n" ) {
        # Search title on MAL
        $Staff1_cards8_titleQuery = Read-Host -Prompt $i18n.Staff_Cards_Title

        Find-MAL -SearchQuery $Staff1_cards8_titleQuery

        # Get MAL ID
        $Staff1_cards8_malId = Read-Host -Prompt $i18n.Prompt_MALId_Insert
        if (-not($Staff1_cards8_malId)) { $Staff1_cards8_malId = "0" }

        # Manually assign url if MAL ID is 0
        if ($Staff1_cards8_malId -eq "0") {
            Write-Host $i18n.Echo_ID_Custom -ForegroundColor Yellow
            $Staff1_cards8_customUrl = Read-Host -Prompt $i18n.Question_ID_Custom
        $Staff1_cards8_titleResult = $Staff1_cards8_titleQuery
        } else {
            $Staff1_cards8_titleResult = if ($Locale_set -eq "romaji") {
                Get-MALTitle -MALId $Staff1_cards8_malId -English $false
            } elseif ($Locale_set -eq "english") {
                Get-MALTitle -MALId $Staff1_cards8_malId -English $true
            }
            Write-Host $i18n.Selected_Card_Title, $Staff1_cards8_titleResult -ForegroundColor Green
        }
    }
}

if ( 9 -le $Staff1_totalCards ) {
    # Card 9
    Write-Host ""
    $Staff1_cards9_imageUri = Read-Host -Prompt $i18n.Staff_Cards_Url, "(9)"

    if ( $Edition_isSingle -eq "n" ) {
        # Search title on MAL
        $Staff1_cards9_titleQuery = Read-Host -Prompt $i18n.Staff_Cards_Title

        Find-MAL -SearchQuery $Staff1_cards9_titleQuery

        # Get MAL ID
        $Staff1_cards9_malId = Read-Host -Prompt $i18n.Prompt_MALId_Insert
        if (-not($Staff1_cards9_malId)) { $Staff1_cards9_malId = "0" }

        # Manually assign url if MAL ID is 0
        if ($Staff1_cards9_malId -eq "0") {
            Write-Host $i18n.Echo_ID_Custom -ForegroundColor Yellow
            $Staff1_cards9_customUrl = Read-Host -Prompt $i18n.Question_ID_Custom
        $Staff1_cards9_titleResult = $Staff1_cards9_titleQuery
        } else {
            $Staff1_cards9_titleResult = if ($Locale_set -eq "romaji") {
                Get-MALTitle -MALId $Staff1_cards9_malId -English $false
            } elseif ($Locale_set -eq "english") {
                Get-MALTitle -MALId $Staff1_cards9_malId -English $true
            }
            Write-Host $i18n.Selected_Card_Title, $Staff1_cards9_titleResult -ForegroundColor Green
        }
    }
}

# Staff 2
# -------

if (2 -le $Edition_staffCount){
    Write-Host ""
    Write-Host $i18n.Header_Staff_2 -ForegroundColor Blue
    Write-Host "-------------"

    $Staff2_username = Read-Host -Prompt $i18n.Staff_Username
    $Staff2_nickname = Read-Host -Prompt $i18n.Staff_Nickname
    $Staff2_limitType = Read-Host -Prompt $i18n.Staff_Limit_Type

    if ($null -eq $cardSlip.$Staff2_username) {
        Write-Host $i18n.Invalid_Slip -ForegroundColor Red
    } else {
        $Staff2_isAllowSlip = Read-Host -Prompt $i18n.Staff_Allows_Slip_Card
        if(-not($Staff2_isAllowSlip)) { $Staff2_isAllowSlip = "y" }
    }

    if (-not($Staff2_limitType)) { $Staff2_limitType = "role" }

    if ($Staff2_limitType -eq "role") {
        $Staff2_limitStaff = Read-Host -Prompt $i18n.Staff_Limit_Staff
        $Staff2_limitMember = Read-Host -Prompt $i18n.Staff_Limit_Member
    } else {
        $Staff2_limitAny = Read-Host -Prompt $i18n.Staff_Limit_Any
    }

    $Staff2_totalCards = Read-Host -Prompt $i18n.Staff_Limit_Total
    if ($Staff2_totalCards -gt 9) {
        Write-Host $i18n.Invalid_Card_amount -ForegroundColor Red
        $Staff2_totalCards = 9
    }

    # Card 1
    Write-Host ""
    $Staff2_cards1_imageUri = Read-Host -Prompt $i18n.Staff_Cards_Url, "(1)"

    if ( $Edition_isSingle -eq "n" ) {
        # Search title on MAL
        $Staff2_cards1_titleQuery = Read-Host -Prompt $i18n.Staff_Cards_Title

        Find-MAL -SearchQuery $Staff2_cards1_titleQuery

        # Get MAL ID
        $Staff2_cards1_malId = Read-Host -Prompt $i18n.Prompt_MALId_Insert
        if (-not($Staff2_cards1_malId)) { $Staff2_cards1_malId = "0" }

        # Manually assign url if MAL ID is 0
        if ($Staff2_cards1_malId -eq "0") {
            Write-Host $i18n.Echo_ID_Custom -ForegroundColor Yellow
            $Staff2_cards1_customUrl = Read-Host -Prompt $i18n.Question_ID_Custom
                $Staff2_cards1_titleResult = $Staff2_cards1_titleQuery
        } else {
            $Staff2_cards1_titleResult = if ($Locale_set -eq "romaji") {
                Get-MALTitle -MALId $Staff2_cards1_malId -English $false
            } elseif ($Locale_set -eq "english") {
                Get-MALTitle -MALId $Staff2_cards1_malId -English $true
            }
            Write-Host $i18n.Selected_Card_Title, $Staff2_cards1_titleResult -ForegroundColor Green
        }
    }

    if ( 2 -le $Staff2_totalCards ) {
        # Card 2
        Write-Host ""
        $Staff2_cards2_imageUri = Read-Host -Prompt $i18n.Staff_Cards_Url, "(2)"

        if ( $Edition_isSingle -eq "n" ) {
            # Search title on MAL
            $Staff2_cards2_titleQuery = Read-Host -Prompt $i18n.Staff_Cards_Title

            Find-MAL -SearchQuery $Staff2_cards2_titleQuery

            # Get MAL ID
            $Staff2_cards2_malId = Read-Host -Prompt $i18n.Prompt_MALId_Insert
            if (-not($Staff2_cards2_malId)) { $Staff2_cards2_malId = "0" }

            # Manually assign url if MAL ID is 0
            if ($Staff2_cards2_malId -eq "0") {
                Write-Host $i18n.Echo_ID_Custom -ForegroundColor Yellow
                $Staff2_cards2_customUrl = Read-Host -Prompt $i18n.Question_ID_Custom
                $Staff2_cards2_titleResult = $Staff2_cards2_titleQuery
            } else {
                $Staff2_cards2_titleResult = if ($Locale_set -eq "romaji") {
                    Get-MALTitle -MALId $Staff2_cards2_malId -English $false
                } elseif ($Locale_set -eq "english") {
                    Get-MALTitle -MALId $Staff2_cards2_malId -English $true
                }
                Write-Host $i18n.Selected_Card_Title, $Staff2_cards2_titleResult -ForegroundColor Green
            }
        }
    }

    if ( 3 -le $Staff2_totalCards ) {
        # Card 3
        Write-Host ""
        $Staff2_cards3_imageUri = Read-Host -Prompt $i18n.Staff_Cards_Url, "(3)"

        if ( $Edition_isSingle -eq "n" ) {
            # Search title on MAL
            $Staff2_cards3_titleQuery = Read-Host -Prompt $i18n.Staff_Cards_Title

            Find-MAL -SearchQuery $Staff2_cards3_titleQuery

            # Get MAL ID
            $Staff2_cards3_malId = Read-Host -Prompt $i18n.Prompt_MALId_Insert
            if (-not($Staff2_cards3_malId)) { $Staff2_cards3_malId = "0" }

            # Manually assign url if MAL ID is 0
            if ($Staff2_cards3_malId -eq "0") {
                Write-Host $i18n.Echo_ID_Custom -ForegroundColor Yellow
                $Staff2_cards3_customUrl = Read-Host -Prompt $i18n.Question_ID_Custom
                $Staff2_cards3_titleResult = $Staff2_cards3_titleQuery
            } else {
                $Staff2_cards3_titleResult = if ($Locale_set -eq "romaji") {
                    Get-MALTitle -MALId $Staff2_cards3_malId -English $false
                } elseif ($Locale_set -eq "english") {
                    Get-MALTitle -MALId $Staff2_cards3_malId -English $true
                }
                Write-Host $i18n.Selected_Card_Title, $Staff2_cards3_titleResult -ForegroundColor Green
            }
        }
    }

    if ( 4 -le $Staff2_totalCards ) {
        # Card 4
        Write-Host ""
        $Staff2_cards4_imageUri = Read-Host -Prompt $i18n.Staff_Cards_Url, "(4)"

        if ( $Edition_isSingle -eq "n" ) {
            # Search title on MAL
            $Staff2_cards4_titleQuery = Read-Host -Prompt $i18n.Staff_Cards_Title

            Find-MAL -SearchQuery $Staff2_cards4_titleQuery

            # Get MAL ID
            $Staff2_cards4_malId = Read-Host -Prompt $i18n.Prompt_MALId_Insert
            if (-not($Staff2_cards4_malId)) { $Staff2_cards4_malId = "0" }

            # Manually assign url if MAL ID is 0
            if ($Staff2_cards4_malId -eq "0") {
                Write-Host $i18n.Echo_ID_Custom -ForegroundColor Yellow
                $Staff2_cards4_customUrl = Read-Host -Prompt $i18n.Question_ID_Custom
                $Staff2_cards4_titleResult = $Staff2_cards4_titleQuery
            } else {
                $Staff2_cards4_titleResult = if ($Locale_set -eq "romaji") {
                    Get-MALTitle -MALId $Staff2_cards4_malId -English $false
                } elseif ($Locale_set -eq "english") {
                    Get-MALTitle -MALId $Staff2_cards4_malId -English $true
                }
                Write-Host $i18n.Selected_Card_Title, $Staff2_cards4_titleResult -ForegroundColor Green
            }
        }
    }

    if ( 5 -le $Staff2_totalCards ) {
        # Card 5
        Write-Host ""
        $Staff2_cards5_imageUri = Read-Host -Prompt $i18n.Staff_Cards_Url, "(5)"

        if ( $Edition_isSingle -eq "n" ) {
            # Search title on MAL
            $Staff2_cards5_titleQuery = Read-Host -Prompt $i18n.Staff_Cards_Title

            Find-MAL -SearchQuery $Staff2_cards5_titleQuery

            # Get MAL ID
            $Staff2_cards5_malId = Read-Host -Prompt $i18n.Prompt_MALId_Insert
            if (-not($Staff2_cards5_malId)) { $Staff2_cards5_malId = "0" }

            # Manually assign url if MAL ID is 0
            if ($Staff2_cards5_malId -eq "0") {
                Write-Host $i18n.Echo_ID_Custom -ForegroundColor Yellow
                $Staff2_cards5_customUrl = Read-Host -Prompt $i18n.Question_ID_Custom
                $Staff2_cards5_titleResult = $Staff2_cards5_titleQuery
            } else {
                $Staff2_cards5_titleResult = if ($Locale_set -eq "romaji") {
                    Get-MALTitle -MALId $Staff2_cards5_malId -English $false
                } elseif ($Locale_set -eq "english") {
                    Get-MALTitle -MALId $Staff2_cards5_malId -English $true
                }
                Write-Host $i18n.Selected_Card_Title, $Staff2_cards5_titleResult -ForegroundColor Green
            }
        }
    }

    if ( 6 -le $Staff2_totalCards ) {
        # Card 6
        Write-Host ""
        $Staff2_cards6_imageUri = Read-Host -Prompt $i18n.Staff_Cards_Url, "(6)"

        if ( $Edition_isSingle -eq "n" ) {
            # Search title on MAL
            $Staff2_cards6_titleQuery = Read-Host -Prompt $i18n.Staff_Cards_Title

            Find-MAL -SearchQuery $Staff2_cards6_titleQuery

            # Get MAL ID
            $Staff2_cards6_malId = Read-Host -Prompt $i18n.Prompt_MALId_Insert
            if (-not($Staff2_cards6_malId)) { $Staff2_cards6_malId = "0" }

            # Manually assign url if MAL ID is 0
            if ($Staff2_cards6_malId -eq "0") {
                Write-Host $i18n.Echo_ID_Custom -ForegroundColor Yellow
                $Staff2_cards6_customUrl = Read-Host -Prompt $i18n.Question_ID_Custom
                $Staff2_cards6_titleResult = $Staff2_cards6_titleQuery
            } else {
                $Staff2_cards6_titleResult = if ($Locale_set -eq "romaji") {
                    Get-MALTitle -MALId $Staff2_cards6_malId -English $false
                } elseif ($Locale_set -eq "english") {
                    Get-MALTitle -MALId $Staff2_cards6_malId -English $true
                }
                Write-Host $i18n.Selected_Card_Title, $Staff2_cards6_titleResult -ForegroundColor Green
            }
        }
    }

    if ( 7 -le $Staff2_totalCards ) {
        # Card 7
        Write-Host ""
        $Staff2_cards7_imageUri = Read-Host -Prompt $i18n.Staff_Cards_Url, "(7)"

        if ( $Edition_isSingle -eq "n" ) {
            # Search title on MAL
            $Staff2_cards7_titleQuery = Read-Host -Prompt $i18n.Staff_Cards_Title

            Find-MAL -SearchQuery $Staff2_cards7_titleQuery

            # Get MAL ID
            $Staff2_cards7_malId = Read-Host -Prompt $i18n.Prompt_MALId_Insert
            if (-not($Staff2_cards7_malId)) { $Staff2_cards7_malId = "0" }

            # Manually assign url if MAL ID is 0
            if ($Staff2_cards7_malId -eq "0") {
                Write-Host $i18n.Echo_ID_Custom -ForegroundColor Yellow
                $Staff2_cards7_customUrl = Read-Host -Prompt $i18n.Question_ID_Custom
                $Staff2_cards7_titleResult = $Staff2_cards7_titleQuery
            } else {
                $Staff2_cards7_titleResult = if ($Locale_set -eq "romaji") {
                    Get-MALTitle -MALId $Staff2_cards7_malId -English $false
                } elseif ($Locale_set -eq "english") {
                    Get-MALTitle -MALId $Staff2_cards7_malId -English $true
                }
                Write-Host $i18n.Selected_Card_Title, $Staff2_cards7_titleResult -ForegroundColor Green
            }
        }
    }

    if ( 8 -le $Staff2_totalCards ) {
        # Card 8
        Write-Host ""
        $Staff2_cards8_imageUri = Read-Host -Prompt $i18n.Staff_Cards_Url, "(8)"

        if ( $Edition_isSingle -eq "n" ) {
            # Search title on MAL
            $Staff2_cards8_titleQuery = Read-Host -Prompt $i18n.Staff_Cards_Title

            Find-MAL -SearchQuery $Staff2_cards8_titleQuery

            # Get MAL ID
            $Staff2_cards8_malId = Read-Host -Prompt $i18n.Prompt_MALId_Insert
            if (-not($Staff2_cards8_malId)) { $Staff2_cards8_malId = "0" }

            # Manually assign url if MAL ID is 0
            if ($Staff2_cards8_malId -eq "0") {
                Write-Host $i18n.Echo_ID_Custom -ForegroundColor Yellow
                $Staff2_cards8_customUrl = Read-Host -Prompt $i18n.Question_ID_Custom
                $Staff2_cards8_titleResult = $Staff2_cards8_titleQuery
            } else {
                $Staff2_cards8_titleResult = if ($Locale_set -eq "romaji") {
                    Get-MALTitle -MALId $Staff2_cards8_malId -English $false
                } elseif ($Locale_set -eq "english") {
                    Get-MALTitle -MALId $Staff2_cards8_malId -English $true
                }
                Write-Host $i18n.Selected_Card_Title, $Staff2_cards8_titleResult -ForegroundColor Green
            }
        }
    }

    if ( 9 -le $Staff2_totalCards ) {
        # Card 9
        Write-Host ""
        $Staff2_cards9_imageUri = Read-Host -Prompt $i18n.Staff_Cards_Url, "(9)"

        if ( $Edition_isSingle -eq "n" ) {
            # Search title on MAL
            $Staff2_cards9_titleQuery = Read-Host -Prompt $i18n.Staff_Cards_Title

            Find-MAL -SearchQuery $Staff2_cards9_titleQuery

            # Get MAL ID
            $Staff2_cards9_malId = Read-Host -Prompt $i18n.Prompt_MALId_Insert
            if (-not($Staff2_cards9_malId)) { $Staff2_cards9_malId = "0" }

            # Manually assign url if MAL ID is 0
            if ($Staff2_cards9_malId -eq "0") {
                Write-Host $i18n.Echo_ID_Custom -ForegroundColor Yellow
                $Staff2_cards9_customUrl = Read-Host -Prompt $i18n.Question_ID_Custom
                $Staff2_cards9_titleResult = $Staff2_cards9_titleQuery
            } else {
                $Staff2_cards9_titleResult = if ($Locale_set -eq "romaji") {
                    Get-MALTitle -MALId $Staff2_cards9_malId -English $false
                } elseif ($Locale_set -eq "english") {
                    Get-MALTitle -MALId $Staff2_cards9_malId -English $true
                }
                Write-Host $i18n.Selected_Card_Title, $Staff2_cards9_titleResult -ForegroundColor Green
            }
        }
    }
}

# Staff 3
# -------

if (3 -le $Edition_staffCount){
    Write-Host ""
    Write-Host $i18n.Header_Staff_3 -ForegroundColor Blue
    Write-Host "-------------"

    $Staff3_username = Read-Host -Prompt $i18n.Staff_Username
    $Staff3_nickname = Read-Host -Prompt $i18n.Staff_Nickname
    $Staff3_limitType = Read-Host -Prompt $i18n.Staff_Limit_Type

    if ($null -eq $cardSlip.$Staff3_username) {
        Write-Host $i18n.Invalid_Slip -ForegroundColor Red
    } else {
        $Staff3_isAllowSlip = Read-Host -Prompt $i18n.Staff_Allows_Slip_Card
        if(-not($Staff3_isAllowSlip)) { $Staff3_isAllowSlip = "y" }
    }

    if (-not($Staff3_limitType)) { $Staff3_limitType = "role" }

    if ($Staff3_limitType -eq "role") {
        $Staff3_limitStaff = Read-Host -Prompt $i18n.Staff_Limit_Staff
        $Staff3_limitMember = Read-Host -Prompt $i18n.Staff_Limit_Member
    } else {
        $Staff3_limitAny = Read-Host -Prompt $i18n.Staff_Limit_Any
    }

    $Staff3_totalCards = Read-Host -Prompt $i18n.Staff_Limit_Total
    if ($Staff3_totalCards -gt 9) {
        Write-Host $i18n.Invalid_Card_amount -ForegroundColor Red
        $Staff3_totalCards = 9
    }

    # Card 1
    Write-Host ""
    $Staff3_cards1_imageUri = Read-Host -Prompt $i18n.Staff_Cards_Url, "(1)"

    if ( $Edition_isSingle -eq "n" ) {
        # Search title on MAL
        $Staff3_cards1_titleQuery = Read-Host -Prompt $i18n.Staff_Cards_Title

        Find-MAL -SearchQuery $Staff3_cards1_titleQuery

        # Get MAL ID
        $Staff3_cards1_malId = Read-Host -Prompt $i18n.Prompt_MALId_Insert
        if (-not($Staff3_cards1_malId)) { $Staff3_cards1_malId = "0" }

        # Manually assign url if MAL ID is 0
        if ($Staff3_cards1_malId -eq "0") {
            Write-Host $i18n.Echo_ID_Custom -ForegroundColor Yellow
            $Staff3_cards1_customUrl = Read-Host -Prompt $i18n.Question_ID_Custom
                $Staff3_cards1_titleResult = $Staff3_cards1_titleQuery
        } else {
            $Staff3_cards1_titleResult = if ($Locale_set -eq "romaji") {
                Get-MALTitle -MALId $Staff3_cards1_malId -English $false
            } elseif ($Locale_set -eq "english") {
                Get-MALTitle -MALId $Staff3_cards1_malId -English $true
            }
            Write-Host $i18n.Selected_Card_Title, $Staff3_cards1_titleResult -ForegroundColor Green
        }
    }

    if ( 2 -le $Staff3_totalCards ) {
        # Card 2
        Write-Host ""
        $Staff3_cards2_imageUri = Read-Host -Prompt $i18n.Staff_Cards_Url, "(2)"

        if ( $Edition_isSingle -eq "n" ) {
            # Search title on MAL
            $Staff3_cards2_titleQuery = Read-Host -Prompt $i18n.Staff_Cards_Title

            Find-MAL -SearchQuery $Staff3_cards2_titleQuery

            # Get MAL ID
            $Staff3_cards2_malId = Read-Host -Prompt $i18n.Prompt_MALId_Insert
            if (-not($Staff3_cards2_malId)) { $Staff3_cards2_malId = "0" }

            # Manually assign url if MAL ID is 0
            if ($Staff3_cards2_malId -eq "0") {
                Write-Host $i18n.Echo_ID_Custom -ForegroundColor Yellow
                $Staff3_cards2_customUrl = Read-Host -Prompt $i18n.Question_ID_Custom
                $Staff3_cards2_titleResult = $Staff3_cards2_titleQuery
            } else {
                $Staff3_cards2_titleResult = if ($Locale_set -eq "romaji") {
                    Get-MALTitle -MALId $Staff3_cards2_malId -English $false
                } elseif ($Locale_set -eq "english") {
                    Get-MALTitle -MALId $Staff3_cards2_malId -English $true
                }
                Write-Host $i18n.Selected_Card_Title, $Staff3_cards2_titleResult -ForegroundColor Green
            }
        }
    }

    if ( 3 -le $Staff3_totalCards ) {
        # Card 3
        Write-Host ""
        $Staff3_cards3_imageUri = Read-Host -Prompt $i18n.Staff_Cards_Url, "(3)"

        if ( $Edition_isSingle -eq "n" ) {
            # Search title on MAL
            $Staff3_cards3_titleQuery = Read-Host -Prompt $i18n.Staff_Cards_Title

            Find-MAL -SearchQuery $Staff3_cards3_titleQuery

            # Get MAL ID
            $Staff3_cards3_malId = Read-Host -Prompt $i18n.Prompt_MALId_Insert
            if (-not($Staff3_cards3_malId)) { $Staff3_cards3_malId = "0" }

            # Manually assign url if MAL ID is 0
            if ($Staff3_cards3_malId -eq "0") {
                Write-Host $i18n.Echo_ID_Custom -ForegroundColor Yellow
                $Staff3_cards3_customUrl = Read-Host -Prompt $i18n.Question_ID_Custom
                $Staff3_cards3_titleResult = $Staff3_cards3_titleQuery
            } else {
                $Staff3_cards3_titleResult = if ($Locale_set -eq "romaji") {
                    Get-MALTitle -MALId $Staff3_cards3_malId -English $false
                } elseif ($Locale_set -eq "english") {
                    Get-MALTitle -MALId $Staff3_cards3_malId -English $true
                }
                Write-Host $i18n.Selected_Card_Title, $Staff3_cards3_titleResult -ForegroundColor Green
            }
        }
    }

    if ( 4 -le $Staff3_totalCards ) {
        # Card 4
        Write-Host ""
        $Staff3_cards4_imageUri = Read-Host -Prompt $i18n.Staff_Cards_Url, "(4)"

        if ( $Edition_isSingle -eq "n" ) {
            # Search title on MAL
            $Staff3_cards4_titleQuery = Read-Host -Prompt $i18n.Staff_Cards_Title

            Find-MAL -SearchQuery $Staff3_cards4_titleQuery

            # Get MAL ID
            $Staff3_cards4_malId = Read-Host -Prompt $i18n.Prompt_MALId_Insert
            if (-not($Staff3_cards4_malId)) { $Staff3_cards4_malId = "0" }

            # Manually assign url if MAL ID is 0
            if ($Staff3_cards4_malId -eq "0") {
                Write-Host $i18n.Echo_ID_Custom -ForegroundColor Yellow
                $Staff3_cards4_customUrl = Read-Host -Prompt $i18n.Question_ID_Custom
                $Staff3_cards4_titleResult = $Staff3_cards4_titleQuery
            } else {
                $Staff3_cards4_titleResult = if ($Locale_set -eq "romaji") {
                    Get-MALTitle -MALId $Staff3_cards4_malId -English $false
                } elseif ($Locale_set -eq "english") {
                    Get-MALTitle -MALId $Staff3_cards4_malId -English $true
                }
                Write-Host $i18n.Selected_Card_Title, $Staff3_cards4_titleResult -ForegroundColor Green
            }
        }
    }

    if ( 5 -le $Staff3_totalCards ) {
        # Card 5
        Write-Host ""
        $Staff3_cards5_imageUri = Read-Host -Prompt $i18n.Staff_Cards_Url, "(5)"

        if ( $Edition_isSingle -eq "n" ) {
            # Search title on MAL
            $Staff3_cards5_titleQuery = Read-Host -Prompt $i18n.Staff_Cards_Title

            Find-MAL -SearchQuery $Staff3_cards5_titleQuery

            # Get MAL ID
            $Staff3_cards5_malId = Read-Host -Prompt $i18n.Prompt_MALId_Insert
            if (-not($Staff3_cards5_malId)) { $Staff3_cards5_malId = "0" }

            # Manually assign url if MAL ID is 0
            if ($Staff3_cards5_malId -eq "0") {
                Write-Host $i18n.Echo_ID_Custom -ForegroundColor Yellow
                $Staff3_cards5_customUrl = Read-Host -Prompt $i18n.Question_ID_Custom
                $Staff3_cards5_titleResult = $Staff3_cards5_titleQuery
            } else {
                $Staff3_cards5_titleResult = if ($Locale_set -eq "romaji") {
                    Get-MALTitle -MALId $Staff3_cards5_malId -English $false
                } elseif ($Locale_set -eq "english") {
                    Get-MALTitle -MALId $Staff3_cards5_malId -English $true
                }
                Write-Host $i18n.Selected_Card_Title, $Staff3_cards5_titleResult -ForegroundColor Green
            }
        }
    }

    if ( 6 -le $Staff3_totalCards ) {
        # Card 6
        Write-Host ""
        $Staff3_cards6_imageUri = Read-Host -Prompt $i18n.Staff_Cards_Url, "(6)"

        if ( $Edition_isSingle -eq "n" ) {
            # Search title on MAL
            $Staff3_cards6_titleQuery = Read-Host -Prompt $i18n.Staff_Cards_Title

            Find-MAL -SearchQuery $Staff3_cards6_titleQuery

            # Get MAL ID
            $Staff3_cards6_malId = Read-Host -Prompt $i18n.Prompt_MALId_Insert
            if (-not($Staff3_cards6_malId)) { $Staff3_cards6_malId = "0" }

            # Manually assign url if MAL ID is 0
            if ($Staff3_cards6_malId -eq "0") {
                Write-Host $i18n.Echo_ID_Custom -ForegroundColor Yellow
                $Staff3_cards6_customUrl = Read-Host -Prompt $i18n.Question_ID_Custom
                $Staff3_cards6_titleResult = $Staff3_cards6_titleQuery
            } else {
                $Staff3_cards6_titleResult = if ($Locale_set -eq "romaji") {
                    Get-MALTitle -MALId $Staff3_cards6_malId -English $false
                } elseif ($Locale_set -eq "english") {
                    Get-MALTitle -MALId $Staff3_cards6_malId -English $true
                }
                Write-Host $i18n.Selected_Card_Title, $Staff3_cards6_titleResult -ForegroundColor Green
            }
        }
    }

    if ( 7 -le $Staff3_totalCards ) {
        # Card 7
        Write-Host ""
        $Staff3_cards7_imageUri = Read-Host -Prompt $i18n.Staff_Cards_Url, "(7)"

        if ( $Edition_isSingle -eq "n" ) {
            # Search title on MAL
            $Staff3_cards7_titleQuery = Read-Host -Prompt $i18n.Staff_Cards_Title

            Find-MAL -SearchQuery $Staff3_cards7_titleQuery

            # Get MAL ID
            $Staff3_cards7_malId = Read-Host -Prompt $i18n.Prompt_MALId_Insert
            if (-not($Staff3_cards7_malId)) { $Staff3_cards7_malId = "0" }

            # Manually assign url if MAL ID is 0
            if ($Staff3_cards7_malId -eq "0") {
                Write-Host $i18n.Echo_ID_Custom -ForegroundColor Yellow
                $Staff3_cards7_customUrl = Read-Host -Prompt $i18n.Question_ID_Custom
                $Staff3_cards7_titleResult = $Staff3_cards7_titleQuery
            } else {
                $Staff3_cards7_titleResult = if ($Locale_set -eq "romaji") {
                    Get-MALTitle -MALId $Staff3_cards7_malId -English $false
                } elseif ($Locale_set -eq "english") {
                    Get-MALTitle -MALId $Staff3_cards7_malId -English $true
                }
                Write-Host $i18n.Selected_Card_Title, $Staff3_cards7_titleResult -ForegroundColor Green
            }
        }
    }

    if ( 8 -le $Staff3_totalCards ) {
        # Card 8
        Write-Host ""
        $Staff3_cards8_imageUri = Read-Host -Prompt $i18n.Staff_Cards_Url, "(8)"

        if ( $Edition_isSingle -eq "n" ) {
            # Search title on MAL
            $Staff3_cards8_titleQuery = Read-Host -Prompt $i18n.Staff_Cards_Title

            Find-MAL -SearchQuery $Staff3_cards8_titleQuery

            # Get MAL ID
            $Staff3_cards8_malId = Read-Host -Prompt $i18n.Prompt_MALId_Insert
            if (-not($Staff3_cards8_malId)) { $Staff3_cards8_malId = "0" }

            # Manually assign url if MAL ID is 0
            if ($Staff3_cards8_malId -eq "0") {
                Write-Host $i18n.Echo_ID_Custom -ForegroundColor Yellow
                $Staff3_cards8_customUrl = Read-Host -Prompt $i18n.Question_ID_Custom
                $Staff3_cards8_titleResult = $Staff3_cards8_titleQuery
            } else {
                $Staff3_cards8_titleResult = if ($Locale_set -eq "romaji") {
                    Get-MALTitle -MALId $Staff3_cards8_malId -English $false
                } elseif ($Locale_set -eq "english") {
                    Get-MALTitle -MALId $Staff3_cards8_malId -English $true
                }
                Write-Host $i18n.Selected_Card_Title, $Staff3_cards8_titleResult -ForegroundColor Green
            }
        }
    }

    if ( 9 -le $Staff3_totalCards ) {
        # Card 9
        Write-Host ""
        $Staff3_cards9_imageUri = Read-Host -Prompt $i18n.Staff_Cards_Url, "(9)"

        if ( $Edition_isSingle -eq "n" ) {
            # Search title on MAL
            $Staff3_cards9_titleQuery = Read-Host -Prompt $i18n.Staff_Cards_Title

            Find-MAL -SearchQuery $Staff3_cards9_titleQuery

            # Get MAL ID
            $Staff3_cards9_malId = Read-Host -Prompt $i18n.Prompt_MALId_Insert
            if (-not($Staff3_cards9_malId)) { $Staff3_cards9_malId = "0" }

            # Manually assign url if MAL ID is 0
            if ($Staff3_cards9_malId -eq "0") {
                Write-Host $i18n.Echo_ID_Custom -ForegroundColor Yellow
                $Staff3_cards9_customUrl = Read-Host -Prompt $i18n.Question_ID_Custom
                $Staff3_cards9_titleResult = $Staff3_cards9_titleQuery
            } else {
                $Staff3_cards9_titleResult = if ($Locale_set -eq "romaji") {
                    Get-MALTitle -MALId $Staff3_cards9_malId -English $false
                } elseif ($Locale_set -eq "english") {
                    Get-MALTitle -MALId $Staff3_cards9_malId -English $true
                }
                Write-Host $i18n.Selected_Card_Title, $Staff3_cards9_titleResult -ForegroundColor Green
            }
        }
    }
}

# Staff 4
# -------

if (4 -le $Edition_staffCount){
    Write-Host ""
    Write-Host $i18n.Header_Staff_4 -ForegroundColor Blue
    Write-Host "-------------"

    $Staff4_username = Read-Host -Prompt $i18n.Staff_Username
    $Staff4_nickname = Read-Host -Prompt $i18n.Staff_Nickname
    $Staff4_limitType = Read-Host -Prompt $i18n.Staff_Limit_Type

    if ($null -eq $cardSlip.$Staff4_username) {
        Write-Host $i18n.Invalid_Slip -ForegroundColor Red
    } else {
        $Staff4_isAllowSlip = Read-Host -Prompt $i18n.Staff_Allows_Slip_Card
        if(-not($Staff4_isAllowSlip)) { $Staff4_isAllowSlip = "y" }
    }

    if (-not($Staff4_limitType)) { $Staff4_limitType = "role" }

    if ($Staff4_limitType -eq "role") {
        $Staff4_limitStaff = Read-Host -Prompt $i18n.Staff_Limit_Staff
        $Staff4_limitMember = Read-Host -Prompt $i18n.Staff_Limit_Member
    } else {
        $Staff4_limitAny = Read-Host -Prompt $i18n.Staff_Limit_Any
    }

    $Staff4_totalCards = Read-Host -Prompt $i18n.Staff_Limit_Total
    if ($Staff4_totalCards -gt 9) {
        Write-Host $i18n.Invalid_Card_amount -ForegroundColor Red
        $Staff4_totalCards = 9
    }

    # Card 1
    Write-Host ""
    $Staff4_cards1_imageUri = Read-Host -Prompt $i18n.Staff_Cards_Url, "(1)"

    if ( $Edition_isSingle -eq "n" ) {
        # Search title on MAL
        $Staff4_cards1_titleQuery = Read-Host -Prompt $i18n.Staff_Cards_Title

        Find-MAL -SearchQuery $Staff4_cards1_titleQuery

        # Get MAL ID
        $Staff4_cards1_malId = Read-Host -Prompt $i18n.Prompt_MALId_Insert
        if (-not($Staff4_cards1_malId)) { $Staff4_cards1_malId = "0" }

        # Manually assign url if MAL ID is 0
        if ($Staff4_cards1_malId -eq "0") {
            Write-Host $i18n.Echo_ID_Custom -ForegroundColor Yellow
            $Staff4_cards1_customUrl = Read-Host -Prompt $i18n.Question_ID_Custom
                $Staff4_cards1_titleResult = $Staff4_cards1_titleQuery
        } else {
            $Staff4_cards1_titleResult = if ($Locale_set -eq "romaji") {
                Get-MALTitle -MALId $Staff4_cards1_malId -English $false
            } elseif ($Locale_set -eq "english") {
                Get-MALTitle -MALId $Staff4_cards1_malId -English $true
            }
            Write-Host $i18n.Selected_Card_Title, $Staff4_cards1_titleResult -ForegroundColor Green
        }
    }

    if ( 2 -le $Staff4_totalCards ) {
        # Card 2
        Write-Host ""
        $Staff4_cards2_imageUri = Read-Host -Prompt $i18n.Staff_Cards_Url, "(2)"

        if ( $Edition_isSingle -eq "n" ) {
            # Search title on MAL
            $Staff4_cards2_titleQuery = Read-Host -Prompt $i18n.Staff_Cards_Title

            Find-MAL -SearchQuery $Staff4_cards2_titleQuery

            # Get MAL ID
            $Staff4_cards2_malId = Read-Host -Prompt $i18n.Prompt_MALId_Insert
            if (-not($Staff4_cards2_malId)) { $Staff4_cards2_malId = "0" }

            # Manually assign url if MAL ID is 0
            if ($Staff4_cards2_malId -eq "0") {
                Write-Host $i18n.Echo_ID_Custom -ForegroundColor Yellow
                $Staff4_cards2_customUrl = Read-Host -Prompt $i18n.Question_ID_Custom
                $Staff4_cards2_titleResult = $Staff4_cards2_titleQuery
            } else {
                $Staff4_cards2_titleResult = if ($Locale_set -eq "romaji") {
                    Get-MALTitle -MALId $Staff4_cards2_malId -English $false
                } elseif ($Locale_set -eq "english") {
                    Get-MALTitle -MALId $Staff4_cards2_malId -English $true
                }
                Write-Host $i18n.Selected_Card_Title, $Staff4_cards2_titleResult -ForegroundColor Green
            }
        }
    }

    if ( 3 -le $Staff4_totalCards ) {
        # Card 3
        Write-Host ""
        $Staff4_cards3_imageUri = Read-Host -Prompt $i18n.Staff_Cards_Url, "(3)"

        if ( $Edition_isSingle -eq "n" ) {
            # Search title on MAL
            $Staff4_cards3_titleQuery = Read-Host -Prompt $i18n.Staff_Cards_Title

            Find-MAL -SearchQuery $Staff4_cards3_titleQuery

            # Get MAL ID
            $Staff4_cards3_malId = Read-Host -Prompt $i18n.Prompt_MALId_Insert
            if (-not($Staff4_cards3_malId)) { $Staff4_cards3_malId = "0" }

            # Manually assign url if MAL ID is 0
            if ($Staff4_cards3_malId -eq "0") {
                Write-Host $i18n.Echo_ID_Custom -ForegroundColor Yellow
                $Staff4_cards3_customUrl = Read-Host -Prompt $i18n.Question_ID_Custom
                $Staff4_cards3_titleResult = $Staff4_cards3_titleQuery
            } else {
                $Staff4_cards3_titleResult = if ($Locale_set -eq "romaji") {
                    Get-MALTitle -MALId $Staff4_cards3_malId -English $false
                } elseif ($Locale_set -eq "english") {
                    Get-MALTitle -MALId $Staff4_cards3_malId -English $true
                }
                Write-Host $i18n.Selected_Card_Title, $Staff4_cards3_titleResult -ForegroundColor Green
            }
        }
    }

    if ( 4 -le $Staff4_totalCards ) {
        # Card 4
        Write-Host ""
        $Staff4_cards4_imageUri = Read-Host -Prompt $i18n.Staff_Cards_Url, "(4)"

        if ( $Edition_isSingle -eq "n" ) {
            # Search title on MAL
            $Staff4_cards4_titleQuery = Read-Host -Prompt $i18n.Staff_Cards_Title

            Find-MAL -SearchQuery $Staff4_cards4_titleQuery

            # Get MAL ID
            $Staff4_cards4_malId = Read-Host -Prompt $i18n.Prompt_MALId_Insert
            if (-not($Staff4_cards4_malId)) { $Staff4_cards4_malId = "0" }

            # Manually assign url if MAL ID is 0
            if ($Staff4_cards4_malId -eq "0") {
                Write-Host $i18n.Echo_ID_Custom -ForegroundColor Yellow
                $Staff4_cards4_customUrl = Read-Host -Prompt $i18n.Question_ID_Custom
                $Staff4_cards4_titleResult = $Staff4_cards4_titleQuery
            } else {
                $Staff4_cards4_titleResult = if ($Locale_set -eq "romaji") {
                    Get-MALTitle -MALId $Staff4_cards4_malId -English $false
                } elseif ($Locale_set -eq "english") {
                    Get-MALTitle -MALId $Staff4_cards4_malId -English $true
                }
                Write-Host $i18n.Selected_Card_Title, $Staff4_cards4_titleResult -ForegroundColor Green
            }
        }
    }

    if ( 5 -le $Staff4_totalCards ) {
        # Card 5
        Write-Host ""
        $Staff4_cards5_imageUri = Read-Host -Prompt $i18n.Staff_Cards_Url, "(5)"

        if ( $Edition_isSingle -eq "n" ) {
            # Search title on MAL
            $Staff4_cards5_titleQuery = Read-Host -Prompt $i18n.Staff_Cards_Title

            Find-MAL -SearchQuery $Staff4_cards5_titleQuery

            # Get MAL ID
            $Staff4_cards5_malId = Read-Host -Prompt $i18n.Prompt_MALId_Insert
            if (-not($Staff4_cards5_malId)) { $Staff4_cards5_malId = "0" }

            # Manually assign url if MAL ID is 0
            if ($Staff4_cards5_malId -eq "0") {
                Write-Host $i18n.Echo_ID_Custom -ForegroundColor Yellow
                $Staff4_cards5_customUrl = Read-Host -Prompt $i18n.Question_ID_Custom
                $Staff4_cards5_titleResult = $Staff4_cards5_titleQuery
            } else {
                $Staff4_cards5_titleResult = if ($Locale_set -eq "romaji") {
                    Get-MALTitle -MALId $Staff4_cards5_malId -English $false
                } elseif ($Locale_set -eq "english") {
                    Get-MALTitle -MALId $Staff4_cards5_malId -English $true
                }
                Write-Host $i18n.Selected_Card_Title, $Staff4_cards5_titleResult -ForegroundColor Green
            }
        }
    }

    if ( 6 -le $Staff4_totalCards ) {
        # Card 6
        Write-Host ""
        $Staff4_cards6_imageUri = Read-Host -Prompt $i18n.Staff_Cards_Url, "(6)"

        if ( $Edition_isSingle -eq "n" ) {
            # Search title on MAL
            $Staff4_cards6_titleQuery = Read-Host -Prompt $i18n.Staff_Cards_Title

            Find-MAL -SearchQuery $Staff4_cards6_titleQuery

            # Get MAL ID
            $Staff4_cards6_malId = Read-Host -Prompt $i18n.Prompt_MALId_Insert
            if (-not($Staff4_cards6_malId)) { $Staff4_cards6_malId = "0" }

            # Manually assign url if MAL ID is 0
            if ($Staff4_cards6_malId -eq "0") {
                Write-Host $i18n.Echo_ID_Custom -ForegroundColor Yellow
                $Staff4_cards6_customUrl = Read-Host -Prompt $i18n.Question_ID_Custom
                $Staff4_cards6_titleResult = $Staff4_cards6_titleQuery
            } else {
                $Staff4_cards6_titleResult = if ($Locale_set -eq "romaji") {
                    Get-MALTitle -MALId $Staff4_cards6_malId -English $false
                } elseif ($Locale_set -eq "english") {
                    Get-MALTitle -MALId $Staff4_cards6_malId -English $true
                }
                Write-Host $i18n.Selected_Card_Title, $Staff4_cards6_titleResult -ForegroundColor Green
            }
        }
    }

    if ( 7 -le $Staff4_totalCards ) {
        # Card 7
        Write-Host ""
        $Staff4_cards7_imageUri = Read-Host -Prompt $i18n.Staff_Cards_Url, "(7)"

        if ( $Edition_isSingle -eq "n" ) {
            # Search title on MAL
            $Staff4_cards7_titleQuery = Read-Host -Prompt $i18n.Staff_Cards_Title

            Find-MAL -SearchQuery $Staff4_cards7_titleQuery

            # Get MAL ID
            $Staff4_cards7_malId = Read-Host -Prompt $i18n.Prompt_MALId_Insert
            if (-not($Staff4_cards7_malId)) { $Staff4_cards7_malId = "0" }

            # Manually assign url if MAL ID is 0
            if ($Staff4_cards7_malId -eq "0") {
                Write-Host $i18n.Echo_ID_Custom -ForegroundColor Yellow
                $Staff4_cards7_customUrl = Read-Host -Prompt $i18n.Question_ID_Custom
                $Staff4_cards7_titleResult = $Staff4_cards7_titleQuery
            } else {
                $Staff4_cards7_titleResult = if ($Locale_set -eq "romaji") {
                    Get-MALTitle -MALId $Staff4_cards7_malId -English $false
                } elseif ($Locale_set -eq "english") {
                    Get-MALTitle -MALId $Staff4_cards7_malId -English $true
                }
                Write-Host $i18n.Selected_Card_Title, $Staff4_cards7_titleResult -ForegroundColor Green
            }
        }
    }

    if ( 8 -le $Staff4_totalCards ) {
        # Card 8
        Write-Host ""
        $Staff4_cards8_imageUri = Read-Host -Prompt $i18n.Staff_Cards_Url, "(8)"

        if ( $Edition_isSingle -eq "n" ) {
            # Search title on MAL
            $Staff4_cards8_titleQuery = Read-Host -Prompt $i18n.Staff_Cards_Title

            Find-MAL -SearchQuery $Staff4_cards8_titleQuery

            # Get MAL ID
            $Staff4_cards8_malId = Read-Host -Prompt $i18n.Prompt_MALId_Insert
            if (-not($Staff4_cards8_malId)) { $Staff4_cards8_malId = "0" }

            # Manually assign url if MAL ID is 0
            if ($Staff4_cards8_malId -eq "0") {
                Write-Host $i18n.Echo_ID_Custom -ForegroundColor Yellow
                $Staff4_cards8_customUrl = Read-Host -Prompt $i18n.Question_ID_Custom
                $Staff4_cards8_titleResult = $Staff4_cards8_titleQuery
            } else {
                $Staff4_cards8_titleResult = if ($Locale_set -eq "romaji") {
                    Get-MALTitle -MALId $Staff4_cards8_malId -English $false
                } elseif ($Locale_set -eq "english") {
                    Get-MALTitle -MALId $Staff4_cards8_malId -English $true
                }
                Write-Host $i18n.Selected_Card_Title, $Staff4_cards8_titleResult -ForegroundColor Green
            }
        }
    }

    if ( 9 -le $Staff4_totalCards ) {
        # Card 9
        Write-Host ""
        $Staff4_cards9_imageUri = Read-Host -Prompt $i18n.Staff_Cards_Url, "(9)"

        if ( $Edition_isSingle -eq "n" ) {
            # Search title on MAL
            $Staff4_cards9_titleQuery = Read-Host -Prompt $i18n.Staff_Cards_Title

            Find-MAL -SearchQuery $Staff4_cards9_titleQuery

            # Get MAL ID
            $Staff4_cards9_malId = Read-Host -Prompt $i18n.Prompt_MALId_Insert
            if (-not($Staff4_cards9_malId)) { $Staff4_cards9_malId = "0" }

            # Manually assign url if MAL ID is 0
            if ($Staff4_cards9_malId -eq "0") {
                Write-Host $i18n.Echo_ID_Custom -ForegroundColor Yellow
                $Staff4_cards9_customUrl = Read-Host -Prompt $i18n.Question_ID_Custom
                $Staff4_cards9_titleResult = $Staff4_cards9_titleQuery
            } else {
                $Staff4_cards9_titleResult = if ($Locale_set -eq "romaji") {
                    Get-MALTitle -MALId $Staff4_cards9_malId -English $false
                } elseif ($Locale_set -eq "english") {
                    Get-MALTitle -MALId $Staff4_cards9_malId -English $true
                }
                Write-Host $i18n.Selected_Card_Title, $Staff4_cards9_titleResult -ForegroundColor Green
            }
        }
    }
}

# Staff 5
# -------

if (5 -le $Edition_staffCount){
    Write-Host ""
    Write-Host $i18n.Header_Staff_5 -ForegroundColor Blue
    Write-Host "-------------"

    $Staff5_username = Read-Host -Prompt $i18n.Staff_Username
    $Staff5_nickname = Read-Host -Prompt $i18n.Staff_Nickname
    $Staff5_limitType = Read-Host -Prompt $i18n.Staff_Limit_Type

    if ($null -eq $cardSlip.$Staff5_username) {
        Write-Host $i18n.Invalid_Slip -ForegroundColor Red
    } else {
        $Staff5_isAllowSlip = Read-Host -Prompt $i18n.Staff_Allows_Slip_Card
        if(-not($Staff5_isAllowSlip)) { $Staff5_isAllowSlip = "y" }
    }

    if (-not($Staff5_limitType)) { $Staff5_limitType = "role" }

    if ($Staff5_limitType -eq "role") {
        $Staff5_limitStaff = Read-Host -Prompt $i18n.Staff_Limit_Staff
        $Staff5_limitMember = Read-Host -Prompt $i18n.Staff_Limit_Member
    } else {
        $Staff5_limitAny = Read-Host -Prompt $i18n.Staff_Limit_Any
    }

    $Staff5_totalCards = Read-Host -Prompt $i18n.Staff_Limit_Total
    if ($Staff5_totalCards -gt 9) {
        Write-Host $i18n.Invalid_Card_amount -ForegroundColor Red
        $Staff5_totalCards = 9
    }

    # Card 1
    Write-Host ""
    $Staff5_cards1_imageUri = Read-Host -Prompt $i18n.Staff_Cards_Url, "(1)"

    if ( $Edition_isSingle -eq "n" ) {
        # Search title on MAL
        $Staff5_cards1_titleQuery = Read-Host -Prompt $i18n.Staff_Cards_Title

        Find-MAL -SearchQuery $Staff5_cards1_titleQuery

        # Get MAL ID
        $Staff5_cards1_malId = Read-Host -Prompt $i18n.Prompt_MALId_Insert
        if (-not($Staff5_cards1_malId)) { $Staff5_cards1_malId = "0" }

        # Manually assign url if MAL ID is 0
        if ($Staff5_cards1_malId -eq "0") {
            Write-Host $i18n.Echo_ID_Custom -ForegroundColor Yellow
            $Staff5_cards1_customUrl = Read-Host -Prompt $i18n.Question_ID_Custom
                $Staff5_cards1_titleResult = $Staff5_cards1_titleQuery
        } else {
            $Staff5_cards1_titleResult = if ($Locale_set -eq "romaji") {
                Get-MALTitle -MALId $Staff5_cards1_malId -English $false
            } elseif ($Locale_set -eq "english") {
                Get-MALTitle -MALId $Staff5_cards1_malId -English $true
            }
            Write-Host $i18n.Selected_Card_Title, $Staff5_cards1_titleResult -ForegroundColor Green
        }
    }

    if ( 2 -le $Staff5_totalCards ) {
        # Card 2
        Write-Host ""
        $Staff5_cards2_imageUri = Read-Host -Prompt $i18n.Staff_Cards_Url, "(2)"

        if ( $Edition_isSingle -eq "n" ) {
            # Search title on MAL
            $Staff5_cards2_titleQuery = Read-Host -Prompt $i18n.Staff_Cards_Title

            Find-MAL -SearchQuery $Staff5_cards2_titleQuery

            # Get MAL ID
            $Staff5_cards2_malId = Read-Host -Prompt $i18n.Prompt_MALId_Insert
            if (-not($Staff5_cards2_malId)) { $Staff5_cards2_malId = "0" }

            # Manually assign url if MAL ID is 0
            if ($Staff5_cards2_malId -eq "0") {
                Write-Host $i18n.Echo_ID_Custom -ForegroundColor Yellow
                $Staff5_cards2_customUrl = Read-Host -Prompt $i18n.Question_ID_Custom
                $Staff5_cards2_titleResult = $Staff5_cards2_titleQuery
            } else {
                $Staff5_cards2_titleResult = if ($Locale_set -eq "romaji") {
                    Get-MALTitle -MALId $Staff5_cards2_malId -English $false
                } elseif ($Locale_set -eq "english") {
                    Get-MALTitle -MALId $Staff5_cards2_malId -English $true
                }
                Write-Host $i18n.Selected_Card_Title, $Staff5_cards2_titleResult -ForegroundColor Green
            }
        }
    }

    if ( 3 -le $Staff5_totalCards ) {
        # Card 3
        Write-Host ""
        $Staff5_cards3_imageUri = Read-Host -Prompt $i18n.Staff_Cards_Url, "(3)"

        if ( $Edition_isSingle -eq "n" ) {
            # Search title on MAL
            $Staff5_cards3_titleQuery = Read-Host -Prompt $i18n.Staff_Cards_Title

            Find-MAL -SearchQuery $Staff5_cards3_titleQuery

            # Get MAL ID
            $Staff5_cards3_malId = Read-Host -Prompt $i18n.Prompt_MALId_Insert
            if (-not($Staff5_cards3_malId)) { $Staff5_cards3_malId = "0" }

            # Manually assign url if MAL ID is 0
            if ($Staff5_cards3_malId -eq "0") {
                Write-Host $i18n.Echo_ID_Custom -ForegroundColor Yellow
                $Staff5_cards3_customUrl = Read-Host -Prompt $i18n.Question_ID_Custom
                $Staff5_cards3_titleResult = $Staff5_cards3_titleQuery
            } else {
                $Staff5_cards3_titleResult = if ($Locale_set -eq "romaji") {
                    Get-MALTitle -MALId $Staff5_cards3_malId -English $false
                } elseif ($Locale_set -eq "english") {
                    Get-MALTitle -MALId $Staff5_cards3_malId -English $true
                }
                Write-Host $i18n.Selected_Card_Title, $Staff5_cards3_titleResult -ForegroundColor Green
            }
        }
    }

    if ( 4 -le $Staff5_totalCards ) {
        # Card 4
        Write-Host ""
        $Staff5_cards4_imageUri = Read-Host -Prompt $i18n.Staff_Cards_Url, "(4)"

        if ( $Edition_isSingle -eq "n" ) {
            # Search title on MAL
            $Staff5_cards4_titleQuery = Read-Host -Prompt $i18n.Staff_Cards_Title

            Find-MAL -SearchQuery $Staff5_cards4_titleQuery

            # Get MAL ID
            $Staff5_cards4_malId = Read-Host -Prompt $i18n.Prompt_MALId_Insert
            if (-not($Staff5_cards4_malId)) { $Staff5_cards4_malId = "0" }

            # Manually assign url if MAL ID is 0
            if ($Staff5_cards4_malId -eq "0") {
                Write-Host $i18n.Echo_ID_Custom -ForegroundColor Yellow
                $Staff5_cards4_customUrl = Read-Host -Prompt $i18n.Question_ID_Custom
                $Staff5_cards4_titleResult = $Staff5_cards4_titleQuery
            } else {
                $Staff5_cards4_titleResult = if ($Locale_set -eq "romaji") {
                    Get-MALTitle -MALId $Staff5_cards4_malId -English $false
                } elseif ($Locale_set -eq "english") {
                    Get-MALTitle -MALId $Staff5_cards4_malId -English $true
                }
                Write-Host $i18n.Selected_Card_Title, $Staff5_cards4_titleResult -ForegroundColor Green
            }
        }
    }

    if ( 5 -le $Staff5_totalCards ) {
        # Card 5
        Write-Host ""
        $Staff5_cards5_imageUri = Read-Host -Prompt $i18n.Staff_Cards_Url, "(5)"

        if ( $Edition_isSingle -eq "n" ) {
            # Search title on MAL
            $Staff5_cards5_titleQuery = Read-Host -Prompt $i18n.Staff_Cards_Title

            Find-MAL -SearchQuery $Staff5_cards5_titleQuery

            # Get MAL ID
            $Staff5_cards5_malId = Read-Host -Prompt $i18n.Prompt_MALId_Insert
            if (-not($Staff5_cards5_malId)) { $Staff5_cards5_malId = "0" }

            # Manually assign url if MAL ID is 0
            if ($Staff5_cards5_malId -eq "0") {
                Write-Host $i18n.Echo_ID_Custom -ForegroundColor Yellow
                $Staff5_cards5_customUrl = Read-Host -Prompt $i18n.Question_ID_Custom
                $Staff5_cards5_titleResult = $Staff5_cards5_titleQuery
            } else {
                $Staff5_cards5_titleResult = if ($Locale_set -eq "romaji") {
                    Get-MALTitle -MALId $Staff5_cards5_malId -English $false
                } elseif ($Locale_set -eq "english") {
                    Get-MALTitle -MALId $Staff5_cards5_malId -English $true
                }
                Write-Host $i18n.Selected_Card_Title, $Staff5_cards5_titleResult -ForegroundColor Green
            }
        }
    }

    if ( 6 -le $Staff5_totalCards ) {
        # Card 6
        Write-Host ""
        $Staff5_cards6_imageUri = Read-Host -Prompt $i18n.Staff_Cards_Url, "(6)"

        if ( $Edition_isSingle -eq "n" ) {
            # Search title on MAL
            $Staff5_cards6_titleQuery = Read-Host -Prompt $i18n.Staff_Cards_Title

            Find-MAL -SearchQuery $Staff5_cards6_titleQuery

            # Get MAL ID
            $Staff5_cards6_malId = Read-Host -Prompt $i18n.Prompt_MALId_Insert
            if (-not($Staff5_cards6_malId)) { $Staff5_cards6_malId = "0" }

            # Manually assign url if MAL ID is 0
            if ($Staff5_cards6_malId -eq "0") {
                Write-Host $i18n.Echo_ID_Custom -ForegroundColor Yellow
                $Staff5_cards6_customUrl = Read-Host -Prompt $i18n.Question_ID_Custom
                $Staff5_cards6_titleResult = $Staff5_cards6_titleQuery
            } else {
                $Staff5_cards6_titleResult = if ($Locale_set -eq "romaji") {
                    Get-MALTitle -MALId $Staff5_cards6_malId -English $false
                } elseif ($Locale_set -eq "english") {
                    Get-MALTitle -MALId $Staff5_cards6_malId -English $true
                }
                Write-Host $i18n.Selected_Card_Title, $Staff5_cards6_titleResult -ForegroundColor Green
            }
        }
    }

    if ( 7 -le $Staff5_totalCards ) {
        # Card 7
        Write-Host ""
        $Staff5_cards7_imageUri = Read-Host -Prompt $i18n.Staff_Cards_Url, "(7)"

        if ( $Edition_isSingle -eq "n" ) {
            # Search title on MAL
            $Staff5_cards7_titleQuery = Read-Host -Prompt $i18n.Staff_Cards_Title

            Find-MAL -SearchQuery $Staff5_cards7_titleQuery

            # Get MAL ID
            $Staff5_cards7_malId = Read-Host -Prompt $i18n.Prompt_MALId_Insert
            if (-not($Staff5_cards7_malId)) { $Staff5_cards7_malId = "0" }

            # Manually assign url if MAL ID is 0
            if ($Staff5_cards7_malId -eq "0") {
                Write-Host $i18n.Echo_ID_Custom -ForegroundColor Yellow
                $Staff5_cards7_customUrl = Read-Host -Prompt $i18n.Question_ID_Custom
                $Staff5_cards7_titleResult = $Staff5_cards7_titleQuery
            } else {
                $Staff5_cards7_titleResult = if ($Locale_set -eq "romaji") {
                    Get-MALTitle -MALId $Staff5_cards7_malId -English $false
                } elseif ($Locale_set -eq "english") {
                    Get-MALTitle -MALId $Staff5_cards7_malId -English $true
                }
                Write-Host $i18n.Selected_Card_Title, $Staff5_cards7_titleResult -ForegroundColor Green
            }
        }
    }

    if ( 8 -le $Staff5_totalCards ) {
        # Card 8
        Write-Host ""
        $Staff5_cards8_imageUri = Read-Host -Prompt $i18n.Staff_Cards_Url, "(8)"

        if ( $Edition_isSingle -eq "n" ) {
            # Search title on MAL
            $Staff5_cards8_titleQuery = Read-Host -Prompt $i18n.Staff_Cards_Title

            Find-MAL -SearchQuery $Staff5_cards8_titleQuery

            # Get MAL ID
            $Staff5_cards8_malId = Read-Host -Prompt $i18n.Prompt_MALId_Insert
            if (-not($Staff5_cards8_malId)) { $Staff5_cards8_malId = "0" }

            # Manually assign url if MAL ID is 0
            if ($Staff5_cards8_malId -eq "0") {
                Write-Host $i18n.Echo_ID_Custom -ForegroundColor Yellow
                $Staff5_cards8_customUrl = Read-Host -Prompt $i18n.Question_ID_Custom
                $Staff5_cards8_titleResult = $Staff5_cards8_titleQuery
            } else {
                $Staff5_cards8_titleResult = if ($Locale_set -eq "romaji") {
                    Get-MALTitle -MALId $Staff5_cards8_malId -English $false
                } elseif ($Locale_set -eq "english") {
                    Get-MALTitle -MALId $Staff5_cards8_malId -English $true
                }
                Write-Host $i18n.Selected_Card_Title, $Staff5_cards8_titleResult -ForegroundColor Green
            }
        }
    }

    if ( 9 -le $Staff5_totalCards ) {
        # Card 9
        Write-Host ""
        $Staff5_cards9_imageUri = Read-Host -Prompt $i18n.Staff_Cards_Url, "(9)"

        if ( $Edition_isSingle -eq "n" ) {
            # Search title on MAL
            $Staff5_cards9_titleQuery = Read-Host -Prompt $i18n.Staff_Cards_Title

            Find-MAL -SearchQuery $Staff5_cards9_titleQuery

            # Get MAL ID
            $Staff5_cards9_malId = Read-Host -Prompt $i18n.Prompt_MALId_Insert
            if (-not($Staff5_cards9_malId)) { $Staff5_cards9_malId = "0" }

            # Manually assign url if MAL ID is 0
            if ($Staff5_cards9_malId -eq "0") {
                Write-Host $i18n.Echo_ID_Custom -ForegroundColor Yellow
                $Staff5_cards9_customUrl = Read-Host -Prompt $i18n.Question_ID_Custom
                $Staff5_cards9_titleResult = $Staff5_cards9_titleQuery
            } else {
                $Staff5_cards9_titleResult = if ($Locale_set -eq "romaji") {
                    Get-MALTitle -MALId $Staff5_cards9_malId -English $false
                } elseif ($Locale_set -eq "english") {
                    Get-MALTitle -MALId $Staff5_cards9_malId -English $true
                }
                Write-Host $i18n.Selected_Card_Title, $Staff5_cards9_titleResult -ForegroundColor Green
            }
        }
    }
}

# ===============
# Generate Result
# ===============

Clear-Host

# Post Title
# ----------

Write-Host $i18n.Generate_Title_Success -ForegroundColor Green
Write-Host $i18n.Prompt_ToCopy -ForegroundColor Yellow
Write-Host "=============" -ForegroundColor Yellow
Write-Host ""

Write-Host "`[CARDS`]`[OPEN`] $($Edition_emoji) $($Edition_title)"

Write-Host ""
Write-Host "=============" -ForegroundColor Yellow
Read-Host -Prompt $i18n.Prompt_Move_Section

# Post Body 
# ---------
Clear-Host

Write-Host $i18n.Generate_BBCode_Success -ForegroundColor Green
Write-Host $i18n.Prompt_ToCopy -ForegroundColor Yellow
Write-Host "=============" -ForegroundColor Yellow

$result = @"
[color=$($Thread_color)][center][img]$($Banner_imageUrl)[/img]
[size=80][i][b]$(if($Edition_isSingle -eq "y") { "Banner made by @$($Banner_creator)" } else { "[url=$(if($Banner_malId -eq 0) {"$($Banner_customUrl)]$($Banner_titleQuery)[/url]"} else {"https://myanimelist.net/anime/$($Banner_malId)]$($Banner_titleResult)[/url]"}) banner made by @$($Banner_creator)" })　　　　　　　　　　　　　　　　　[url=https://nttds.my.id/tnc-cardfaq]What is a card?[img]https://nttds.my.id/extLink.svg[/img][/url]　　　　　　　　　　　　　　　　　　　　　　　　　　　　　Spaces Remaining: [color=black]$($Edition_count)[/color][/b][/i][/size]
$(if ($DarkMode_warn -eq "n") {"`n`n"} else {@"
[color=white][size=105][b]If you can read this message, please consider to temporarily disable dark mode. Thanks!
Ignore if you're using 3rd party app with auto recolor text support.[/b][/size][/color]
"@})
[quote][b]Opened on[/b]: [color=black]$($Edition_start)[/color] | [b]Close on[/b]: [color=black]$($Edition_end)[/color][/quote][/center][size=120]
　[size=230]💬 [b]Introduction[/b][/size]
[quote][list][color=black][center][img]$($Intro_gif)[/img]$(if ($null -eq $Intro_textFormat) {} else {@"

[i]$($Intro_textFormat)[/i]
"@})[/center][/color][/list][/quote]
　[size=230]🏛️ [b]Rules[/b][/size]
`[quote`]
[center][size=90]⚠️ [b]Make sure to follow all rules stated below before continue![/b] ⚠️[/size][/center][list=1][*][color=black]Request your cards by [u]commenting on this forum thread[/u] and using a list number instead of naming the card.[/color]
[*][color=black]Do not request cards if you have no intention of saving them AND/OR request for someone else.[/color]
[*][color=black]Please [b]follow the format and respect the limits given by each card maker[/b], or the request will be deleted.[/color]
[*][color=black]Due to our current automation limitation, [b]do not change or remove query names[/b]. We will warn you if find any infringement.[/color]
[*][color=black]If you want to claim additional card(s) using slip card AND/OR bonus by requirement from designer, please use plus symbol (+) on additional card(s).[/color]
[*][color=black]In cases where your username is long and ensure your name fits, it's advised to [b]leave a short name/nickname no more than 12 characters/words[/b].[/color]
[*][color=black]Nickname is prioritized for card naming than username if filled.[/color]
[*][color=black][b]Editions are limited to $($Edition_count) requests[/b], so it's first come, first served![/color]
[*][color=black]If you have any question regarding requesting the cards, how it works, or any general questions, please check [url=https://myanimelist.net/forum/?topicid=1983981]Card Guide and FAQ[/url] forum thread.[/color]
[*][color=black]To check delivery progress, please refer to [url=https://myanimelist.net/forum/?topicid=1981019]Card Delivery Tracking[/url] thread.[/color]
[/list][/quote]
　[size=230]🖊️ [b]Template Format[/b][/size]
[quote][size=90]
[center]⚠️ [b]Please to insert text(s) after (on the right of) [[i][/i]/b] tags![/b] ⚠️
Remember: Nickname will be prioritized than username for card naming if filled[/center]
[color=black][code]
[size=90][b]Username: [/b]
[b]Nickname: [/b]
[b]Role: [/b]Member
[b]Deliver to: [/b]Profile Comment/Private Message/Blog Post
[b][i]—Cards by—[/i][/b]
$($Staff1_nickname): $( if ($Edition_staffCount -ge 2) { "`n$($Staff2_nickname): " } else {""} ) $( if ($Edition_staffCount -ge 3) { "`n$($Staff3_nickname): " } else {""} )$( if ($Edition_staffCount -ge 4) { "`n$($Staff4_nickname): " } else {""} )$( if ($Edition_staffCount -ge 5) { "`n$($Staff5_nickname): " } else {""} )
——
[b]Comments: [/b]
[b]Edition Suggestion: [/b]
`[/size`]
`[/code`]
[/color][/size][/quote]
　[size=230]🔍 [b]Example/Result[/b][/size]
[quote][color=black][size=75]
[img]https://i.imgur.com/Hi0NEHE.png[/img]
[url=https://myanimelist.net/profile/un1corn_tnc][img align=left]https://i.imgur.com/Eo8fg86.png[/img][/url][size=20]
[/size][b]Username:[/b] un1corn_tnc
[b]Nickname:[/b] -
[b]Role:[/b] Member
[b]Deliver to:[/b] Profile Comment
[b][i]—Cards by—[/i][/b]
$($Staff1_nickname): $( if ("y" -eq $Staff1_isAllowSlip) {"`[spoiler=slip`]`[img`]$($cardSlip.$Staff1_username)`[/img`]`[/spoiler`]"} )$( if ($Edition_staffCount -ge 2) { "`n$($Staff2_nickname): $( if ("y" -eq $Staff2_isAllowSlip) {"`[spoiler=slip`]`[img`]$($cardSlip.$Staff2_username)`[/img`]`[/spoiler`]"} )" } else {""} ) $( if ($Edition_staffCount -ge 3) { "`n$($Staff3_nickname): $( if ("y" -eq $Staff3_isAllowSlip) {"`[spoiler=slip`]`[img`]$($cardSlip.$Staff3_username)`[/img`]`[/spoiler`]"} )" } else {""} )$( if ($Edition_staffCount -ge 4) { "`n$($Staff4_nickname): $( if ("y" -eq $Staff4_isAllowSlip) {"`[spoiler=slip`]`[img`]$($cardSlip.$Staff4_username)`[/img`]`[/spoiler`]"} )" } else {""} )$( if ($Edition_staffCount -ge 5) { "`n$($Staff5_nickname): $( if ("y" -eq $Staff5_isAllowSlip) {"`[spoiler=slip`]`[img`]$($cardSlip.$Staff5_username)`[/img`]`[/spoiler`]"} )" } else {""} )
——
[b]Comments:[/b] 
[b]Edition Suggestion:[/b] $( if ( $Edition_staffCount -eq 5) { "`n" } else {""} ) $( if ( $Edition_staffCount -eq 4) { "`n`n" } else {""} ) $( if ( $Edition_staffCount -eq 3) { "`n`n`n" } else {""} ) $( if ( $Edition_staffCount -eq 2) { "`n`n`n`n" } else {""} ) $( if ( $Edition_staffCount -eq 1) { "`n`n`n`n`n" } else {""} )
[/size][size=80][right][color=#1d439b]Report[/color] - [color=#1d439b]Quote[/color][/right][/size]
[/color][/quote]
　[size=230]💳 [b]Cards[/b][/size]
[color=black][center][quote]
[size=150][b]$($Staff1_nickname)[/b][/size]
$( if ($Staff1_limitType -eq "role") {@"
[b]Member:[/b] $($Staff1_limitMember)/$($Staff1_totalCards)
[b]Staff:[/b] $($Staff1_limitStaff)/$($Staff1_totalCards) $(if ($Staff1_limitStaff -eq $Staff1_totalCards) {"(ALL)"})
"@} else {"[b]Member & Staff[/b]: $($Staff1_limitAny)/$($Staff1_totalCards) $(if ($Staff1_limitAny -eq $Staff1_totalCards) {"(ALL)"})"} )$(if ("n" -eq $Staff1_isAllowSlip) {@"

`[color=red`]Slip card can not be used on this edition`[/color`]
"@} {})

`[spoiler=cards`]
|| 1 $( if ($Edition_isSingle -eq "y") {"||"} else {"| [url=$(if($Staff1_cards1_malId -eq 0) {$Staff1_cards1_customUrl} else {"https://myanimelist.net/anime/$($Staff1_cards1_malId)"})]$($Staff1_cards1_titleResult)[/url]"})$(if($Staff1_cards2_imageUri) {"|| ~~~~~~ || 2 $( if ($Edition_isSingle -eq "y") {"||"} else {"| [url=$(if($Staff1_cards2_malId -eq 0) {$Staff1_cards2_customUrl} else {"https://myanimelist.net/anime/$($Staff1_cards2_malId)"})]$($Staff1_cards2_titleResult)[/url] ||"})"})
[img]$($Staff1_cards1_imageUri)[/img]$(if($Staff1_cards2_imageUri) {" [img]$($Staff1_cards2_imageUri)[/img]"})$(if($Staff1_cards3_imageUri) {@"

|| 3 $( if ($Edition_isSingle -eq "y") {"||"} else {"| [url=$(if($Staff1_cards3_malId -eq 0) {$Staff1_cards3_customUrl} else {"https://myanimelist.net/anime/$($Staff1_cards3_malId)"})]$($Staff1_cards3_titleResult)[/url]"})$(if($Staff1_cards4_imageUri) {"|| ~~~~~~ || 4 $( if ($Edition_isSingle -eq "y") {"||"} else {"| [url=$(if($Staff1_cards4_malId -eq 0) {$Staff1_cards4_customUrl} else {"https://myanimelist.net/anime/$($Staff1_cards4_malId)"})]$($Staff1_cards4_titleResult)[/url] ||"})"})
[img]$($Staff1_cards3_imageUri)[/img]$(if($Staff1_cards4_imageUri) {" [img]$($Staff1_cards4_imageUri)[/img]"})
"@})$(if($Staff1_cards5_imageUri) {@"

|| 5 $( if ($Edition_isSingle -eq "y") {"||"} else {"| [url=$(if($Staff1_cards5_malId -eq 0) {$Staff1_cards5_customUrl} else {"https://myanimelist.net/anime/$($Staff1_cards5_malId)"})]$($Staff1_cards5_titleResult)[/url]"})$(if($Staff1_cards6_imageUri) {"|| ~~~~~~ || 6 $( if ($Edition_isSingle -eq "y") {"||"} else {"| [url=$(if($Staff1_cards6_malId -eq 0) {$Staff1_cards6_customUrl} else {"https://myanimelist.net/anime/$($Staff1_cards6_malId)"})]$($Staff1_cards6_titleResult)[/url] ||"})"})
[img]$($Staff1_cards5_imageUri)[/img]$(if($Staff1_cards6_imageUri) {" [img]$($Staff1_cards6_imageUri)[/img]"})
"@})$(if($Staff1_cards7_imageUri) {@"

|| 7 $( if ($Edition_isSingle -eq "y") {"||"} else {"| [url=$(if($Staff1_cards7_malId -eq 0) {$Staff1_cards7_customUrl} else {"https://myanimelist.net/anime/$($Staff1_cards7_malId)"})]$($Staff1_cards7_titleResult)[/url]"})$(if($Staff1_cards8_imageUri) {"|| ~~~~~~ || 8 $( if ($Edition_isSingle -eq "y") {"||"} else {"| [url=$(if($Staff1_cards8_malId -eq 0) {$Staff1_cards8_customUrl} else {"https://myanimelist.net/anime/$($Staff1_cards8_malId)"})]$($Staff1_cards8_titleResult)[/url] ||"})"})
[img]$($Staff1_cards7_imageUri)[/img]$(if($Staff1_cards8_imageUri) {" [img]$($Staff1_cards8_imageUri)[/img]"})
"@})$(if($Staff1_cards9_imageUri) {@"

|| 9 $( if ($Edition_isSingle -eq "y") {"||"} else {"| [url=$(if($Staff1_cards9_malId -eq 0) {$Staff1_cards9_customUrl} else {"https://myanimelist.net/anime/$($Staff1_cards9_malId)"})]$($Staff1_cards9_titleResult)[/url] ||"})
[img]$($Staff1_cards9_imageUri)[/img]
"@})
`[/spoiler`]
[/quote]$(if($Staff2_username) {@"
[quote]
[size=150][b]$($Staff2_nickname)[/b][/size]
$( if ($Staff2_limitType -eq "role") {@"
[b]Member:[/b] $($Staff2_limitMember)/$($Staff2_totalCards)
[b]Staff:[/b] $($Staff2_limitStaff)/$($Staff2_totalCards) $(if ($Staff2_limitStaff -eq $Staff2_totalCards) {"(ALL)"})
"@} else {"[b]Member & Staff[/b]: $($Staff2_limitAny)/$($Staff2_totalCards) $(if ($Staff2_limitAny -eq $Staff2_totalCards) {"(ALL)"})"} )$(if ("n" -eq $Staff2_isAllowSlip) {@"

`[color=red`]Slip card can not be used on this edition`[/color`]
"@} {})

`[spoiler=cards`]
|| 1 $( if ($Edition_isSingle -eq "y") {"||"} else {"| [url=$(if($Staff2_cards1_malId -eq 0) {$Staff2_cards1_customUrl} else {"https://myanimelist.net/anime/$($Staff2_cards1_malId)"})]$($Staff2_cards1_titleResult)[/url]"})$(if($Staff2_cards2_imageUri) {"|| ~~~~~~ || 2 $( if ($Edition_isSingle -eq "y") {"||"} else {"| [url=$(if($Staff2_cards2_malId -eq 0) {$Staff2_cards2_customUrl} else {"https://myanimelist.net/anime/$($Staff2_cards2_malId)"})]$($Staff2_cards2_titleResult)[/url] ||"})"})
[img]$($Staff2_cards1_imageUri)[/img]$(if($Staff2_cards2_imageUri) {" [img]$($Staff2_cards2_imageUri)[/img]"})$(if($Staff2_cards3_imageUri) {@"

|| 3 $( if ($Edition_isSingle -eq "y") {"||"} else {"| [url=$(if($Staff2_cards3_malId -eq 0) {$Staff2_cards3_customUrl} else {"https://myanimelist.net/anime/$($Staff2_cards3_malId)"})]$($Staff2_cards3_titleResult)[/url]"})$(if($Staff2_cards4_imageUri) {"|| ~~~~~~ || 4 $( if ($Edition_isSingle -eq "y") {"||"} else {"| [url=$(if($Staff2_cards4_malId -eq 0) {$Staff2_cards4_customUrl} else {"https://myanimelist.net/anime/$($Staff2_cards4_malId)"})]$($Staff2_cards4_titleResult)[/url] ||"})"})
[img]$($Staff2_cards3_imageUri)[/img]$(if($Staff2_cards4_imageUri) {" [img]$($Staff2_cards4_imageUri)[/img]"})
"@})$(if($Staff2_cards5_imageUri) {@"

|| 5 $( if ($Edition_isSingle -eq "y") {"||"} else {"| [url=$(if($Staff2_cards5_malId -eq 0) {$Staff2_cards5_customUrl} else {"https://myanimelist.net/anime/$($Staff2_cards5_malId)"})]$($Staff2_cards5_titleResult)[/url]"})$(if($Staff2_cards6_imageUri) {"|| ~~~~~~ || 6 $( if ($Edition_isSingle -eq "y") {"||"} else {"| [url=$(if($Staff2_cards6_malId -eq 0) {$Staff2_cards6_customUrl} else {"https://myanimelist.net/anime/$($Staff2_cards6_malId)"})]$($Staff2_cards6_titleResult)[/url] ||"})"})
[img]$($Staff2_cards5_imageUri)[/img]$(if($Staff2_cards6_imageUri) {" [img]$($Staff2_cards6_imageUri)[/img]"})
"@})$(if($Staff2_cards7_imageUri) {@"

|| 7 $( if ($Edition_isSingle -eq "y") {"||"} else {"| [url=$(if($Staff2_cards7_malId -eq 0) {$Staff2_cards7_customUrl} else {"https://myanimelist.net/anime/$($Staff2_cards7_malId)"})]$($Staff2_cards7_titleResult)[/url]"})$(if($Staff2_cards8_imageUri) {"|| ~~~~~~ || 8 $( if ($Edition_isSingle -eq "y") {"||"} else {"| [url=$(if($Staff2_cards8_malId -eq 0) {$Staff2_cards8_customUrl} else {"https://myanimelist.net/anime/$($Staff2_cards8_malId)"})]$($Staff2_cards8_titleResult)[/url] ||"})"})
[img]$($Staff2_cards7_imageUri)[/img]$(if($Staff2_cards8_imageUri) {" [img]$($Staff2_cards8_imageUri)[/img]"})
"@})$(if($Staff2_cards9_imageUri) {@"

|| 9 $( if ($Edition_isSingle -eq "y") {"||"} else {"| [url=$(if($Staff2_cards9_malId -eq 0) {$Staff2_cards9_customUrl} else {"https://myanimelist.net/anime/$($Staff2_cards9_malId)"})]$($Staff2_cards9_titleResult)[/url] ||"})
[img]$($Staff2_cards9_imageUri)[/img]
"@})
`[/spoiler`]
[/quote]$(if($Staff3_username) {@"
[quote]
[size=150][b]$($Staff3_nickname)[/b][/size]
$( if ($Staff3_limitType -eq "role") {@"
[b]Member:[/b] $($Staff3_limitMember)/$($Staff3_totalCards)
[b]Staff:[/b] $($Staff3_limitStaff)/$($Staff3_totalCards) $(if ($Staff3_limitStaff -eq $Staff3_totalCards) {"(ALL)"})
"@} else {"[b]Member & Staff[/b]: $($Staff3_limitAny)/$($Staff3_totalCards) $(if ($Staff3_limitAny -eq $Staff3_totalCards) {"(ALL)"})"} )$(if ("n" -eq $Staff3_isAllowSlip) {@"

`[color=red`]Slip card can not be used on this edition`[/color`]
"@} {})

`[spoiler=cards`]
|| 1 $( if ($Edition_isSingle -eq "y") {"||"} else {"| [url=$(if($Staff3_cards1_malId -eq 0) {$Staff3_cards1_customUrl} else {"https://myanimelist.net/anime/$($Staff3_cards1_malId)"})]$($Staff3_cards1_titleResult)[/url]"})$(if($Staff3_cards2_imageUri) {"|| ~~~~~~ || 2 $( if ($Edition_isSingle -eq "y") {"||"} else {"| [url=$(if($Staff3_cards2_malId -eq 0) {$Staff3_cards2_customUrl} else {"https://myanimelist.net/anime/$($Staff3_cards2_malId)"})]$($Staff3_cards2_titleResult)[/url] ||"})"})
[img]$($Staff3_cards1_imageUri)[/img]$(if($Staff3_cards2_imageUri) {" [img]$($Staff3_cards2_imageUri)[/img]"})$(if($Staff3_cards3_imageUri) {@"

|| 3 $( if ($Edition_isSingle -eq "y") {"||"} else {"| [url=$(if($Staff3_cards3_malId -eq 0) {$Staff3_cards3_customUrl} else {"https://myanimelist.net/anime/$($Staff3_cards3_malId)"})]$($Staff3_cards3_titleResult)[/url]"})$(if($Staff3_cards4_imageUri) {"|| ~~~~~~ || 4 $( if ($Edition_isSingle -eq "y") {"||"} else {"| [url=$(if($Staff3_cards4_malId -eq 0) {$Staff3_cards4_customUrl} else {"https://myanimelist.net/anime/$($Staff3_cards4_malId)"})]$($Staff3_cards4_titleResult)[/url] ||"})"})
[img]$($Staff3_cards3_imageUri)[/img]$(if($Staff3_cards4_imageUri) {" [img]$($Staff3_cards4_imageUri)[/img]"})
"@})$(if($Staff3_cards5_imageUri) {@"

|| 5 $( if ($Edition_isSingle -eq "y") {"||"} else {"| [url=$(if($Staff3_cards5_malId -eq 0) {$Staff3_cards5_customUrl} else {"https://myanimelist.net/anime/$($Staff3_cards5_malId)"})]$($Staff3_cards5_titleResult)[/url]"})$(if($Staff3_cards6_imageUri) {"|| ~~~~~~ || 6 $( if ($Edition_isSingle -eq "y") {"||"} else {"| [url=$(if($Staff3_cards6_malId -eq 0) {$Staff3_cards6_customUrl} else {"https://myanimelist.net/anime/$($Staff3_cards6_malId)"})]$($Staff3_cards6_titleResult)[/url] ||"})"})
[img]$($Staff3_cards5_imageUri)[/img]$(if($Staff3_cards6_imageUri) {" [img]$($Staff3_cards6_imageUri)[/img]"})
"@})$(if($Staff3_cards7_imageUri) {@"

|| 7 $( if ($Edition_isSingle -eq "y") {"||"} else {"| [url=$(if($Staff3_cards7_malId -eq 0) {$Staff3_cards7_customUrl} else {"https://myanimelist.net/anime/$($Staff3_cards7_malId)"})]$($Staff3_cards7_titleResult)[/url]"})$(if($Staff3_cards8_imageUri) {"|| ~~~~~~ || 8 $( if ($Edition_isSingle -eq "y") {"||"} else {"| [url=$(if($Staff3_cards8_malId -eq 0) {$Staff3_cards8_customUrl} else {"https://myanimelist.net/anime/$($Staff3_cards8_malId)"})]$($Staff3_cards8_titleResult)[/url] ||"})"})
[img]$($Staff3_cards7_imageUri)[/img]$(if($Staff3_cards8_imageUri) {" [img]$($Staff3_cards8_imageUri)[/img]"})
"@})$(if($Staff3_cards9_imageUri) {@"

|| 9 $( if ($Edition_isSingle -eq "y") {"||"} else {"| [url=$(if($Staff3_cards9_malId -eq 0) {$Staff3_cards9_customUrl} else {"https://myanimelist.net/anime/$($Staff3_cards9_malId)"})]$($Staff3_cards9_titleResult)[/url] ||"})
[img]$($Staff3_cards9_imageUri)[/img]
"@})
`[/spoiler`]
[/quote]$(if($Staff4_username) {@"
[quote]
[size=150][b]$($Staff4_nickname)[/b][/size]
$( if ($Staff4_limitType -eq "role") {@"
[b]Member:[/b] $($Staff4_limitMember)/$($Staff4_totalCards)
[b]Staff:[/b] $($Staff4_limitStaff)/$($Staff4_totalCards) $(if ($Staff4_limitStaff -eq $Staff4_totalCards) {"(ALL)"})
"@} else {"[b]Member & Staff[/b]: $($Staff4_limitAny)/$($Staff4_totalCards) $(if ($Staff4_limitAny -eq $Staff4_totalCards) {"(ALL)"})"} )$(if ("n" -eq $Staff4_isAllowSlip) {@"

`[color=red`]Slip card can not be used on this edition`[/color`]
"@} {})

`[spoiler=cards`]
|| 1 $( if ($Edition_isSingle -eq "y") {"||"} else {"| [url=$(if($Staff4_cards1_malId -eq 0) {$Staff4_cards1_customUrl} else {"https://myanimelist.net/anime/$($Staff4_cards1_malId)"})]$($Staff4_cards1_titleResult)[/url]"})$(if($Staff4_cards2_imageUri) {"|| ~~~~~~ || 2 $( if ($Edition_isSingle -eq "y") {"||"} else {"| [url=$(if($Staff4_cards2_malId -eq 0) {$Staff4_cards2_customUrl} else {"https://myanimelist.net/anime/$($Staff4_cards2_malId)"})]$($Staff4_cards2_titleResult)[/url] ||"})"})
[img]$($Staff4_cards1_imageUri)[/img]$(if($Staff4_cards2_imageUri) {" [img]$($Staff4_cards2_imageUri)[/img]"})$(if($Staff4_cards3_imageUri) {@"

|| 3 $( if ($Edition_isSingle -eq "y") {"||"} else {"| [url=$(if($Staff4_cards3_malId -eq 0) {$Staff4_cards3_customUrl} else {"https://myanimelist.net/anime/$($Staff4_cards3_malId)"})]$($Staff4_cards3_titleResult)[/url]"})$(if($Staff4_cards4_imageUri) {"|| ~~~~~~ || 4 $( if ($Edition_isSingle -eq "y") {"||"} else {"| [url=$(if($Staff4_cards4_malId -eq 0) {$Staff4_cards4_customUrl} else {"https://myanimelist.net/anime/$($Staff4_cards4_malId)"})]$($Staff4_cards4_titleResult)[/url] ||"})"})
[img]$($Staff4_cards3_imageUri)[/img]$(if($Staff4_cards4_imageUri) {" [img]$($Staff4_cards4_imageUri)[/img]"})
"@})$(if($Staff4_cards5_imageUri) {@"

|| 5 $( if ($Edition_isSingle -eq "y") {"||"} else {"| [url=$(if($Staff4_cards5_malId -eq 0) {$Staff4_cards5_customUrl} else {"https://myanimelist.net/anime/$($Staff4_cards5_malId)"})]$($Staff4_cards5_titleResult)[/url]"})$(if($Staff4_cards6_imageUri) {"|| ~~~~~~ || 6 $( if ($Edition_isSingle -eq "y") {"||"} else {"| [url=$(if($Staff4_cards6_malId -eq 0) {$Staff4_cards6_customUrl} else {"https://myanimelist.net/anime/$($Staff4_cards6_malId)"})]$($Staff4_cards6_titleResult)[/url] ||"})"})
[img]$($Staff4_cards5_imageUri)[/img]$(if($Staff4_cards6_imageUri) {" [img]$($Staff4_cards6_imageUri)[/img]"})
"@})$(if($Staff4_cards7_imageUri) {@"

|| 7 $( if ($Edition_isSingle -eq "y") {"||"} else {"| [url=$(if($Staff4_cards7_malId -eq 0) {$Staff4_cards7_customUrl} else {"https://myanimelist.net/anime/$($Staff4_cards7_malId)"})]$($Staff4_cards7_titleResult)[/url]"})$(if($Staff4_cards8_imageUri) {"|| ~~~~~~ || 8 $( if ($Edition_isSingle -eq "y") {"||"} else {"| [url=$(if($Staff4_cards8_malId -eq 0) {$Staff4_cards8_customUrl} else {"https://myanimelist.net/anime/$($Staff4_cards8_malId)"})]$($Staff4_cards8_titleResult)[/url] ||"})"})
[img]$($Staff4_cards7_imageUri)[/img]$(if($Staff4_cards8_imageUri) {" [img]$($Staff4_cards8_imageUri)[/img]"})
"@})$(if($Staff4_cards9_imageUri) {@"

|| 9 $( if ($Edition_isSingle -eq "y") {"||"} else {"| [url=$(if($Staff4_cards9_malId -eq 0) {$Staff4_cards9_customUrl} else {"https://myanimelist.net/anime/$($Staff4_cards9_malId)"})]$($Staff4_cards9_titleResult)[/url] ||"})
[img]$($Staff4_cards9_imageUri)[/img]
"@})
`[/spoiler`]
[/quote]$(if($Staff5_username) {@"
[quote]
[size=150][b]$($Staff5_nickname)[/b][/size]
$( if ($Staff5_limitType -eq "role") {@"
[b]Member:[/b] $($Staff5_limitMember)/$($Staff5_totalCards)
[b]Staff:[/b] $($Staff5_limitStaff)/$($Staff5_totalCards) $(if ($Staff5_limitStaff -eq $Staff5_totalCards) {"(ALL)"})
"@} else {"[b]Member & Staff[/b]: $($Staff5_limitAny)/$($Staff5_totalCards) $(if ($Staff5_limitAny -eq $Staff5_totalCards) {"(ALL)"})"} )$(if ("n" -eq $Staff5_isAllowSlip) {@"

`[color=red`]Slip card can not be used on this edition`[/color`]
"@} {})

`[spoiler=cards`]
|| 1 $( if ($Edition_isSingle -eq "y") {"||"} else {"| [url=$(if($Staff5_cards1_malId -eq 0) {$Staff5_cards1_customUrl} else {"https://myanimelist.net/anime/$($Staff5_cards1_malId)"})]$($Staff5_cards1_titleResult)[/url]"})$(if($Staff5_cards2_imageUri) {"|| ~~~~~~ || 2 $( if ($Edition_isSingle -eq "y") {"||"} else {"| [url=$(if($Staff5_cards2_malId -eq 0) {$Staff5_cards2_customUrl} else {"https://myanimelist.net/anime/$($Staff5_cards2_malId)"})]$($Staff5_cards2_titleResult)[/url] ||"})"})
[img]$($Staff5_cards1_imageUri)[/img]$(if($Staff5_cards2_imageUri) {" [img]$($Staff5_cards2_imageUri)[/img]"})$(if($Staff5_cards3_imageUri) {@"

|| 3 $( if ($Edition_isSingle -eq "y") {"||"} else {"| [url=$(if($Staff5_cards3_malId -eq 0) {$Staff5_cards3_customUrl} else {"https://myanimelist.net/anime/$($Staff5_cards3_malId)"})]$($Staff5_cards3_titleResult)[/url]"})$(if($Staff5_cards4_imageUri) {"|| ~~~~~~ || 4 $( if ($Edition_isSingle -eq "y") {"||"} else {"| [url=$(if($Staff5_cards4_malId -eq 0) {$Staff5_cards4_customUrl} else {"https://myanimelist.net/anime/$($Staff5_cards4_malId)"})]$($Staff5_cards4_titleResult)[/url] ||"})"})
[img]$($Staff5_cards3_imageUri)[/img]$(if($Staff5_cards4_imageUri) {" [img]$($Staff5_cards4_imageUri)[/img]"})
"@})$(if($Staff5_cards5_imageUri) {@"

|| 5 $( if ($Edition_isSingle -eq "y") {"||"} else {"| [url=$(if($Staff5_cards5_malId -eq 0) {$Staff5_cards5_customUrl} else {"https://myanimelist.net/anime/$($Staff5_cards5_malId)"})]$($Staff5_cards5_titleResult)[/url]"})$(if($Staff5_cards6_imageUri) {"|| ~~~~~~ || 6 $( if ($Edition_isSingle -eq "y") {"||"} else {"| [url=$(if($Staff5_cards6_malId -eq 0) {$Staff5_cards6_customUrl} else {"https://myanimelist.net/anime/$($Staff5_cards6_malId)"})]$($Staff5_cards6_titleResult)[/url] ||"})"})
[img]$($Staff5_cards5_imageUri)[/img]$(if($Staff5_cards6_imageUri) {" [img]$($Staff5_cards6_imageUri)[/img]"})
"@})$(if($Staff5_cards7_imageUri) {@"

|| 7 $( if ($Edition_isSingle -eq "y") {"||"} else {"| [url=$(if($Staff5_cards7_malId -eq 0) {$Staff5_cards7_customUrl} else {"https://myanimelist.net/anime/$($Staff5_cards7_malId)"})]$($Staff5_cards7_titleResult)[/url]"})$(if($Staff5_cards8_imageUri) {"|| ~~~~~~ || 8 $( if ($Edition_isSingle -eq "y") {"||"} else {"| [url=$(if($Staff5_cards8_malId -eq 0) {$Staff5_cards8_customUrl} else {"https://myanimelist.net/anime/$($Staff5_cards8_malId)"})]$($Staff5_cards8_titleResult)[/url] ||"})"})
[img]$($Staff5_cards7_imageUri)[/img]$(if($Staff5_cards8_imageUri) {" [img]$($Staff5_cards8_imageUri)[/img]"})
"@})$(if($Staff5_cards9_imageUri) {@"

|| 9 $( if ($Edition_isSingle -eq "y") {"||"} else {"| [url=$(if($Staff5_cards9_malId -eq 0) {$Staff5_cards9_customUrl} else {"https://myanimelist.net/anime/$($Staff5_cards9_malId)"})]$($Staff5_cards9_titleResult)[/url] ||"})
[img]$($Staff5_cards9_imageUri)[/img]
"@})
`[/spoiler`]
[/quote][/center][/color]
"@})
"@} else {"[/center][/color]"})
"@} else {"[/center][/color]"})
"@} else {"[/center][/color]"})
　[size=180]🎉 [b]Happy Requesting![/b][/size][quote][list][color=black][b]From yours truly, the Graphic Design team[/b][/color]
[/list][/quote]
[center][size=80][quote][color=black]
[size=150]We're currently looking for new [b]designers/card makers and card delivery[/b] staff!
[img]https://64.media.tumblr.com/d1d7c7b1ba2a80944ae58f896cc03565/tumblr_inline_mpedfqsfBF1qz4rgp.gif[/img] Click [url=https://myanimelist.net/forum/?topicid=1711795][b]here[/b][/url] if you're interested in  joining the team! [img]https://64.media.tumblr.com/7784d381ee5756f89e31aad30dcfec00/tumblr_inline_mpedfns0uS1qz4rgp.gif[/img]
DM @$($gfxAdmin) or @$($gfxDeputy) for any questions[/size]

[/color][/quote]
[color=black]Cards made by @$($Staff1_username)$(if($Staff2_username) {", @$($Staff2_username)$(if($Staff3_username) {", @$($Staff3_username)$(if($Staff4_username) {", @$($Staff4_username)$(if($Staff5_username) {", @$($Staff5_username)"} else {"."})"} else {"."})"} else {"."})"} else {"."})[/color][/size]
`[/center`]
[/size][/color]


For internal use only:
`###SCRAPEDATA>>$($Edition_title)>>>$($Staff1_nickname);$(if ($Staff2_username) {$Staff2_nickname} else {"0"});$(if ($Staff3_username) {$Staff3_nickname} else {"0"});$(if ($Staff4_username) {$Staff4_nickname} else {"0"});$(if ($Staff5_username) {$Staff5_nickname} else {"0"})
>>>MAX>>$($Edition_count)
>>>LIM>>$( if ($Staff1_limitType -eq "role") {"$($Staff1_limitMember)|$($Staff1_limitStaff)"} else {$($Staff1_limitAny)});$( if ($Staff2_username) {if ($Staff2_limitType -eq "role") {"$($Staff2_limitMember)|$($Staff2_limitStaff)"} else {$($Staff2_limitAny)}} else {"0"});$( if ($Staff3_username) {if ($Staff3_limitType -eq "role") {"$($Staff3_limitMember)|$($Staff3_limitStaff)"} else {$($Staff3_limitAny)}} else {"0"});$( if ($Staff4_username) {if ($Staff4_limitType -eq "role") {"$($Staff4_limitMember)|$($Staff4_limitStaff)"} else {$($Staff4_limitAny)}} else {"0"});$( if ($Staff5_username) {if ($Staff5_limitType -eq "role") {"$($Staff5_limitMember)|$($Staff5_limitStaff)"} else {$($Staff5_limitAny)}} else {"0"})
>>>AVA>>$($Staff1_totalCards);$( if ($Staff2_username) {$Staff2_totalCards} else {"0"});$( if ($Staff3_username) {$Staff3_totalCards} else {"0"});$( if ($Staff4_username) {$Staff4_totalCards} else {"0"});$( if ($Staff5_username) {$Staff5_totalCards} else {"0"})###
@#Generated with [url=https://github.com/theNewbieClub-MAL/editionThreadGenerator-ps1]GitHub:theNewbieClub-MAL/editionThreadGenerator-ps1[/url]@[i][/i]v$($version) in Powershell on $(Get-Date -AsUtc -Format "yyyy-MM-ddTHH:mm:ssZ")#@
"@

Write-Host $result
$result > ./Generated.bbcode

Write-Host "=============" -ForegroundColor Yellow
Write-Host $i18n.Attention_File_Created_1, "`"$((Get-Location).Path)/Generated.bbcode`"", $i18n.Attention_File_Created_2 -ForegroundColor Blue -Separator " "
Read-Host -Prompt $i18n.Prompt_Move_Section

# Post GFX Reqeust Field
# ----------------------
Clear-Host

Write-Host $i18n.Generate_GFXRequest_Success -ForegroundColor Green
Write-Host $i18n.Prompt_ToCopy -ForegroundColor Yellow
Write-Host "=============" -ForegroundColor Yellow

Write-Host @"
[size=120]　[size=230][color=$($Thread_color)]💬 [b]GFX and Deliverer Staff Request[/b][/color][/size][/size][quote][center]
[size=120][color=$($Thread_color)][i]For GFX staff who hasn't send the format yet, please DM me, and insert template to message using [[i][/i]code] tag.[/i][/color][/size]

`[spoiler=requests`]
[code][quote][b]Staff Nickname: [/b] 
[b]Delivery: [/b] 
[i]—Cards by—[/i]
$($Staff1_nickname): $( if ($Edition_staffCount -ge 2) { "`n$($Staff2_nickname): " } else {""} ) $( if ($Edition_staffCount -ge 3) { "`n$($Staff3_nickname): " } else {""} )$( if ($Edition_staffCount -ge 4) { "`n$($Staff4_nickname): " } else {""} )$( if ($Edition_staffCount -ge 5) { "`n$($Staff5_nickname): " } else {""} )
--
[b]Comments: [/b] 
[b]Edition Suggestion: [/b] 
[/quote][/code]

`[/spoiler`]
[/center][/quote]
"@

Write-Host "=============" -ForegroundColor Yellow
Read-Host -Prompt $i18n.Prompt_Exit_Script

# ===========
# Exit Script
# ===========

Clear-Host

exit 0
