$version     = '7.10.3' # package version
$packageName = 'ghc' # arbitrary name for the package, used in messages
$url         = 'http://downloads.haskell.org/~ghc/7.10.3/ghc-7.10.3-i386-unknown-mingw32.tar.xz' # download url
$url64       = 'http://downloads.haskell.org/~ghc/7.10.3/ghc-7.10.3-x86_64-unknown-mingw32.tar.xz' # 64bit URL here or remove - if installer decides, then use $url

$thisScript = Split-Path -Path $MyInvocation.MyCommand.Definition -Parent
. ($thisScript +  '.\chocolateyInstall-Template.ps1')