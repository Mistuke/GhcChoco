$version     = '7.8.1'
$packageName = 'ghc'
$url         = 'https://www.haskell.org/ghc/dist/7.8.1/ghc-7.8.1-i386-unknown-mingw32.tar.xz'
$url64       = 'https://www.haskell.org/ghc/dist/7.8.1/ghc-7.8.1-x86_64-unknown-mingw32.tar.xz'

$thisScript = Split-Path -Path $MyInvocation.MyCommand.Definition -Parent
. ($thisScript +  '.\chocolateyInstall-Template.ps1')