$version     = 'ghc-8.4.0.20171214'
$packageName = 'ghc'
$url         = 'https://downloads.haskell.org/~ghc/8.4.1-alpha1/ghc-8.4.0.20171214-i386-unknown-mingw32.tar.xz'
$url64       = 'https://downloads.haskell.org/~ghc/8.4.1-alpha1/ghc-8.4.0.20171214-x86_64-unknown-mingw32.tar.xz'

$binRoot         = $(Split-Path -parent $MyInvocation.MyCommand.Definition)
$packageFullName = Join-Path $binRoot ($packageName + '-' + $version)
$binPackageDir   = Join-Path $packageFullName "bin"

$tmpPath = Join-Path $env:chocolateyPackageFolder tmp
$tarFile = $packageName + "Install"
$tarPath = Join-Path $tmpPath $tarFile
$tmpFile = Join-Path $binRoot ($tarFile + "~")

Get-ChocolateyWebFile -PackageName $packageName -FileFullPath $tarPath -Url $url -ChecksumType sha256 -Checksum e12568bfdb47a347c5282a2719d91602a4b44d63bec102205cba1841d4c1c000 -Url64bit $url64 -ChecksumType64 sha256 -Checksum64 687fcf5d9a0bccabb94f7856cc5702bfff591565d4195c675a4335f9c3ef9127
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