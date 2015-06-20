function UnInstall-Path {
param(
  [string] $pathToInstall
)
  Write-Debug "Running 'UnInstall-Path' with pathToInstall:`'$pathToInstall`'";
  $originalPathToInstall = $pathToInstall

  #get the PATH variable
  $envPath = $env:PATH
  if ($envPath.ToLower().Contains($pathToInstall.ToLower()))
  {
    $pathType = [System.EnvironmentVariableTarget]::User
    Write-Host "PATH environment variable does have $pathToInstall in it. Removing..."
    $actualPath = Get-EnvironmentVariable -Name 'Path' -Scope $pathType

    $statementTerminator = ";"
    #does the path end in ';'?
    $hasStatementTerminator = $actualPath -ne $null -and $actualPath.EndsWith($statementTerminator)
    # if the last digit is not ;, then we are adding it
    If (!$hasStatementTerminator -and $actualPath -ne $null) {$pathToInstall = $statementTerminator + $pathToInstall}
    if (!$pathToInstall.EndsWith($statementTerminator)) {$pathToInstall = $pathToInstall + $statementTerminator}
    $actualPath = $actualPath.Replace($pathToInstall, '')
    
    Write-Host "$actualPath"

    Set-EnvironmentVariable -Name 'Path' -Value $actualPath -Scope $pathType
  }
}

try {
  #$installDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
  ### For BinRoot, use the following instead ###
  $binRoot         = Get-BinRoot
  $installDir      = Join-Path $binRoot "$packageName"
  $packageFullName = Join-Path $installDir ($packageName + '-' + $version)
  $binPackageDir   = Join-Path $packageFullName "bin"
  $zipPackage      = Join-Path $env:chocolateyPackageFolder (Join-Path tmp ($packageName + "Install"))
  
  # first uninstal the package
  UnInstall-ChocolateyZipPackage "$packageName" "$zipPackage"
  # then clean up the directory
  # just blast away everything since the folders are versioned, and if we got this far the package was installed by us
  rm -r -fo $packageFullName

  Write-Host "Removing `'$binPackageDir`' from the path and the current shell path"
  UnInstall-Path "$binPackageDir"
} catch {
  throw $_.Exception
}
