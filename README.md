# GhcChoco
Chocolatey sources for pure GHC installs

This repository contains the sources for the GHC Chocolatey packages.

To use these get Chocolatey https://chocolatey.org/

and then just install the version of GHC you want.

    cinst ghc
    
for the latest version

    cinst ghc -pre 
    
for the latest pre-release version

    cinst ghc -version 7.8.4 
    
for  specific version, e.g. `7.8.4`

The installer will automatically pick the right bitness for your OS, but if you would
like to force it to get `x86` on `x86_64` you can:

    cinst ghc -x86

The installer will also always install in `C:\ghc` if this is a problem create an issue and I will
attempt to address it.

uninstalling can be done with
    
    cuninst ghc
    
If more than one version of `GHC` is present then you will be presented with prompt on which version you
would like to install.

** Note: Unfortunately because of a how Chocolatey currently works, you will have to restart the console**
**       in order for the PATH variables to be correct. The current section cannot be updated. **