$version     = '9.0.1'
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

# Fixes issue #4
if ($pp['installdir']) {
  $binRoot         = $pp['installdir']
} else {
  $binRoot         = $(Split-Path -parent $MyInvocation.MyCommand.Definition)
}
$packageFullName = Join-Path $binRoot ($packageName + '-' + $version)
$binPackageDir   = Join-Path $packageFullName "bin"

if (-Not $is32) {
# HACK: Work around that GHC 9.0 is missing some components
# See https://github.com/Mistuke/GhcChoco/issues/13
  Remove-Item "$binPackageDir\ghcii-$version.sh"
  Remove-Item "$binPackageDir\ghcii.sh"

  Uninstall-BinFile "ghc-$version"
  Uninstall-BinFile "ghci-$version"
  Uninstall-BinFile "haddock-$version"
}