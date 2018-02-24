$version     = '7.8.1'
$packageName = 'ghc'
$url         = 'https://downloads.haskell.org/~ghc/7.8.1/ghc-7.8.1-i386-unknown-mingw32-win10.tar.xz'
$url64       = 'https://downloads.haskell.org/~ghc/7.8.1/ghc-7.8.1-x86_64-unknown-mingw32.tar.xz'

$binRoot         = $(Split-Path -parent $MyInvocation.MyCommand.Definition)
$packageFullName = Join-Path $binRoot ($packageName + '-' + $version)
$binPackageDir   = Join-Path $packageFullName "bin"

$tmpPath = Join-Path $env:chocolateyPackageFolder tmp
$tarFile = $packageName + "Install"
$tarPath = Join-Path $tmpPath $tarFile
$tmpFile = Join-Path $binRoot ($tarFile + "~")

Get-ChocolateyWebFile -PackageName $packageName -FileFullPath $tarPath -Url $url -ChecksumType sha256 -Checksum 6bc62bfcf207bf06ae8e423d9a1736ebd9b576a4f13758c2562abac855a76c2c -Url64bit $url64  -ChecksumType64 sha256 -Checksum64 35ce723fd9a20331a74492597233d1c5652cbb63f93829707d82c751254146fc
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