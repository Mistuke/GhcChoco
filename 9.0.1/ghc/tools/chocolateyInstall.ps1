﻿$version     = '9.0.1'
$packageName = 'ghc'
$url         = 'https://downloads.haskell.org/~ghc/8.6.5/ghc-8.6.5-i386-unknown-mingw32.tar.xz'
$binSha256   = '4f4ab118df01cbc7e7c510096deca0cb25025339a97730de0466416296202493'
$variant     = ''
$pp          = Get-PackageParameters
if ($pp['integer-simple']) {
  $variant = '-integer-simple'
  $binSha256 = '7edc8d07b07e095cd21c18ddd9d7f7a3ba30d02c7c82381edd392807589a2678'
}
$baseTarget  = 'ghc-' + $version + '-x86_64-unknown-mingw32'
$target      = $baseTarget + $variant
$url64       = 'https://downloads.haskell.org/~ghc/9.0.1/' + $target + '.tar.xz'
$is32 = (Get-OSArchitectureWidth 32)  -or $env:chocolateyForceX86 -eq 'true'

if($is32)
  {
      Write-Host "#     # ####### ####### ###  #####  #######"
      Write-Host "##    # #     #    #     #  #     # #      "
      Write-Host "# #   # #     #    #     #  #       #      "
      Write-Host "#  #  # #     #    #     #  #       #####  "
      Write-Host "#   # # #     #    #     #  #       #      "
      Write-Host "#    ## #     #    #     #  #     # #      "
      Write-Host "#     # #######    #    ###  #####  #######"
      Write-Host ""
      Write-Host " 32 bit binary for Windows is no longer supported."
      Write-Host "GHC 8.6.5 will be installed instead."
      Write-Host ""
      # rewrite the version to 8.6.5 so installer works
      $version = '8.6.5'
  }

# Fixes issue #4
if ($pp['installdir']) {
  $binRoot         = $pp['installdir']
} else {
  $binRoot         = $(Split-Path -parent $MyInvocation.MyCommand.Definition)
}
$packageFullName = Join-Path $binRoot ($packageName + '-' + $version)
$binPackageDir   = Join-Path $packageFullName "bin"

$tmpPath = Join-Path $env:chocolateyPackageFolder tmp
$tarFile = $packageName + "Install"
$tarPath = Join-Path $tmpPath $tarFile
$tmpFile = Join-Path $binRoot ($tarFile + "~")

Get-ChocolateyWebFile -PackageName $packageName -FileFullPath $tarPath `
    -Url $url -ChecksumType sha256 -Checksum 2a8fb73080ed4335f7a172fe6cf9da1a2faa51fdb72817c50088292f497fc57a `
    -Url64bit $url64 -ChecksumType64 sha256 -Checksum64 $binSha256
Get-ChocolateyUnzip -fileFullPath $tarPath -destination $binRoot
Get-ChocolateyUnzip -fileFullPath $tmpFile -destination $binRoot
rm $tmpFile # Clean up temporary file

# new folders are stupidly long and verbose and break convention.
# let's normalize them
$longBinPackageDir = Join-Path $binRoot $baseTarget
if (Test-Path $longBinPackageDir) {
    Rename-Item -fo $longBinPackageDir $packageFullName
}

# FIxes issue #8
$installScope = 'User'
if ($pp['globalinstall'] -eq 'true') {
  $installScope = 'Machine'
  Write-Host "Install scope set to global."
}
Install-ChocolateyPath "$binPackageDir" -Machine "$installScope"

# HACK: Work around that GHC 9.0 is missing ghcii.sh
echo '#!/bin/sh
exec "$(dirname "$0")"/ghc --interactive "$@"
' | Out-File -FilePath "$binPackageDir\ghcii.sh" -Encoding ascii

Write-Host "Hiding shims for `'$binRoot`'."
$files = get-childitem $binRoot -include *.exe -recurse

foreach ($file in $files) {
    #generate an ignore file
    New-Item "$file.ignore" -type file -force | Out-Null
}

# Detect Github Actions
if (($null -ne $Env:GITHUB_ACTIONS) -and ("" -ne $Env:GITHUB_ACTIONS)) {
  echo "$binPackageDir" | Out-File -FilePath $env:GITHUB_PATH -Encoding utf8 -Append
}

# Detect Azure Pipelines (Fixes issue #9)
if (($null -ne $Env:TF_BUILD) -and ("" -ne $Env:TF_BUILD)) {
  Write-Host "##vso[task.prependpath]$binPackageDir"
}

if (($null -ne $Env:TRAVIS) -and ("" -ne $Env:TRAVIS)) {
  Write-Host "Configuring Travis aliases."
  # We need to fix up refreshenv for Travis
  $rc = $Env:HOME + "/.bashrc"

  Add-Content $rc "function refreshenv
{
  powershell -NonInteractive - <<\EOF
Import-Module -Force `"`$env:ChocolateyInstall\helpers\chocolateyProfile.psm1`"
`$pref = `$ErrorActionPreference
`$ErrorActionPreference = 'SilentlyContinue'
Update-SessionEnvironment
`$ErrorActionPreference = `$pref
# Round brackets in variable names cause problems with bash
Get-ChildItem env:* | %{
  if (!(`$_.Name.Contains('('))) {
    `$value = `$_.Value
    if (`$_.Name -eq 'PATH') {
      `$value = `$value -replace ';',':'
    }
    Write-Output (`"export `" + `$_.Name + `"='`" + `$value + `"'`")
  }
} | Out-File -Encoding ascii $env:TEMP\refreshenv.sh
EOF

  source `"$env:TEMP/refreshenv.sh`"
}

alias RefreshEnv=refreshenv"

  Write-Host "Ok, updated ~/.bashrc, source to use refreshenv."
}
