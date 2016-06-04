$version     = '7.8.1'
$packageName = 'ghc'

$thisScript = Split-Path -Path $MyInvocation.MyCommand.Definition -Parent
. ($thisScript +  '.\chocolateyUninstall-Template.ps1')