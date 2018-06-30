$version     = 'ghc-8.6.0.20180627'
$packageName = 'ghc'
$url         = 'https://downloads.haskell.org/~ghc/8.6.1-alpha1/ghc-8.6.0.20180627-i386-unknown-mingw32.tar.xz'
$url64       = 'https://downloads.haskell.org/~ghc/8.6.1-alpha1/ghc-8.6.0.20180627-x86_64-unknown-mingw32.tar.xz'

$binRoot         = $(Split-Path -parent $MyInvocation.MyCommand.Definition)
$packageFullName = Join-Path $binRoot ($packageName + '-' + $version)
$binPackageDir   = Join-Path $packageFullName "bin"

$tmpPath = Join-Path $env:chocolateyPackageFolder tmp
$tarFile = $packageName + "Install"
$tarPath = Join-Path $tmpPath $tarFile
$tmpFile = Join-Path $binRoot ($tarFile + "~")

Get-ChocolateyWebFile -PackageName $packageName -FileFullPath $tarPath -Url $url -ChecksumType sha256 -Checksum 6cc739c10335c757e11a4fbdea8667c3ab6d8cce52e6d4b38cc21f3c45b55d9e -Url64bit $url64 -ChecksumType64 sha256 -Checksum64 ccff1f896425f932581c804e1fd6dd14dea7b7423f7f4970ff1d99ab03c97504
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