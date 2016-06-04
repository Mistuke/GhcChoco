$version     = '7.10.3'
$packageName = 'ghc'
$url         = 'http://downloads.haskell.org/~ghc/7.10.3/ghc-7.10.3-i386-unknown-mingw32.tar.xz'
$url64       = 'http://downloads.haskell.org/~ghc/7.10.3/ghc-7.10.3-x86_64-unknown-mingw32.tar.xz'

$thisScript = Split-Path -Path $MyInvocation.MyCommand.Definition -Parent
. ($thisScript +  '.\chocolateyInstall-Template.ps1')