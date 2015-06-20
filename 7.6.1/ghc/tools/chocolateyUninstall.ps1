#NOTE: Please remove any commented lines to tidy up prior to releasing the package, including this one

$version     = '7.6.1' # package version
$packageName = 'ghc' # arbitrary name for the package, used in messages

$thisScript = Split-Path -Path $MyInvocation.MyCommand.Definition -Parent
. ($thisScript +  '.\chocolateyUninstall-Template.ps1')