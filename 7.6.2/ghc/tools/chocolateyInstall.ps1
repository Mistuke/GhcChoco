$version     = '7.6.2'
$packageName = 'ghc'
$url         = 'https://www.haskell.org/ghc/dist/7.6.2/ghc-7.6.2-i386-unknown-mingw32.tar.bz2'
$url64       = 'https://www.haskell.org/ghc/dist/7.6.2/ghc-7.6.2-x86_64-unknown-mingw32.tar.bz2'

$thisScript = Split-Path -Path $MyInvocation.MyCommand.Definition -Parent
. ($thisScript +  '.\chocolateyInstall-Template.ps1')