$version     = '9.2.8'
$packageName = 'ghc'
$url         = 'https://downloads.haskell.org/~ghc/8.6.5/ghc-8.6.5-i386-unknown-mingw32.tar.xz'
$binSha256   = 'f11c7270839c50fda44f98b54254ae50340bb58b04f8d81ebcbe67a2827bd511'
$variant     = ''
$pp          = Get-PackageParameters
if ($pp['integer-simple']) {
  $variant = '-integer-simple'
  $binSha256 = 'e90edd23398951b1f2af87518b09a702caa877ec80b612959d1ae2a3c346c892'
}
$baseTarget  = 'ghc-' + $version + '-x86_64-unknown-mingw32'
$target      = $baseTarget + $variant
$url64       = 'https://downloads.haskell.org/~ghc/9.2.8/' + $target + '.tar.xz'
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

$tmpPath = Join-Path $packageFullName "tmp"
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
    # Now delete the extract dir
    Remove-Item -Force -Recurse $packageFullName
    Rename-Item -fo $longBinPackageDir $packageFullName
    Write-Host "Renamed $longBinPackageDir to $packageFullName"
}

if (Test-Path $tmpPath) {
    # Now delete the tmp path
    Remove-Item -Force -Recurse $tmpPath
}


# FIxes issue #8
$installScope = 'User'
if ($pp['globalinstall'] -eq 'true') {
  $installScope = 'Machine'
  Write-Host "Install scope set to global."
}
Install-ChocolateyPath "$binPackageDir" -Machine "$installScope"

# Patch the content of files at a certain line
function Write-Patch {
  param( [string] $key
       , [string] $fileName
       , [string] $template
       )

  (Get-Content $fileName) | 
    Foreach-Object {
        if ($_ -match "$key") 
        {
            #Add Lines after the selected pattern 
            "$template"
        }
        $_ # send the current line to output
    } | Set-Content $fileName

}

if (-Not $is32 -and -not $pp['no-workarounds']) {
# HACK: Work around that GHC 9.2.x is missing some components
# See each individual ticket.
#  Write-Host "`nApplying workarounds for GHC 9.2.3: `
#  * Broken depencencies: https://gitlab.haskell.org/ghc/ghc/-/issues/21196 `
#  `
#  These workarounds do not change the compiler only the packaging, to disable re-run with --params=`"'/no-workarounds'`"`n"
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
