with import <nixpkgs> { };
{
  lib,
  buildDotnetModule,
  dotnetCorePackages,
  fetchFromGitHub,

# ipopt,
# mono,
# gtk3,
# nuget,
}:
let
  pname = "dwsim";
in
buildDotnetModule {
  inherit pname;
  version = "9.0.2";

  meta = {
    description = "an open-source CAPE-OPEN compliant Chemical Process Simulator";
    mainProgram = pname;
    homepage = "https://github.com/DanWBR/dwsim";
    license = lib.licenses.gpl3;
    sourceProvenance = [ lib.sourceTypes.fromSource ];
    maintainers = [ lib.maintainers.felipe-9 ];
    platforms = lib.platforms.linux;
  };

  src = fetchFromGitHub {
    owner = "DanWBR";
    repo = pname;
    tag = "v${version}";
    sha256 = "sha256-WVe8cVJXYl1cyH4tbs0eWumvOwqgJA+fXQphn0LUsXk=";
  };

  buildInputs = [
    ipopt
    mono
    gtk3
    nuget
  ];

  projectFile = "DWSIM.sln";

  nugetDeps = ./deps.json;
  # packNupkg = true;

  dotnet-sdk = dotnetCorePackages.sdk_9_0;
  dotnet-runtime = dotnetCorePackages.runtime_9_0;

  executables = [ "DWSIM.exe" ];

  runtimeDeps = [
    ipopt
    mono
    gtk3
    nuget
  ];

  testProjectFile = [
    "DWSIM.Automation.Tests.CSharp/DWSIM.Automation.Tests.CSharp.csproj"
    "DWSIM.Tests/DWSIM.Tests.csproj"
  ];

  nativeCheckInputs = [ mono ];
}
