{
  description = "rsensor - A lightweight system monitoring tool written in Rust (from GitHub)";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    rsensor-src = {
      url = "github:tahuffman1s/rsensor";
      flake = false;
    };
  };

  outputs = { self, nixpkgs, flake-utils, rsensor-src }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        
        rsensor = pkgs.rustPlatform.buildRustPackage {
          pname = "rsensor";
          version = "0.1.0";
          
          src = rsensor-src;
          
          cargoLock = {
            lockFile = "${rsensor-src}/Cargo.lock";
          };
          
          nativeBuildInputs = with pkgs; [
            pkg-config
            installShellFiles
            makeWrapper
          ];
          
          buildInputs = with pkgs; [
            # Required for crossterm terminal handling
            stdenv.cc.cc.lib
          ];
          
          # Remove .cargo/config.toml since it references a local vendor dir
          postPatch = ''
            rm -f .cargo/config.toml
          '';
          
          # Runtime dependencies for hardware monitoring
          runtimeDependencies = with pkgs; [
            pciutils  # for lspci command
          ];
          
          postInstall = ''
            # Install desktop file
            install -Dm644 ${rsensor-src}/org.tahuffman1s.rsensor.desktop \
              $out/share/applications/org.tahuffman1s.rsensor.desktop
            
            # Install appdata
            install -Dm644 ${rsensor-src}/org.tahuffman1s.rsensor.appdata.xml \
              $out/share/metainfo/org.tahuffman1s.rsensor.appdata.xml
            
            # Install icon
            install -Dm644 ${rsensor-src}/assets/icons/rsensor.svg \
              $out/share/icons/hicolor/scalable/apps/org.tahuffman1s.rsensor.svg
          '';
          
          # Wrap the binary to ensure runtime dependencies are available
          postFixup = ''
            wrapProgram $out/bin/rsensor \
              --prefix PATH : ${pkgs.lib.makeBinPath [ pkgs.pciutils ]}
          '';
          
          meta = with pkgs.lib; {
            description = "A lightweight system monitoring tool written in Rust";
            longDescription = ''
              rsensor is a terminal-based system monitoring tool inspired by psensor.
              It provides real-time CPU monitoring, memory usage statistics, and GPU
              monitoring with a clean, responsive terminal interface.
            '';
            homepage = "https://github.com/tahuffman1s/rsensor";
            license = licenses.mit;
            maintainers = [ ];
            platforms = platforms.linux;
            mainProgram = "rsensor";
          };
        };
      in
      {
        packages = {
          default = rsensor;
          rsensor = rsensor;
        };
        
        apps.default = {
          type = "app";
          program = "${rsensor}/bin/rsensor";
        };
        
        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; [
            rustc
            cargo
            rust-analyzer
            pkg-config
            pciutils
          ];
          
          shellHook = ''
            echo "rsensor development environment"
            echo "Clone the repository with: git clone https://github.com/tahuffman1s/rsensor"
            echo "Then run 'cargo build' to build the project"
          '';
        };
      }
    );
}
