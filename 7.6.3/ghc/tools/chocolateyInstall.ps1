#NOTE: Please remove any commented lines to tidy up prior to releasing the package, including this one

$version     = '7.6.3' # package version
$packageName = 'ghc' # arbitrary name for the package, used in messages
$url         = 'https://www.haskell.org/ghc/dist/7.6.3/ghc-7.6.3-i386-unknown-mingw32.tar.bz2' # download url
$url64       = 'https://www.haskell.org/ghc/dist/7.6.3/ghc-7.6.3-x86_64-unknown-mingw32.tar.bz2' # 64bit URL here or remove - if installer decides, then use $url

$thisScript = Split-Path -Path $MyInvocation.MyCommand.Definition -Parent
. ($thisScript +  '.\chocolateyInstall-Template.ps1')