{
  description = "A flake for the waypaper package";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs }: {
    packages.x86_64-linux = let
      inherit (nixpkgs) lib;
      pkgs = import nixpkgs {
        system = "x86_64-linux";
        config = {
          allowUnfree = true;
        };
      };
    in {
      default = pkgs.python3.pkgs.buildPythonApplication rec {
        pname = "waypaper";
        version = "unstable";  # Reflects that it's not pinned to a specific commit
        pyproject = true;

        src = ./.;

        nativeBuildInputs = [
          pkgs.gobject-introspection
          pkgs.wrapGAppsHook3
        ];

        build-system = [ pkgs.python3.pkgs.setuptools ];

        dependencies = [
          pkgs.python3.pkgs.pygobject3
          pkgs.python3.pkgs.platformdirs
          pkgs.python3.pkgs.importlib-metadata
          pkgs.python3.pkgs.pillow
        ];

        propagatedBuildInputs = [ pkgs.killall ];

        # has no tests
        doCheck = false;

        dontWrapGApps = true;

        preFixup = ''
          makeWrapperArgs+=(\"''${gappsWrapperArgs[@]}\")
        '';

        meta = with pkgs.lib; {
          changelog = "https://github.com/anufrievroman/waypaper/releases";
          description = "GUI wallpaper setter for Wayland-based window managers";
          mainProgram = "waypaper";
          longDescription = ''
            GUI wallpaper setter for Wayland-based window managers that works as a frontend for popular backends like swaybg and swww.

            If wallpaper does not change, make sure that swaybg or swww is installed.
          '';
          homepage = "https://github.com/anufrievroman/waypaper";
          license = licenses.gpl3Only;
          maintainers = with maintainers; [ totalchaos ];
          platforms = platforms.linux;
        };
      };
    };

    devShells.x86_64-linux = let
      pkgs = import nixpkgs {
        system = "x86_64-linux";
      };
    in pkgs.mkShell {
      buildInputs = with pkgs; [
        python3
        gobject-introspection
        wrapGAppsHook3
        killall
      ];
    };
  };
}
