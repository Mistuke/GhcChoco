$version     = '8.0.1.20161213'
$packageName = 'ghc'
$url         = ''
$url64       = 'http://downloads.haskell.org/~ghc/8.0.2-rc2/ghc-8.0.1.20161213-x86_64-unknown-mingw32.tar.xz'

$thisScript = Split-Path -Path $MyInvocation.MyCommand.Definition -Parent
. ($thisScript +  '.\chocolateyInstall-Template.ps1')