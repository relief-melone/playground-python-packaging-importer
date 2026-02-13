{
  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pythonPkgs = pkgs.python313Packages;
        python = pkgs.python313;
        pkgs = import nixpkgs { inherit system; };
        fhs = pkgs.buildFHSEnv {
          name = "mainline_shell";
          targetPkgs = pkgs: (with pkgs; [
            python
            uv
            ta-lib
            stdenv.cc.cc.lib
            libz
            graphviz
            glibc
            gnumake clang boost pkg-config cmake
          ]);

          runScript =  pkgs.writeScript "init.sh" ''
            export SHELL=/run/current-system/sw/bin/bash
            export PYTHONPATH=$PWD
            if [ ! -f ./pyproject.toml ]; then
              echo "Creating template pyproject.toml"
              echo "${template_pyproject}" > ./pyproject.toml
              echo "Done"
            else
              echo "pyproject.toml exists. Skipping creation"
            fi

            if [ -d ./.venv ]; then
              echo ".venv found. Skipping creation"
            else
              echo "Creating Python virtual environment..."
              uv venv
              uv sync
              echo "Done!"
            fi

            echo "Activating virtual environment"
            source .venv/bin/activate
            echo "Done!"

            exec bash
          '';
        };

        template_pyproject = ''
          [project]
          name = \"project-name\"
          version = \"0.1.0\"
          requires-python = \">=3.8\"
          dependencies = [
            \"debugpy\"
          ]

          [tool.pyright]
          include = [ \"src\" ]

          [tool.poetry]
          package-mode = false

        '';
      in
      {
        devShells.default = fhs.env;
      }
    );
}
