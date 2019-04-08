$version     = '8.6.4.20190406'
$packageName = 'ghc'
$url         = 'https://downloads.haskell.org/ghc/8.6.5-rc1/ghc-8.6.4.20190406-i386-unknown-mingw32.tar.xz'
$url64       = 'https://downloads.haskell.org/ghc/8.6.5-rc1/ghc-8.6.4.20190406-x86_64-unknown-mingw32.tar.xz'

$binRoot         = $(Split-Path -parent $MyInvocation.MyCommand.Definition)
$packageFullName = Join-Path $binRoot ($packageName + '-' + $version)
$binPackageDir   = Join-Path $packageFullName "bin"

$tmpPath = Join-Path $env:chocolateyPackageFolder tmp
$tarFile = $packageName + "Install"
$tarPath = Join-Path $tmpPath $tarFile
$tmpFile = Join-Path $binRoot ($tarFile + "~")

Get-ChocolateyWebFile -PackageName $packageName -FileFullPath $tarPath `
    -Url $url -ChecksumType sha256 -Checksum ff717d02f20fc4b50f6801282371c65ca3887aaca9f566711e1c14022d820f62 `
    -Url64bit $url64 -ChecksumType64 sha256 -Checksum64 1a9668eed6b27c4b7a2fcce2b7e400211c2042e9622b13cf2aa69c6c1553e42c
Get-ChocolateyUnzip -fileFullPath $tarPath -destination $binRoot
Get-ChocolateyUnzip -fileFullPath $tmpFile -destination $binRoot
rm $tmpFile # Clean up temporary file

Install-ChocolateyPath "$binPackageDir"

Write-Host "Hiding shims for `'$binRoot`'."
$files = get-childitem $binRoot -include *.exe -recurse

foreach ($file in $files) {
    #generate an ignore file
    New-Item "$file.ignore" -type file -force | Out-Null
}