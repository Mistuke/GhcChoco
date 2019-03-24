$version     = '8.6.4'
$packageName = 'ghc'
$url         = 'https://mistuke.blob.core.windows.net/binaries/unofficial/~ghc/8.6.4/ghc-8.6.4-i386-unknown-mingw32.tar.xz'
$url64       = 'https://downloads.haskell.org/~ghc/8.6.4/ghc-8.6.4-x86_64-unknown-mingw32.tar.xz'

$binRoot         = $(Split-Path -parent $MyInvocation.MyCommand.Definition)
$packageFullName = Join-Path $binRoot ($packageName + '-' + $version)
$binPackageDir   = Join-Path $packageFullName "bin"

$tmpPath = Join-Path $env:chocolateyPackageFolder tmp
$tarFile = $packageName + "Install"
$tarPath = Join-Path $tmpPath $tarFile
$tmpFile = Join-Path $binRoot ($tarFile + "~")

Get-ChocolateyWebFile -PackageName $packageName -FileFullPath $tarPath `
    -Url $url -ChecksumType sha256 -Checksum 384ff629576627d3c24a73c52e404f8ab72c65ccf3e22f74268a5eae7aa5ed61 `
    -Url64bit $url64 -ChecksumType64 sha256 -Checksum64 e8d021b7a90772fc559862079da20538498d991956d7557b468ca19ddda22a08
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