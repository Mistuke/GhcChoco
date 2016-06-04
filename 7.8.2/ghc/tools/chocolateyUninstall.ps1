$version     = '7.8.2'
$packageName = 'ghc'

$thisScript = Split-Path -Path $MyInvocation.MyCommand.Definition -Parent
. ($thisScript +  '.\chocolateyUninstall-Template.ps1')