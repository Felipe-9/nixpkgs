{
  lib,
  stdenv,
  fetchFromSourcehut,
  SDL2,
  unstableGitUpdater,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "uxn";
  version = "1.0-unstable-2025-05-17";

  src = fetchFromSourcehut {
    owner = "~rabbits";
    repo = "uxn";
    rev = "d609a6eed101d0e69eb9a5516b59cd6b1d31740e";
    hash = "sha256-0uLMqd/WBDqJgP08qqlmsi+RksSn3Hz0Gz7steqScnA=";
  };

  outputs = [
    "out"
    "projects"
  ];

  nativeBuildInputs = [
    SDL2
  ];

  buildInputs = [
    SDL2
  ];

  strictDeps = true;

  postPatch = ''
    patchShebangs build.sh
    substituteInPlace build.sh \
      --replace "-L/usr/local/lib " "" \
      --replace "$(brew --prefix)/lib/libSDL2.a " "" \
      --replace "--static-libs" "--libs" \
      --replace " | sed -e 's/-lSDL2 //'" ""
  '';

  buildPhase = ''
    runHook preBuild

    ./build.sh --no-run

    runHook postBuild
  '';

  # ./build.sh --install is meant to install in $HOME, therefore not useful for
  # package maintainers
  installPhase = ''
    runHook preInstall

    install -d $out/bin/
    cp bin/uxnasm bin/uxncli bin/uxnemu $out/bin/
    install -d $projects/share/uxn/
    cp -r projects $projects/share/uxn/

    runHook postInstall
  '';

  passthru.updateScript = unstableGitUpdater { };

  meta = {
    homepage = "https://wiki.xxiivv.com/site/uxn.html";
    description = "Assembler and emulator for the Uxn stack machine";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ];
    mainProgram = "uxnemu";
    inherit (SDL2.meta) platforms;
  };
})
