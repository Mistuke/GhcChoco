$version     = '9.4.6'
$packageName = 'ghc'
$url         = 'https://downloads.haskell.org/~ghc/8.6.5/ghc-8.6.5-i386-unknown-mingw32.tar.xz'
$binSha256   = '6dc0e79a37510905074bcf7e8af9014bd5f899791a6739876ef703de9011e0e6'
$variant     = ''
$pp          = Get-PackageParameters
if ($pp['integer-simple']) {
  $variant = '-integer-simple'
  $binSha256 = '7abcff01e7cd390860e7f7a64d070b613819a2c21314cadeddac452b2ca03a32'
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