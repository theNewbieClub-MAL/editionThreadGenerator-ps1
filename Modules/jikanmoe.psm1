

function Find-MAL {
    param (
        [Parameter(Mandatory=$true)]
        [String]$SearchQuery
    )

    $Encoded = [uri]::EscapeDataString($SearchQuery)
    $iwr = Invoke-WebRequest -Uri "https://api.jikan.moe/v4/anime?q=$($Encoded)&limit=20&sfw=false" -Method Get
    (ConvertFrom-Json ($iwr).content | Select-Object -Expand "data") | Select-Object mal_id,title,title_english | Format-Table
}

function Get-MALTitle {
    param (
        [Parameter(Mandatory=$true)]
        [String]$MALId,
        [bool]$English = $false
    )

    $iwr = Invoke-WebRequest -Uri "https://api.jikan.moe/v4/anime/$($MALId)" -Method Get
    if($false -eq $English){
        (ConvertFrom-Json ($iwr).content | Select-Object -Expand "data").title
    } else {
        (ConvertFrom-Json ($iwr).content | Select-Object -Expand "data").title_english
    }
}

Export-ModuleMember -Function Find-MAL
Export-ModuleMember -Function Get-MALTitle
