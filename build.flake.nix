{
  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
    let
      pkgs = import nixpkgs { inherit system; };
      fhs = pkgs.buildFHSEnv {
        name = "mainline_shell";
        targetPkgs = pkgs: (with pkgs; [
          buildah
          cacert
          openssh
        ]);
        runScript = pkgs.writeScript "init.sh" ''
          echo "Welcome to the build shell!"
          exec bash
        '';
      };
    in
    {

      devShells.default = fhs.env;
    });
}
