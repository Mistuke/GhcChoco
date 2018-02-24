$version     = '7.10.1'
$packageName = 'ghc'
$url         = 'https://downloads.haskell.org/~ghc/7.10.1/ghc-7.10.1-i386-unknown-mingw32-win10.tar.xz'
$url64       = 'https://downloads.haskell.org/~ghc/7.10.1/ghc-7.10.1-x86_64-unknown-mingw32-win10.tar.xz'

$binRoot         = $(Split-Path -parent $MyInvocation.MyCommand.Definition)
$packageFullName = Join-Path $binRoot ($packageName + '-' + $version)
$binPackageDir   = Join-Path $packageFullName "bin"

$tmpPath = Join-Path $env:chocolateyPackageFolder tmp
$tarFile = $packageName + "Install"
$tarPath = Join-Path $tmpPath $tarFile
$tmpFile = Join-Path $binRoot ($tarFile + "~")

Get-ChocolateyWebFile -PackageName $packageName -FileFullPath $tarPath -Url $url -ChecksumType sha256 -Checksum 1fe65b902c6e4fa0c5a8b11b7cc99ffca7a2f3b031e055dd6363df90278dce44 -Url64bit $url64  -ChecksumType64 sha256 -Checksum64 8b82d3e90030f26c21d5783c5f817b4e3a568c78a97aaf1e4601b23cb654e64c
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