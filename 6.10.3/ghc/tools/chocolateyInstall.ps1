#NOTE: Please remove any commented lines to tidy up prior to releasing the package, including this one

$version       = '6.10.3' # package version
$packageName   = 'ghc' # arbitrary name for the package, used in messages
$url           = 'https://www.haskell.org/ghc/dist/6.10.3/ghc-6.10.3-i386-windows.exe' # download url
$installerType = 'exe'
$silentArgs    = '/VERYSILENT /SUPPRESSMSGBOXES /NORESTART /SP-'

Install-ChocolateyPackage $packageName $installerType $silentArgs $url