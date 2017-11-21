$version     = '8.2.2'
$packageName = 'ghc'
$url         = 'https://downloads.haskell.org/~ghc/8.2.2/ghc-8.2.2-i386-unknown-mingw32.tar.xz'
$url64       = 'https://downloads.haskell.org/~ghc/8.2.2/ghc-8.2.2-x86_64-unknown-mingw32.tar.xz'

$binRoot         = $(Split-Path -parent $MyInvocation.MyCommand.Definition)
$packageFullName = Join-Path $binRoot ($packageName + '-' + $version)
$binPackageDir   = Join-Path $packageFullName "bin"

$tmpPath = Join-Path $env:chocolateyPackageFolder tmp
$tarFile = $packageName + "Install"
$tarPath = Join-Path $tmpPath $tarFile
$tmpFile = Join-Path $binRoot ($tarFile + "~")

Get-ChocolateyWebFile -PackageName $packageName -FileFullPath $tarPath -Url $url -ChecksumType sha256 -Checksum 6b79c96825ccf99878342b228e132b62e46e8303c4ef76e46450de42e5825bea -Url64bit $url64 -ChecksumType64 sha256 -Checksum64 1e033df2092aa546e763e7be63167720b32df64f76673ea1ce7ae7c9f564b223
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