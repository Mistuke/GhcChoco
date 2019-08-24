$version     = 'ghc-%build.version%.%build.date%'
$packageName = 'ghc-head'
$url         = '%deploy.url.32bit%'
$url64       = '%deploy.url.64bit%'

$binRoot         = $(Split-Path -parent $MyInvocation.MyCommand.Definition)
$packageFullName = Join-Path $binRoot $version
$binPackageDir   = Join-Path $packageFullName "bin"

$tmpPath = Join-Path $env:chocolateyPackageFolder tmp
$tarFile = $packageName + "Install"
$tarPath = Join-Path $tmpPath $tarFile
$tmpFile = Join-Path $binRoot ($tarFile + "~")

Get-ChocolateyWebFile `
  -PackageName $packageName `
  -FileFullPath $tarPath `
  -Url $url -ChecksumType sha256 -Checksum '%deploy.sha256.32bit%' `
  -Url64bit $url64 -ChecksumType64 sha256 -Checksum64 '%deploy.sha256.64bit%'
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

if (($null -ne $Env:TRAVIS) -and ("" -ne $Env:TRAVIS)) {
  Write-Host "Configuring TRAVIS aliases."
  # We need to fix up refreshenv for Travis
  $rc = $Env:HOME + "/.bashrc"

  Add-Content $rc "function refreshenv`n
  {`n
    powershell -NonInteractive - <<\EOF`n
  Import-Module `"$env:ChocolateyInstall\helpers\chocolateyProfile.psm1`"`n
  Update-SessionEnvironment`n
  # Round brackets in variable names cause problems with bash`n
  Get-ChildItem env:* | %{`n
    if (!($_.Name.Contains('('))) {`n
      $value = $_.Value`n
      if ($_.Name -eq 'PATH') {`n
        $value = $value -replace ';',':'`n
      }`n
      Write-Output (`"export `" + $_.Name + `"='`" + $value + `"'`")`n
    }`n
  } | Out-File -Encoding ascii $env:TEMP\refreshenv.sh`n
  EOF`n
  `n
    source `"$TEMP/refreshenv.sh`"`n
  }`n
  `n
  alias RefreshEnv=refreshenv`n"

  Write-Host "Ok, updated ~/.bashrc, source to use refreshenv."
}