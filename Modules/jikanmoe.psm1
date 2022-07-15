[Net.ServicePointManager]::SecurityProtocol = "tls12, tls11, tls"

function Find-MAL {
    param (
        [Parameter(Mandatory=$true)]
        [String]$SearchQuery
    )

    $Encoded = [uri]::EscapeDataString($SearchQuery)
    $iwr = Invoke-WebRequest -Uri "https://api.jikan.moe/v4/anime?q=$($Encoded)&limit=20&sfw=false" -Method Get
    (ConvertFrom-Json ($iwr).content | Select-Object -Expand "data") | Select-Object mal_id,title,title_english | Format-Table

    <#
        .SYNOPSIS
        Search for an anime on MyAnimeList.net

        .DESCRIPTION
        Search for an anime on MyAnimeList.net by utilizing 3rd Party MAL API by Jikan.moe.
        The search query is case-insensitive and can be a full title or a partial title.
        Title can be in English or Japanese.

        .EXAMPLE
        PS> Find-MAL "Naruto"

        mal_id title                                                                     title_english
        ------ -----                                                                     -------------
            20 Naruto                                                                    Naruto
         32365 Boruto: Naruto the Movie - Naruto ga Hokage ni Natta Hi                   Boruto: Naruto the Movie - The Day Naruto Became Hokage
         10686 Naruto: Honoo no Chuunin Shiken! Naruto vs. Konohamaru!!                  Naruto Shippuden: Chunin Exam on Fire! and Naruto vs. Konohamaru!
         10659 Naruto Soyokazeden Movie: Naruto to Mashin to Mitsu no Onegai Dattebayo!! Naruto: The Magic Genie and the Three Wishes
          1735 Naruto: Shippuuden                                                        Naruto Shippuden
         10075 Naruto x UT
         28755 Boruto: Naruto the Movie                                                  Boruto: Naruto the Movie
         16870 The Last: Naruto the Movie                                                The Last: Naruto the Movie
         34566 Boruto: Naruto Next Generations                                           Boruto: Naruto Next Generations
          7367 Naruto: The Cross Roads
         19511 Naruto: Shippuuden - Sunny Side Battle
         13667 Naruto: Shippuuden Movie 6 - Road to Ninja                                Road to Ninja: Naruto the Movie
          4134 Naruto: Shippuuden - Shippuu! "Konoha Gakuen" Den                         Naruto Shippuden: Konoha Gakuen - Special
          8246 Naruto: Shippuuden Movie 4 - The Lost Tower                               Naruto Shippuden the Movie: The Lost Tower
         36564 Kamiusagi Rope x Boruto: Naruto Next Generations
          2472 Naruto: Shippuuden Movie 1                                                Naruto: Shippuden the Movie
           936 Naruto Movie 2: Dai Gekitotsu! Maboroshi no Chiteiiseki Dattebayo!        Naruto the Movie 2: Legend of the Stone of Gelel
           442 Naruto Movie 1: Dai Katsugeki!! Yuki Hime Shinobu Houjou Dattebayo!       Naruto the Movie: Ninja Clash in the Land of Snow
          2144 Naruto Movie 3: Dai Koufun! Mikazuki Jima no Animaru Panikku Dattebayo!   Naruto the Movie 3: Guardians of the Crescent Moon Kingdom
          4437 Naruto: Shippuuden Movie 2 - Kizuna                                       Naruto: Shippuden the Movie 2 -Bonds-

        .LINK
        Get-MALTitle
    #>
}

function Get-MALTitle {
    param (
        [Parameter(Mandatory=$true)]
        [String]$MALId,
        [switch]$English
    )

    $iwr = Invoke-WebRequest -Uri "https://api.jikan.moe/v4/anime/$($MALId)" -Method Get
    if($false -eq $English){
        $title = (ConvertFrom-Json ($iwr).content | Select-Object -Expand "data").title
        Write-Output $title
    } else {
        $fallback = (ConvertFrom-Json ($iwr).content | Select-Object -Expand "data").title_english
        if ($null -eq $fallback) {
            $title = (ConvertFrom-Json ($iwr).content | Select-Object -Expand "data").title
            Write-Output $title
        }
    }

    <#
        .SYNOPSIS
        Get the title of an anime on MyAnimeList.net by ID.

        .DESCRIPTION
        Get the title of an anime on MyAnimeList.net by utilizing 3rd Party MAL API by Jikan.moe using ID.

        .PARAMETER English
        This parameter is optional. If set to true, the function will return the English title if it exists.

        .EXAMPLE
        PS> Get-MALTitle 235
        Detective Conan

        .EXAMPLE
        PS> Get-MALTitle 235 -English
        Case Closed

        .LINK
        Find-MAL
    #>
}

Export-ModuleMember -Function Find-MAL
Export-ModuleMember -Function Get-MALTitle
