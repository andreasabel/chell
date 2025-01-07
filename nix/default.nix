{ pkgs }:

let
  inherit (pkgs.lib) fold composeExtensions concatMap attrValues;

  combineOverrides = old:
    fold composeExtensions (old.overrides or (_: _: { }));

  makeTestConfiguration = { ghc ? pkgs.haskellPackages, overrides ? new: old: { } }:
    let
      inherit (pkgs.haskell.lib) dontCheck packageSourceOverrides;
    in
    rec {
      haskellPackages =
        ghc.override (old: {
          overrides =
            combineOverrides old [
              (packageSourceOverrides {
                chell = ../chell;
                chell-hunit = ../chell-hunit;
                chell-quickcheck = ../chell-quickcheck;
              })
              overrides
            ];
        });

      all = pkgs.symlinkJoin {
        name = "chell-packages";
        paths = [
          haskellPackages.chell
          haskellPackages.chell-hunit
          haskellPackages.chell-quickcheck
        ];
      };
    };

  testConfigurations =
    rec {
      ghc-9-2 = makeTestConfiguration {
        ghc = pkgs.haskell.packages.ghc92;
        overrides = new: old: {
          monads-tf = new.callPackage ./haskell/monads-tf.nix { };
          options = new.callPackage ./haskell/options.nix { };
        };
      };
      ghc-9-4 = makeTestConfiguration {
        ghc = pkgs.haskell.packages.ghc94;
        overrides = new: old: {
          monads-tf = new.callPackage ./haskell/monads-tf.nix { };
          options = new.callPackage ./haskell/options.nix { };
        };
      };
      ghc-9-6 = makeTestConfiguration {
        ghc = pkgs.haskell.packages.ghc96;
        overrides = new: old: {
          monads-tf = new.callPackage ./haskell/monads-tf.nix { };
          options = new.callPackage ./haskell/options.nix { };
        };
      };
      all = pkgs.symlinkJoin {
        name = "chell-tests";
        paths = [ ghc-9-2.all ghc-9-4.all ghc-9-6.all ];
      };
    };

in
{

  packages = {
    inherit testConfigurations;
  };

  devShells.default = pkgs.mkShell {
    inputsFrom = [
      (makeTestConfiguration {
        overrides = new: old: {
          monads-tf = new.callPackage ./haskell/monads-tf.nix { };
          options = new.callPackage ./haskell/options.nix { };
        };
      }).haskellPackages.chell.env
    ];
    buildInputs = [
      pkgs.haskell-language-server
      pkgs.cabal-install
    ];
  };

}
