{
  description = "EscapeFromCurry";
  inputs.nixpkgs.url = "github:NixOs/nixpkgs/nixos-unstable";
  inputs.flake-utils.url = "github:numtide/flake-utils";

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        hPkgs = pkgs.haskell.packages."ghc94";

      projectDevTools = [
        hPkgs.ghc
        hPkgs.ghcid
        hPkgs.fourmolu
        hPkgs.hlint
        hPkgs.hoogle
        hPkgs.haskell-language-server
        hPkgs.implicit-hie
        hPkgs.retrie
        hPkgs.gloss
        stack-wrapped
        pkgs.zlib
        pkgs.libGL
        pkgs.libGLU
      ];

      stack-wrapped = pkgs.symlinkJoin {
        name = "stack";
        paths = [ pkgs.stack ];
        buildInputs = [ pkgs.makeWrapper ];
        postBuild = ''
          wrapProgram $out/bin/stack \
            --add-flags "\
              --no-nix \
              --system-ghc \
              --no-install-ghc \
            "
          '';
      };
    in {
      devShells.default = pkgs.mkShell {
        buildInputs = projectDevTools;

        LD_LIBRARY_PATH = pkgs.lib.makeLibraryPath projectDevTools;
      };
    });
}
