$version     = '7.6.1'
$packageName = 'ghc'
$url         = 'https://downloads.haskell.org/~ghc/7.6.1/ghc-7.6.1-i386-unknown-mingw32-win10.tar.xz'
$url64       = 'https://downloads.haskell.org/~ghc/7.6.1/ghc-7.6.1-x86_64-unknown-mingw32.tar.bz2'

$binRoot         = $(Split-Path -parent $MyInvocation.MyCommand.Definition)
$packageFullName = Join-Path $binRoot ($packageName + '-' + $version)
$binPackageDir   = Join-Path $packageFullName "bin"

$tmpPath = Join-Path $env:chocolateyPackageFolder tmp
$tarFile = $packageName + "Install"
$tarPath = Join-Path $tmpPath $tarFile
$tmpFile = Join-Path $binRoot ($tarFile + "~")

Get-ChocolateyWebFile -PackageName $packageName -FileFullPath $tarPath -Url $url -ChecksumType sha256 -Checksum ca6ee457ba9c502a1157bbc80989f0e5d463a0aba4ffcd6bae0b4e1c5b499c6d -Url64bit $url64  -ChecksumType64 sha256 -Checksum64 01736af0bbc828e4a1e129bab21e7c24eb0780492a90e36ac390d24d9b2475ea
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