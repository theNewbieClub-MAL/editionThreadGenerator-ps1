Function Get-RandomBanner {
    if (Test-Path ./Resources/Banners) {
        $randomBanner = (Get-ChildItem -Path ./Resources/Banners/ | Get-Random).Name
        Write-Verbose "$($randomBanner) has been set"
        Write-Output $randomBanner
    } else {
        $WarningMessage = "./Resources/Banners can not be found on $(Get-Location)"
        Write-Information $WarningMessage -ForegroundColor Red
    }

    <#
        .SYNOPSIS
        Get Random Banner placeholder filename

        .DESCRIPTION
        Get Random Banner placeholder filename that is available on ./Resources/Banners

        .EXAMPLE
        PS> Get-RandomBanner
        un1corn_tnc@banner1_v1.png

        .NOTES
        Function will not work if ./Resources/Banners directory is not exist.

        .LINK
        Get-RandomCard

        .LINK
        Get-WorkStaff
    #>

}

Function Get-RandomCard {
    if (Test-Path ./Resources/Cards) {
        $randomCard = (Get-ChildItem -Path ./Resources/Cards/ | Get-Random).Name
        Write-Verbose "$($randomCard) has been set"
        Write-Output $randomCard
    } else {
        $WarningMessage = "./Resources/Cards can not be found on $(Get-Location)"
        Write-Information $WarningMessage -ForegroundColor Red
    }

    <#
        .SYNOPSIS
        Get Random Card placeholder filename

        .DESCRIPTION
        Get Random Card placeholder filename that is available on ./Resources/Cards

        .EXAMPLE
        PS> Get-RandomCard
        un1corn_tnc@cards1_v1.png

        .NOTES
        Function will not work if ./Resources/Cards directory is not exist.

        .LINK
        Get-RandomBanner

        .LINK
        Get-WorkStaff
    #>
}

Function Get-WorkStaff {
    param (
        [Parameter(Mandatory=$true)]
        [string]$FileName
    )

    Write-Output "$([regex]::Match($FileName, "^[\w\-_]{2,16}").Groups[0].Value)"
    <#
        .SYNOPSIS
        Extract staff name from file with RegEx

        .DESCRIPTION
        Extract a staff name from file with RegEx.
        This function is optimized to use for MyAnimeList username rules:
        Alphanumeric case-sensitive with dash and underscore up to 16 characters ("[\w\-_]{2,16}")

        .PARAMETER FileName
        Specifies the file name.

        .EXAMPLE
        PS> $FileName = Get-RandomCard

        PS> $FileName
        un1corn_tnc@cards1_v1.png

        PS> Get-WorkStaff -FileName $FileName
        un1corn_tnc

        .LINK
        Get-RandomBanner

        .LINK
        Get-RandomCard
    #>
}

Export-ModuleMember -Function Get-RandomBanner
Export-ModuleMember -Function Get-RandomCard
Export-ModuleMember -Function Get-WorkStaff
