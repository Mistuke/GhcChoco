$version     = '7.8.4'
$packageName = 'ghc'
$url         = 'https://downloads.haskell.org/~ghc/7.8.4/ghc-7.8.4-i386-unknown-mingw32-win10.tar.xz'
$url64       = 'https://downloads.haskell.org/~ghc/7.8.4/ghc-7.8.4-x86_64-unknown-mingw32.tar.xz'

$binRoot         = $(Split-Path -parent $MyInvocation.MyCommand.Definition)
$packageFullName = Join-Path $binRoot ($packageName + '-' + $version)
$binPackageDir   = Join-Path $packageFullName "bin"

$tmpPath = Join-Path $env:chocolateyPackageFolder tmp
$tarFile = $packageName + "Install"
$tarPath = Join-Path $tmpPath $tarFile
$tmpFile = Join-Path $binRoot ($tarFile + "~")

Get-ChocolateyWebFile -PackageName $packageName -FileFullPath $tarPath -Url $url -ChecksumType sha256 -Checksum 7ea940c3b6ab3b0097f43575b9e3b0e94d8a9c10a9109c33ee4ecd8dfbe9bbb3 -Url64bit $url64  -ChecksumType64 sha256 -Checksum64 46c87d70e24a541ac569f268b5367a932b5fd841a9dc5ad2bbcbc25e149693a4
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