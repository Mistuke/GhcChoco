$version     = '8.0.1' # package version
$packageName = 'ghc' # arbitrary name for the package, used in messages

$thisScript = Split-Path -Path $MyInvocation.MyCommand.Definition -Parent
. ($thisScript +  '.\chocolateyUninstall-Template.ps1')