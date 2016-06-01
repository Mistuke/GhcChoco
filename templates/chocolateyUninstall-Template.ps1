try {
  $binRoot         = $(Split-Path -parent $MyInvocation.MyCommand.Definition)
  $packageFullName = Join-Path $binRoot ($packageName + '-' + $version)
  $binPackageDir   = Join-Path $packageFullName "bin"
  
  # then clean up the directory
  # just blast away everything since the folders are versioned, and if we got this far the package was installed by us
  rm -r -fo $packageFullName

  Write-Host "Removing `'$binPackageDir`' from the path and the current shell path"
  UnInstall-Path "$binPackageDir"
} catch {
  throw $_.Exception
}
