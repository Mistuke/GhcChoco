$version     = '9.4.7'
$packageName = 'ghc'
$url         = 'https://downloads.haskell.org/~ghc/8.6.5/ghc-8.6.5-i386-unknown-mingw32.tar.xz'
$binSha256   = '415e6adebd764d278ecfe4ebf656ff96902953b8b669fba7dae2525af6665172'
$variant     = ''
$pp          = Get-PackageParameters
if ($pp['integer-simple']) {
  $variant = '-integer-simple'
  $binSha256 = 'f46a9c1ce07d99abc9285dd00b7f2630e71e906cf4234c8150aeb9441cdee9b7'
}
$baseTarget  = 'ghc-' + $version + '-x86_64-unknown-mingw32'
$target      = $baseTarget + $variant
$url64       = 'https://downloads.haskell.org/~ghc/9.4.6/' + $target + '.tar.xz'
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

}

Remove-Item -Force -Recurse $packageFullName