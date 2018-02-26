$version     = '8.4.0.20180224'
$packageName = 'ghc'
$url         = 'https://downloads.haskell.org/~ghc/8.4.1-rc1/ghc-8.4.0.20180224-i386-unknown-mingw32.tar.xz'
$url64       = 'https://downloads.haskell.org/~ghc/8.4.1-rc1/ghc-8.4.0.20180224-x86_64-unknown-mingw32.tar.xz'

$binRoot         = $(Split-Path -parent $MyInvocation.MyCommand.Definition)
$packageFullName = Join-Path $binRoot ($packageName + '-' + $version)
$binPackageDir   = Join-Path $packageFullName "bin"

$tmpPath = Join-Path $env:chocolateyPackageFolder tmp
$tarFile = $packageName + "Install"
$tarPath = Join-Path $tmpPath $tarFile
$tmpFile = Join-Path $binRoot ($tarFile + "~")

Get-ChocolateyWebFile -PackageName $packageName -FileFullPath $tarPath -Url $url -ChecksumType sha256 -Checksum 28799a8ceee197a050fa1ef0740a78b01bf93b13f5a7b8e7ef5061b231c270dc -Url64bit $url64 -ChecksumType64 sha256 -Checksum64 7d125b3bbaa2ec4022215787a259a41bf944ec02736c9555f2a19432eef21cad
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