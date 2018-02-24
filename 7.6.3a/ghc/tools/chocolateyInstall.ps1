$version     = '7.6.3'
$packageName = 'ghc'
$url         = 'https://downloads.haskell.org/~ghc/7.6.3/ghc-7.6.3-i386-unknown-mingw32-win10.tar.xz'
$url64       = 'https://downloads.haskell.org/~ghc/7.6.3/ghc-7.6.3-x86_64-unknown-mingw32.tar.bz2'

$binRoot         = $(Split-Path -parent $MyInvocation.MyCommand.Definition)
$packageFullName = Join-Path $binRoot ($packageName + '-' + $version)
$binPackageDir   = Join-Path $packageFullName "bin"

$tmpPath = Join-Path $env:chocolateyPackageFolder tmp
$tarFile = $packageName + "Install"
$tarPath = Join-Path $tmpPath $tarFile
$tmpFile = Join-Path $binRoot ($tarFile + "~")

Get-ChocolateyWebFile -PackageName $packageName -FileFullPath $tarPath -Url $url -ChecksumType sha256 -Checksum 98d88a9a281f0bba282624424ca01c493dbffd38bfa8af637dc701904fd3821d -Url64bit $url64  -ChecksumType64 sha256 -Checksum64 10377a4b78cd9917f2a8d5bfabe4e2824e5e331395e0a768896bcb4f042f8695
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