$version     = '9.2.2'
$packageName = 'ghc'
$url         = 'https://downloads.haskell.org/~ghc/8.6.5/ghc-8.6.5-i386-unknown-mingw32.tar.xz'
$binSha256   = '02d0c0cceb9bc14ba42940c83797f819e1903db4a71b630e9bc6d14b6b80298b'
$variant     = ''
$pp          = Get-PackageParameters
if ($pp['integer-simple']) {
  $variant = '-integer-simple'
  $binSha256 = '146fd58c67d8fe01e478e950afad1d753de89cfbe2e6677a3129f090c213ff48'
}
$baseTarget  = 'ghc-' + $version + '-x86_64-unknown-mingw32'
$target      = $baseTarget + $variant
$url64       = 'https://downloads.haskell.org/~ghc/9.2.2/' + $target + '.tar.xz'
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
  $binRoot         = Get-ToolsLocation
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
    Write-Host "Renamed $longBinPackageDir to $packageFullName"
}

# FIxes issue #8
$installScope = 'User'
if ($pp['globalinstall'] -eq 'true') {
  $installScope = 'Machine'
  Write-Host "Install scope set to global."
}
Install-ChocolateyPath "$binPackageDir" -Machine "$installScope"

if (-Not $is32) {
# HACK: Work around that GHC 9.0 is missing some components
# See https://github.com/Mistuke/GhcChoco/issues/13
echo '#!/bin/sh
exec "$(dirname "$0")"/ghc --interactive "$@"
' | Out-File -FilePath "$binPackageDir\ghcii.sh" -Encoding ascii

  Copy-Item "$binPackageDir\ghcii.sh" "$binPackageDir\ghcii-$version.sh"

  Install-BinFile "ghc-$version" "$binPackageDir\ghc.exe"
  Install-BinFile "ghci-$version" "$binPackageDir\ghci.exe"
  Install-BinFile "haddock-$version" "$binPackageDir\haddock.exe"
}

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
