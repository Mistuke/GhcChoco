$version     = '8.2.0.20170404'
$packageName = 'ghc'
$url         = ''
$url64       = 'https://downloads.haskell.org/ghc/8.2.1-rc1/ghc-8.2.0.20170404-x86_64-unknown-mingw32.tar.xz'

$binRoot         = $(Split-Path -parent $MyInvocation.MyCommand.Definition)
$packageFullName = Join-Path $binRoot ($packageName + '-' + $version)
$binPackageDir   = Join-Path $packageFullName "bin"

$tmpPath = Join-Path $env:chocolateyPackageFolder tmp
$tarFile = $packageName + "Install"
$tarPath = Join-Path $tmpPath $tarFile
$tmpFile = Join-Path $binRoot ($tarFile + "~")

Get-ChocolateyWebFile -PackageName $packageName -FileFullPath $tarPath -Url $url -ChecksumType 1f6b75a090f5a63aedf91ed8a69884a1d98cbab807d93d49fe7448496c01dcc7 sha256 -Checksum -Url64bit $url64 -ChecksumType64 sha256 -Checksum64 26338f19c1bc1344a95fe4694d09cf80f633b9dea91bd6934b2c3e73600b49aa
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