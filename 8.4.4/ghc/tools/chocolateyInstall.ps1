$version     = '8.4.4'
$packageName = 'ghc'
$url         = 'https://downloads.haskell.org/~ghc/8.4.4/ghc-8.4.4-i386-unknown-mingw32.tar.xz'
$url64       = 'https://downloads.haskell.org/~ghc/8.4.4/ghc-8.4.4-x86_64-unknown-mingw32.tar.xz'

$binRoot         = $(Split-Path -parent $MyInvocation.MyCommand.Definition)
$packageFullName = Join-Path $binRoot ($packageName + '-' + $version)
$binPackageDir   = Join-Path $packageFullName "bin"

$tmpPath = Join-Path $env:chocolateyPackageFolder tmp
$tarFile = $packageName + "Install"
$tarPath = Join-Path $tmpPath $tarFile
$tmpFile = Join-Path $binRoot ($tarFile + "~")

Get-ChocolateyWebFile -PackageName $packageName -FileFullPath $tarPath `
                      -Url $url -ChecksumType sha256 -Checksum 4e6a3ce4df602cdbf0f6780e16b2d727dae9e3517a972bc81ea0f657f1e6dccf `
                      -Url64bit $url64 -ChecksumType64 sha256 -Checksum64 da29dbb0f1199611c7d5bb7b0dd6a7426ca98f67dfd6da1526b033cd3830dc05
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