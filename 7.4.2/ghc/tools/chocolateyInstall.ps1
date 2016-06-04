$version       = '7.4.2'
$packageName   = 'ghc'
$url           = 'https://www.haskell.org/ghc/dist/7.4.2/ghc-7.4.2-i386-windows.exe'
$installerType = 'exe'
$silentArgs    = '/VERYSILENT /SUPPRESSMSGBOXES /NORESTART /SP-'

Install-ChocolateyPackage $packageName $installerType $silentArgs $url