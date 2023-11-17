{
  description = "SwayAudioIdleInhibit flake";

  inputs = {
    nixpkgs = {
      url = "github:NixOS/nixpkgs/nixos-unstable";
    };
    flake-utils = {
      url = "github:numtide/flake-utils";
    };
  };

  outputs = { self, nixpkgs, flake-utils }: 
    flake-utils.lib.eachDefaultSystem (system:
      let 
        overlays = [];
        version = "0.1.1";
        pkgs = import nixpkgs {
          inherit system overlays;
        };
        buildInputs = with pkgs; [ 
          meson
          cmake 
          pkg-config 
          wayland-protocols 
          libpulseaudio
          wayland
          ninja
        ];
      in with pkgs; {
      devShells.default = mkShell {
        inherit buildInputs;
      };
      packages.default = stdenv.mkDerivation {
        inherit buildInputs version;
        name = "sway-audio-inhibit-idle-${version}";
        src = ./.;
        dontUseCmakeConfigure = true;
        shellHook = ''
          export PKG_CONFIG_PATH="${pkgs.pkg-config}/lib/pkgconfig"
        '';
        configurePhase = ''
          ${pkgs.meson}/bin/meson build
        '';
        buildPhase = ''
          ${pkgs.ninja}/bin/ninja -C build
        '';
        installPhase = ''
          mkdir -p $out/bin
          cp ./build/sway-audio-idle-inhibit $out/bin
        '';
      };
    }
  );
}




