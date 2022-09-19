Function Write-Header {
  Param(
    [Parameter(Mandatory = $True)]
    [String]$Message,
    [ValidateSet(
      'Black', 'Blue', 'Cyan',
      'DarkBlue', 'DarkCyan', 'DarkGray',
      'DarkGreen', 'DarkMagenta', 'DarkRed',
      'DarkYellow', 'Gray', 'Green',
      'Magenta', 'Red', 'White',
      'Yellow'
      )
    ]
    [String]$ForegroundColor = "Blue",
    [ValidateSet(
      'Black', 'Blue', 'Cyan',
      'DarkBlue', 'DarkCyan', 'DarkGray',
      'DarkGreen', 'DarkMagenta', 'DarkRed',
      'DarkYellow', 'Gray', 'Green',
      'Magenta', 'Red', 'White',
      'Yellow'
      )
    ]
    [String]$BackgroundColor,
    [String]$Separator = '='
  )

  $total = $Message.Length
  $total = [Int]$total
  $bar = "$($separator)" * $total
  Write-Host $Message -ForegroundColor $ForegroundColor
  Write-Host $bar -ForegroundColor $ForegroundColor
}

Export-ModuleMember -Function Write-Header
