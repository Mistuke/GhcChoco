$version     = '8.4.3'
$packageName = 'ghc'
$url         = 'https://downloads.haskell.org/~ghc/8.4.3/ghc-8.4.3-i386-unknown-mingw32.tar.xz'
$url64       = 'https://downloads.haskell.org/~ghc/8.4.3/ghc-8.4.3-x86_64-unknown-mingw32.tar.xz'

$binRoot         = $(Split-Path -parent $MyInvocation.MyCommand.Definition)
$packageFullName = Join-Path $binRoot ($packageName + '-' + $version)
$binPackageDir   = Join-Path $packageFullName "bin"

$tmpPath = Join-Path $env:chocolateyPackageFolder tmp
$tarFile = $packageName + "Install"
$tarPath = Join-Path $tmpPath $tarFile
$tmpFile = Join-Path $binRoot ($tarFile + "~")

Get-ChocolateyWebFile -PackageName $packageName -FileFullPath $tarPath `
                      -Url $url -ChecksumType sha256 -Checksum 4c702f123185a52f5cfb86c6d7a189f2223a5fb15775101ff3c5b50acaf166d2 `
                      -Url64bit $url64 -ChecksumType64 sha256 -Checksum64 8a83cfbf9ae84de0443c39c93b931693bdf2a6d4bf163ffb41855f80f4bf883e
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