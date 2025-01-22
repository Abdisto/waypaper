{
  description = "A flake for the waypaper package";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs }: {
    packages.x86_64-linux = let
      pkgs = import nixpkgs {
        system = "x86_64-linux";
        config.allowUnfree = true;
      };
    in {
      default = pkgs.python3Packages.buildPythonPackage rec {
        pname = "waypaper";
        version = "unstable";

        src = ./.;

        nativeBuildInputs = [
          pkgs.gobject-introspection
          pkgs.wrapGAppsHook  # Ensures GTK libraries are wrapped correctly
        ];

        buildInputs = [
          pkgs.gtk3
          pkgs.python3Packages.pygobject3
          pkgs.python3Packages.pillow
          pkgs.python3Packages.imageio
          pkgs.python3Packages.imageio-ffmpeg
          pkgs.python3Packages.screeninfo
          pkgs.python3Packages.platformdirs
        ];

        propagatedBuildInputs = [
          pkgs.killall
          pkgs.gtk3
          pkgs.python3Packages.pygobject3
          pkgs.python3Packages.importlib-metadata
          pkgs.python3Packages.imageio
          pkgs.python3Packages.pillow
          pkgs.python3Packages.imageio-ffmpeg
          pkgs.python3Packages.screeninfo
          pkgs.python3Packages.platformdirs
          pkgs.socat
        ];

        # No tests available
        doCheck = false;

        # Let wrapGAppsHook handle wrapping
        dontWrapGApps = false;

        meta = with pkgs.lib; {
          changelog = "https://github.com/anufrievroman/waypaper/releases";
          description = "GUI wallpaper setter for Wayland-based window managers";
          mainProgram = "waypaper";
          longDescription = ''
            GUI wallpaper setter for Wayland-based window managers that works as a frontend for popular backends like swaybg and swww.

            If the wallpaper does not change, make sure that swaybg or swww is installed.
          '';
          homepage = "https://github.com/anufrievroman/waypaper";
          license = licenses.gpl3Only;
          maintainers = with maintainers; [ totalchaos ];
          platforms = platforms.linux;
        };
      };
    };

    devShells.x86_64-linux = let
      pkgs = import nixpkgs { system = "x86_64-linux"; };
    in pkgs.mkShell {
      buildInputs = with pkgs; [
        gtk3
        python3
        gobject-introspection
        wrapGAppsHook
        killall
        pkgs.python3Packages.pygobject3
      ];
    };
  };
}
