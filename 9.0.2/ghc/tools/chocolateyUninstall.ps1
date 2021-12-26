$version     = '9.0.2'
$packageName = 'ghc'
$url         = 'https://downloads.haskell.org/~ghc/8.6.5/ghc-8.6.5-i386-unknown-mingw32.tar.xz'
$binSha256   = 'f6fbb8047ae16049dc6215a6abb652b4307205310bfffddea695a854af92dc99'
$variant     = ''
$pp          = Get-PackageParameters
if ($pp['integer-simple']) {
  $variant = '-integer-simple'
  $binSha256 = '03eb59dd881ad577784b9505894860bdb74220d0e1e5062ee53a3853eb833793'
}
$baseTarget  = 'ghc-' + $version + '-x86_64-unknown-mingw32'
$target      = $baseTarget + $variant
$url64       = 'https://downloads.haskell.org/~ghc/9.0.2/' + $target + '.tar.xz'
$is32 = (Get-OSArchitectureWidth 32)  -or $env:chocolateyForceX86 -eq 'true'

# Fixes issue #4
if ($pp['installdir']) {
  $binRoot         = $pp['installdir']
} else {
  $binRoot         = Get-ToolsLocation
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

Remove-Item -Force -Recurse $packageFullName