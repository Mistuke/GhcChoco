$version     = '8.0.1.20161117'
$packageName = 'ghc'

$thisScript = Split-Path -Path $MyInvocation.MyCommand.Definition -Parent
. ($thisScript +  '.\chocolateyUninstall-Template.ps1')