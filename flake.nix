{ lib, python3, fetchFromGitHub, gobject-introspection, wrapGAppsHook3, killall }:

# Define the waypaper package as a function.
python3.pkgs.buildPythonApplication rec {
  pname = "waypaper";
  version = "2.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "anufrievroman";
    repo = "waypaper";
    rev = "84319c3e4e22ed53e1d1b022ce6defcbe1656757";
    hash = "sha256-uQ+NQ0/xYU0N1CnXsa2zghgNaOPxWpMJXSUJJ9W7140=";
  };

  nativeBuildInputs = [
    gobject-introspection
    wrapGAppsHook3
  ];

  build-system = [ python3.pkgs.setuptools ];

  dependencies = [
    python3.pkgs.pygobject3
    python3.pkgs.platformdirs
    python3.pkgs.importlib-metadata
    python3.pkgs.pillow
  ];

  propagatedBuildInputs = [ killall ];

  # has no tests
  doCheck = false;

  dontWrapGApps = true;

  preFixup = ''
    makeWrapperArgs+=("''${gappsWrapperArgs[@]}")
  '';

  meta = with lib; {
    changelog = "https://github.com/anufrievroman/waypaper/releases/tag/${version}";
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
}
