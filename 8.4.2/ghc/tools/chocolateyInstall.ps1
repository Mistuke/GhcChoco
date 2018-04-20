$version     = '8.4.2'
$packageName = 'ghc'
$url         = 'https://downloads.haskell.org/~ghc/8.4.2/ghc-8.4.2-i386-unknown-mingw32.tar.xz'
$url64       = 'https://downloads.haskell.org/~ghc/8.4.2/ghc-8.4.2-x86_64-unknown-mingw32.tar.xz'

$binRoot         = $(Split-Path -parent $MyInvocation.MyCommand.Definition)
$packageFullName = Join-Path $binRoot ($packageName + '-' + $version)
$binPackageDir   = Join-Path $packageFullName "bin"

$tmpPath = Join-Path $env:chocolateyPackageFolder tmp
$tarFile = $packageName + "Install"
$tarPath = Join-Path $tmpPath $tarFile
$tmpFile = Join-Path $binRoot ($tarFile + "~")

Get-ChocolateyWebFile -PackageName $packageName -FileFullPath $tarPath `
                      -Url $url -ChecksumType sha256 -Checksum 5c3bab299dfa6593d851c84c0a56ccbce668a01dc8993c0fcb8055fffb534bde `
                      -Url64bit $url64 -ChecksumType64 sha256 -Checksum64 797634aa9812fc6b2084a24ddb4fde44fa83a2f59daea82e0af81ca3dd323fde
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