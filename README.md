## Description

This source tree is meant to reproduce an issue.
The problem I'm trying to solve is to write code against the GHC 9.3.x 
API from GHC HEAD, while compiling with a bootstrap compiler.
At present my bootstrap compiler is ghc 9.0.1, but I have
experience a similar issue with 8.10.5.

## Steps to reproduce the issue

 1. Install GHC 9.0.1 and make it the default `ghc`.

 2. Check out a fresh GHC HEAD according to the usual instructions.

 3. Build the fresh GHC head with Hadrian, using `ghc` (9.0.1) as the
    bootstrap compiler.  (Note: in my UserSettings.hs, included in the
    `other` directory, I have the `-haddock` option set.)

 4. Take note of the absolute path of `_build/stage0` and set shell
    variable `STAGE0` to this path:

    ```
    nr@homedog ~/a/sample-ghc-client> echo $STAGE0
    /home/nr/asterius/ghc/_build/stage0
    ```

 5. On line 7 of `src/Main.hs`, set Haskell variable `stage0` to this
    same string.

 6. Configure this package to use the `stage0` library as the only
    source of packages:

    ```
    nr@homedog ~/a/sample-ghc-client> cabal v1-configure --package-db clear --package-db $STAGE0/lib/package.conf.d/
    Resolving dependencies...
    Configuring sample-ghc-client-0.1.0.0...
    ```

 7. Build the package.

    ```
    nr@homedog ~/a/sample-ghc-client> cabal v1-build
    Preprocessing executable 'sample-ghc-client' for sample-ghc-client-0.1.0.0..
    Building executable 'sample-ghc-client' for sample-ghc-client-0.1.0.0..
    [1 of 1] Compiling Main             ( src/Main.hs, dist/build/sample-ghc-client/sample-ghc-client-tmp/Main.o )
    Linking dist/build/sample-ghc-client/sample-ghc-client ...
    ```

 8. Run the resulting binary:

    ```
    nr@homedog ~/a/sample-ghc-client> ./dist/build/sample-ghc-client/sample-ghc-client
    libdir == /home/nr/asterius/ghc/_build/stage0/lib
    panic! (the 'impossible' happened)
      GHC version 9.3.20210918:
            GHC couldn't find the RTS constants (#define HS_CONSTANTS ") in /home/nr/.ghcup/ghc/9.0.1/lib/ghc-9.0.1/include/DerivedConstants.h: the RTS package you are trying to use is perhaps for another GHC version(e.g. you are using the wrong package database) or the package database is broken.

    CallStack (from HasCallStack):
      error, called at _build/stage0/compiler/build/GHC/Platform/Constants.hs:143:20 in ghc:GHC.Platform.Constants

    Please report this as a GHC bug:  https://www.haskell.org/ghc/reportabug
    ```

