#NOTE: Please remove any commented lines to tidy up prior to releasing the package, including this one

$version     = '7.8.4' # package version
$packageName = 'ghc' # arbitrary name for the package, used in messages
$url         = 'https://www.haskell.org/ghc/dist/7.8.4/ghc-7.8.4-i386-unknown-mingw32.tar.xz' # download url
$url64       = 'https://www.haskell.org/ghc/dist/7.8.4/ghc-7.8.4-x86_64-unknown-mingw32.tar.xz' # 64bit URL here or remove - if installer decides, then use $url

$thisScript = Split-Path -Path $MyInvocation.MyCommand.Definition -Parent
. ($thisScript +  '.\chocolateyInstall-Template.ps1')