$version       = '6.12.3'
$packageName   = 'ghc'
$url           = 'https://www.haskell.org/ghc/dist/6.12.3/ghc-6.12.3-i386-windows.exe'
$installerType = 'exe'
$silentArgs    = '/VERYSILENT /SUPPRESSMSGBOXES /NORESTART /SP-'

Install-ChocolateyPackage $packageName $installerType $silentArgs $url