$version     = '7.10.2'
$packageName = 'ghc'
$url         = 'https://downloads.haskell.org/~ghc/7.10.2/ghc-7.10.2-i386-unknown-mingw32-win10.tar.xz'
$url64       = 'https://downloads.haskell.org/~ghc/7.10.2/ghc-7.10.2-x86_64-unknown-mingw32-win10.tar.xz'

$binRoot         = $(Split-Path -parent $MyInvocation.MyCommand.Definition)
$packageFullName = Join-Path $binRoot ($packageName + '-' + $version)
$binPackageDir   = Join-Path $packageFullName "bin"

$tmpPath = Join-Path $env:chocolateyPackageFolder tmp
$tarFile = $packageName + "Install"
$tarPath = Join-Path $tmpPath $tarFile
$tmpFile = Join-Path $binRoot ($tarFile + "~")

Get-ChocolateyWebFile -PackageName $packageName -FileFullPath $tarPath -Url $url -ChecksumType sha256 -Checksum 1ae9fa54ab8c4985f16b93c2f6ef758faad9b0a1299ec280410d927b27c0487b -Url64bit $url64  -ChecksumType64 sha256 -Checksum64 9b7422a664d0580b38fc8e4d8d477ef2adbe8fa85d756796dd04e04c63bc163f
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