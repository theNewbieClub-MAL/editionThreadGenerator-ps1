Function Get-RandomBanner {    
    if (Test-Path ./Sources/Banners) {
        $randomBanner = (Get-ChildItem -Path ./Sources/Banners/ | Get-Random).Name
        Write-Verbose "$($randomBanner) has been set"
        $randomBanner
    } else {
        $WarningMessage = "./Sources/Banners can not be found on $(Get-Location)"
    	Write-Host $WarningMessage -ForegroundColor Red
    	Write-Verbose $WarningMessage
    }

    <#
        .SYNOPSIS
        Get Random Banner placeholder filename
        
        .DESCRIPTION
        Get Random Banner placeholder filename that is available on ./Sources/Banners

        .EXAMPLE
        PS> Get-RandomBanner
        un1corn_tnc@banner1_v1.png

        .NOTES
        Function will not work if ./Sources/Banners directory is not exist.

        .LINK
        Get-RandomCard

        .LINK
        Get-WorkStaff
    #>

}

Function Get-RandomCard {
    $randomCard = (Get-ChildItem -Path ./Sources/Cards/ | Get-Random).Name
    Write-Verbose "$($randomCard) has been set"
    $randomCard

    <#
        .SYNOPSIS
        Get Random Card placeholder filename
        
        .DESCRIPTION
        Get Random Card placeholder filename that is available on ./Sources/Cards

        .EXAMPLE
        PS> Get-RandomCard
        un1corn_tnc@cards1_v1.png

        .NOTES
        Function will not work if ./Sources/Cards directory is not exist.

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

    [regex]::Match($FileName, "^[\w\-_]{2,16}").Groups[0].Value
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
