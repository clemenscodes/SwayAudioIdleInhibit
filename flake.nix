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
        pkgs = import nixpkgs {
          inherit system overlays;
        };
      in with pkgs; {
      devShells.default = mkShell {
        buildInputs = with pkgs; [ 
          meson
          cmake 
          pkg-config 
          wayland-protocols 
          libpulseaudio
          wayland
          ninja
        ];
      };
    }
  );
}
