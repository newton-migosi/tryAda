{
  description = "Ada lang tutorial";

  inputs.flakes.url = "github:deemp/flakes";

  outputs = inputs: inputs.flakes.makeFlake {
    inputs = { inherit (inputs.flakes.all) nixpkgs codium devshell flakes-tools formatter; };

    perSystem = { inputs, system }:
      let
        pkgs = inputs.nixpkgs.legacyPackages.${system};
        inherit (inputs.codium.lib.${system}) mkCodium writeSettingsJSON extensions extensionsCommon settingsNix settingsCommonNix;
        inherit (inputs.codium.outputs.inputs.nix-vscode-extensions.extensions.${system}) vscode-marketplace;
        inherit (inputs.devshell.lib.${system}) mkShell mkCommands mkRunCommands mkRunCommandsDir;
        inherit (inputs.flakes-tools.lib.${system}) mkFlakesTools;

        tools = [ pkgs.gnat12 pkgs.gprbuild pkgs.gdb ];

        packages = {
          codium = mkCodium {
            extensions = extensionsCommon // {
              inherit (extensions) nix;
              extra = {
                inherit (vscode-marketplace.adacore) ada;
                inherit (vscode-marketplace.webfreak) debug;
              };
            };
            runtimeDependencies = [
              pkgs.direnv
              pkgs.bashInteractive
            ] ++ tools;
          };

          hello_world = pkgs.stdenv.mkDerivation {
            pname = "hello_world";
            version = "v0.0.0";
            src = ./.;
            buildInputs = tools;

            buildPhase = ''
              gprbuild hello_world
            '';

            installPhase = ''
              mkdir -p $out/bin
              mv ./.objs/hello_world $out/bin
            '';
          };

          inherit (mkFlakesTools { dirs = [ "." ]; root = ./.; }) format;

          writeSettings = writeSettingsJSON (settingsCommonNix // { inherit adaIdeSettings; });
        };

        adaIdeSettings = {
          "ada.projectFile" = "./hello_world.gpr";
        };

        devShells = {
          basic = pkgs.mkShell {
            shellHook = ''
              PS1='\u@\h:\@; '
              nix flake run github:qbit/xin#flake-warn
              echo "Ada `${pkgs.gnat12}/bin/gnatmake --version`"
            '';
            nativeBuildInputs = tools;
          };

          default = mkShell {
            packages = tools;
            bash.extra = ''
              nix flake run github:qbit/xin#flake-warn
              echo "Ada `${pkgs.gnat12}/bin/gnatmake --version`"
            '';
            commands =
              mkCommands "tools" tools ++
              mkRunCommandsDir "." "infra" { inherit (packages) format; } ++
              (mkRunCommands "ide" {
                "codium ." = packages.codium;
                inherit (packages) writeSettings;
              }
              );
          };
        };
      in
      {
        inherit packages devShells;

        formatter = inputs.formatter.${system};
      };
  };
}
