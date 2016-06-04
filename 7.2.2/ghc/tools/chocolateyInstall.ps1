$version       = '7.2.2'
$packageName   = 'ghc'
$url           = 'https://www.haskell.org/ghc/dist/7.2.2/ghc-7.2.2-i386-windows.exe'
$installerType = 'exe'
$silentArgs    = '/VERYSILENT /SUPPRESSMSGBOXES /NORESTART /SP-'

Install-ChocolateyPackage $packageName $installerType $silentArgs $url