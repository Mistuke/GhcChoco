#NOTE: Please remove any commented lines to tidy up prior to releasing the package, including this one

$version     = '7.10.1' # package version
$packageName = 'ghc' # arbitrary name for the package, used in messages
$url         = 'https://www.haskell.org/ghc/dist/7.10.1/ghc-7.10.1-i386-unknown-mingw32.tar.xz' # download url
$url64       = 'https://www.haskell.org/ghc/dist/7.10.1/ghc-7.10.1-x86_64-unknown-mingw32.tar.xz' # 64bit URL here or remove - if installer decides, then use $url

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
  Get-ChocolateyUnzip -fileFullPath (Join-Path $env:chocolateyPackageFolder ("tmp\" + $packageName + "Install")) -destination "$packageFullName"

  Write-Host "Adding `'$binPackageDir`' to the path and the current shell path"
  Install-ChocolateyPath "$binPackageDir"
  $env:Path = "$binPackageDir;$($env:Path)"
  
  Write-ChocolateySuccess "$packageName"
} catch {
  Write-ChocolateyFailure "$packageName" "$($_.Exception.Message)"
  throw
}
