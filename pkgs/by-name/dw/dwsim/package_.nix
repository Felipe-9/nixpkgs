with import <nixpkgs> { };
# {
#   lib,
#   stdenv,
#   fetchurl,
#   dpkg,
#   autoPatchelfHook,
#   dotnet-runtime,
#   ipopt,
#   nix-update-script
# }:
let
  name = "dwsim";
  version = "9.0.2";
  description = "an open-source CAPE-OPEN compliant Chemical Process Simulator";
in
builtDotnetModule {
  inherit name version;

  meta = with lib; {
    inherit description;
    mainProgram = name;
    homepage = "https://github.com/DanWBR/dwsim";
    license = licenses.gpl3;
    sourceProvenance = [ sourceTypes.fromSource ];
    maintainers = with maintainers; [ felipe-9 ];
    longDescription = ''
      Built on the .NET and Mono frameworks, it features a user-friendly graphical interface and robust tools for steady-state simulations, including vapor-liquid, solid-liquid, and electrolyte equilibrium processes. Its extensive capabilities include thermodynamic models like Peng-Robinson, UNIFAC, and IAPWS-IF97; unit operations such as reactors, distillation columns, and heat exchangers; and utilities for regression, phase envelopes, and petroleum characterization. DWSIM also supports optimization, sensitivity analysis, Python scripting, and CAPE-OPEN plugins
    '';
    platforms = lib.platforms.linux;
  };

  desktopItems = [
    (makeDesktopItem {
      inherit name;
      exec = name;
      icon = name;
      desktopName = lib.toUpper name;
      genericName = "Chemical Process Simulator";
      encoding = "UTF-8";
      comment = description;
      type = "Application";
      categories = [
        "Science"
        "Chemistry"
      ];
      terminal = true;
      StartupNotify = false;
    })
  ];

  nuggetDeps = writers.writeJSON "dwsim_deps.json" {

  };

  passthru.updateScript = nix-update-script { };

  src = fetchFromGitHub {
    owner = "DanWBR";
    repo = "dwsim";
    tag = "v${version}";
    sha256 = "";
  };

  upackCmd = "${lib.getExe p7zip} x $downloadedFile";

  # buildInputs = [
  #   at-spi2-atk
  #   cairo
  #   dotnet-runtime
  #   gdk-pixbuf
  #   glamoroustoolkit
  #   gtk3
  #   ipopt
  #   pango
  #   pyfa
  # ];

  # installPhase = ''
  #   runHook preInstall
  #
  #   mkdir -p \
  #     $out/bin \
  #     $out/lib \
  #     $out/share/pixmaps \
  #     $out/share/applications
  #
  #   cp -r $src $out/lib
  #   ln -s $out/lib/dwsim/bitmaps/DWSIM_ico.png $out/share/pixmaps/dwsim.png
  #   # dpkg-deb -x $src $out
  #   mv $out/usr/* $out
  #   rm -rf $out/usr
  #
  #   runHook postInstall
  # '';
}
