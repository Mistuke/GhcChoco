$binRoot         = $(Split-Path -parent $MyInvocation.MyCommand.Definition)
$packageFullName = Join-Path $binRoot ($packageName + '-' + $version)
$binPackageDir   = Join-Path $packageFullName "bin"

$tmpPath = Join-Path $env:chocolateyPackageFolder tmp
$tarFile = $packageName + "Install"
$tarPath = Join-Path $tmpPath $tarFile
$tmpFile = Join-Path $binRoot ($tarFile + "~")

Get-ChocolateyWebFile -PackageName $packageName -FileFullPath $tarPath -Url $url -Url64bit $url64
Get-ChocolateyUnzip -fileFullPath $tarPath -destination $binRoot
Get-ChocolateyUnzip -fileFullPath $tmpFile -destination $binRoot
rm $tmpFile # Clean up temporary file

Write-Host "Adding `'$binPackageDir`' to the path and the current shell path"
Install-ChocolateyPath "$binPackageDir"

Write-Host "Hiding shims for `'$binRoot`'."
# Blocking shims
$files = get-childitem $binRoot -include *.exe -recurse

foreach ($file in $files) {
#generate an ignore file
New-Item "$file.ignore" -type file -force | Out-Null
}

# Reload the session to update path
Write-Host "$packageName $version has been installed. You may need to restart the console to use it."
