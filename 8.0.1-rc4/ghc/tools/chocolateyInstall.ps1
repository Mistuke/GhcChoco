$version     = '8.0.0.20160421'
$packageName = 'ghc'
$url         = 'http://downloads.haskell.org/~ghc/8.0.1-rc4/ghc-8.0.0.20160421-i386-unknown-mingw32.tar.xz'
$url64       = 'http://downloads.haskell.org/~ghc/8.0.1-rc4/ghc-8.0.0.20160421-x86_64-unknown-mingw32.tar.xz'

$thisScript = Split-Path -Path $MyInvocation.MyCommand.Definition -Parent
. ($thisScript +  '.\chocolateyInstall-Template.ps1')