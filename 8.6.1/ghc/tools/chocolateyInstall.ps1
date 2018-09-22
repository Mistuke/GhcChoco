$version     = 'ghc-8.6.1'
$packageName = 'ghc'
$url         = 'https://downloads.haskell.org/~ghc/8.6.1/ghc-8.6.1-i386-unknown-mingw32.tar.xz'
$url64       = 'https://downloads.haskell.org/~ghc/8.6.1/ghc-8.6.1-x86_64-unknown-mingw32.tar.xz'

$binRoot         = $(Split-Path -parent $MyInvocation.MyCommand.Definition)
$packageFullName = Join-Path $binRoot ($packageName + '-' + $version)
$binPackageDir   = Join-Path $packageFullName "bin"

$tmpPath = Join-Path $env:chocolateyPackageFolder tmp
$tarFile = $packageName + "Install"
$tarPath = Join-Path $tmpPath $tarFile
$tmpFile = Join-Path $binRoot ($tarFile + "~")

Get-ChocolateyWebFile -PackageName $packageName -FileFullPath $tarPath `
    -Url $url -ChecksumType sha256 -Checksum 64e4ded48bd03ddd93401c3ff8a2016bc32c584ce27461d4028d6fddd56eea06 `
    -Url64bit $url64 -ChecksumType64 sha256 -Checksum64 7316d9cb5e486460476754f872c7bac30ee2082e42f46da4342f872d10b88099
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