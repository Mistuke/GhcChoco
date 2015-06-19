﻿#NOTE: Please remove any commented lines to tidy up prior to releasing the package, including this one

$version     = '7.10.1' # package version
$packageName = 'ghc' # arbitrary name for the package, used in messages
$url         = 'https://www.haskell.org/ghc/dist/7.10.1/ghc-7.10.1-i386-unknown-mingw32.tar.xz' # download url
$url64       = 'https://www.haskell.org/ghc/dist/7.10.1/ghc-7.10.1-x86_64-unknown-mingw32.tar.xz' # 64bit URL here or remove - if installer decides, then use $url


function Install-Path {
param(
  [string] $pathToInstall
)
  Write-Debug "Running 'Install-Path' with pathToInstall:`'$pathToInstall`'";
  $originalPathToInstall = $pathToInstall

  #get the PATH variable
  $envPath = $env:PATH
  if (!$envPath.ToLower().Contains($pathToInstall.ToLower()))
  {
    $pathType = [System.EnvironmentVariableTarget]::User
    Write-Host "PATH environment variable does not have $pathToInstall in it. Adding..."
    $actualPath = Get-EnvironmentVariable -Name 'Path' -Scope $pathType

    $statementTerminator = ";"
    #does the path end in ';'?
    $hasStatementTerminator = $actualPath -ne $null -and $actualPath.EndsWith($statementTerminator)
    # if the last digit is not ;, then we are adding it
    If (!$hasStatementTerminator -and $actualPath -ne $null) {$pathToInstall = $statementTerminator + $pathToInstall}
    if (!$pathToInstall.EndsWith($statementTerminator)) {$pathToInstall = $pathToInstall + $statementTerminator}
    $actualPath = $pathToInstall + $actualPath

    Set-EnvironmentVariable -Name 'Path' -Value $actualPath -Scope $pathType

    #add it to the local path as well so users will be off and running
    $envPSPath = $env:PATH
    $Env:Path = $pathToInstall + $statementTerminator + $envPSPath
    echo $Env:Path
  }
}

try {
  #$installDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
  ### For BinRoot, use the following instead ###
  $binRoot         = Get-BinRoot
  $installDir      = Join-Path $binRoot "$packageName"
  $packageFullName = Join-Path $installDir ($packageName + '-' + $version)
  $binPackageDir   = Join-Path $packageFullName "bin"
  
  # if removing $url64, please remove from here
  # despite the name "Install-ChocolateyZipPackage" this also works with 7z archives
  Install-ChocolateyZipPackage "$packageName" "$url" (Join-Path $env:chocolateyPackageFolder tmp) "$url64"
  Get-ChocolateyUnzip -fileFullPath (Join-Path $env:chocolateyPackageFolder (Join-Path tmp ($packageName + "Install"))) -destination "$installDir"

  Write-Host "Adding `'$binPackageDir`' to the path and the current shell path"
  Install-Path "$binPackageDir"
  # Reload the session to update path
  Update-SessionEnvironment
} catch {
  # just blast away everything since the folders are versioned
  rm -r -fo $packageFullName
  throw $_.Exception
}

