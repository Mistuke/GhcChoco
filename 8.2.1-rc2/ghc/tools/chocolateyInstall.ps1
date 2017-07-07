$version     = '8.2.0.20170404'
$packageName = 'ghc'
$url         = 'https://downloads.haskell.org/~ghc/8.2.1-rc2/ghc-8.2.0.20170507-i386-unknown-mingw32.tar.xz'
$url64       = 'https://downloads.haskell.org/~ghc/8.2.1-rc2/ghc-8.2.0.20170507-x86_64-unknown-mingw32.tar.xz'

$binRoot         = $(Split-Path -parent $MyInvocation.MyCommand.Definition)
$packageFullName = Join-Path $binRoot ($packageName + '-' + $version)
$binPackageDir   = Join-Path $packageFullName "bin"

$tmpPath = Join-Path $env:chocolateyPackageFolder tmp
$tarFile = $packageName + "Install"
$tarPath = Join-Path $tmpPath $tarFile
$tmpFile = Join-Path $binRoot ($tarFile + "~")

Get-ChocolateyWebFile -PackageName $packageName -FileFullPath $tarPath -Url $url -ChecksumType 0dabeb169c22765ded1cf5f0c25348a4c948c7a48386e759d63a415f0d4fdca3 sha256 -Checksum -Url64bit $url64 -ChecksumType64 sha256 -Checksum64 617818b30ac9714d00b05980db33b06c33068a81fcdc12d4d92f3341bc470f2e
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