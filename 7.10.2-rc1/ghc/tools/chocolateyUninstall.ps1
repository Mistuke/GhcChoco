$version     = '7.10.1.20150612'
$packageName = 'ghc'

$thisScript = Split-Path -Path $MyInvocation.MyCommand.Definition -Parent
. ($thisScript +  '.\chocolateyUninstall-Template.ps1')