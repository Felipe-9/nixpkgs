{
  lib,
  stdenv,
  fetchurl,

  autoPatchelfHook,
  geoclue,
  glib,
  gsettings-desktop-schemas,
  gtk3,
  icu,
  libX11,
  libgcc,
  libjpeg,
  libpng,
  libwebp,
  mono,
  p7zip,
  webkitgtk,
  wrapGAppsHook,
  zlib,
}:
stdenv.mkDerivation rec {

  name = "dwsim_${version}";
  version = "9.0.2";

  src = fetchurl {
    url = "https://github.com/DanWBR/dwsim/releases/download/v${version}/dwsim_${version}-linux64_portable.7z";
    hash = "176hakyd511w0qlqggk8snd8fkwpfgyh9svp8hpkzdri47bin1jb";
  };

  sourceRoot = ".";

  nativeBuildInputs = [
    p7zip
    autoPatchelfHook
    wrapGAppsHook
  ];
  buildInputs = [
    gtk3
    glib
    libX11
    zlib
    libpng
    libjpeg
    webkitgtk
    icu
    geoclue
    libwebp
    libgcc
    mono
    gsettings-desktop-schemas
  ];

  installPhase = ''
    mkdir -p $out/lib/dwsim $out/bin
    cp -r * $out/lib/dwsim
    chmod +x $out/lib/dwsim/DWSIM
    ln -s $out/lib/dwsim/DWSIM $out/bin/dwsim

    # Remove bundled libraries we want to replace with Nix's versions
    rm -f $out/lib/dwsim/libicudata.so.55.1
    rm -f $out/lib/dwsim/libicui18n.so.55.1
    rm -f $out/lib/dwsim/libicuuc.so.55.1
    rm -f $out/lib/dwsim/libwebkit-1.0.so
  '';

  preFixup = ''
    # Additional patching for dotnet dependencies
    patchelf --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
      $out/lib/dwsim/DWSIM

    # Fix paths for critical dependencies
    for f in $out/lib/dwsim/*.so*; do
      patchelf --shrink-rpath --allowed-rpath-prefixes "$NIX_STORE" "$f" || true
    done

    gappsWrapperArgs+=(
      --prefix LD_LIBRARY_PATH : ${
        lib.makeLibraryPath [
          icu
          geoclue
          webkitgtk
        ]
      }
      --prefix XDG_DATA_DIRS : "${gtk3}/share/gsettings-schemas/${gtk3.name}"
      --prefix GI_TYPELIB_PATH : "${
        lib.makeSearchPath "lib/girepository-1.0" [
          gtk3
          webkitgtk
        ]
      }"
        )
  '';

  meta = with lib; {
    homepage = "https://github.com/DanWBR/dwsim";
    licence = licenses.gpl3;
    plataforms = [ "x86_64-linux" ];
    maintainers = [ maintainers.felipepinto ];
    description = "an open-source CAPE-OPEN compliant Chemical Process Simulator";
    longdescription = ''
      Built on the .NET and Mono frameworks, it features a user-friendly graphical interface and robust tools for steady-state simulations, including vapor-liquid, solid-liquid, and electrolyte equilibrium processes. Its extensive capabilities include thermodynamic models like Peng-Robinson, UNIFAC, and IAPWS-IF97; unit operations such as reactors, distillation columns, and heat exchangers; and utilities for regression, phase envelopes, and petroleum characterization. DWSIM also supports optimization, sensitivity analysis, Python scripting, and CAPE-OPEN plugins
    '';
  };
}
