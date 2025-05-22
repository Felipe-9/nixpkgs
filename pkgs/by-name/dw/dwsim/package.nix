with import <nixpkgs> { };
let
  pname = "dwsim";
  version = "9.0.2";
  description = "an open-source CAPE-OPEN compliant Chemical Process Simulator";
in
buildDotnetModule {
  inherit pname version;

  meta = with lib; {
    inherit description;
    mainProgram = pname;
    homepage = "https://github.com/DanWBR/dwsim";
    license = licenses.gpl3;
    sourceProvenance = [ sourceTypes.fromSource ];
    maintainers = with maintainers; [ felipe-9 ];
    platforms = platforms.linux;
  };

  src = fetchFromGitHub {
    owner = "DanWBR";
    repo = "dwsim";
    tag = "v${version}";
    sha256 = "sha256-WVe8cVJXYl1cyH4tbs0eWumvOwqgJA+fXQphn0LUsXk=";
  };

  projectFile = "DWSIM.sln";

  # projectFile = [
  #   "DWSIM.Automation/DWSIM.Automation.csproj"
  #   "DWSIM.Automation.Tests.CSharp/DWSIM.Automation.Tests.CSharp.csproj"
  #   "DWSIM.Controls.DockPanel/WinFormsUI/DWSIM.Controls.DockPanel.ThemeVS2012Light.csproj"
  #   "DWSIM.Controls.DockPanel/WinFormsUI/DWSIM.Controls.DockPanel.csproj"
  #   "DWSIM.Controls.DockPanel/WinFormsUI/DockPanel.ThemeVS2012Light.csproj"
  #   "DWSIM.Controls.DockPanel/WinFormsUI/DockPanel.csproj"
  #   "DWSIM.Controls.DockPanel/WinFormsUI/ThemeVS2003.csproj"
  #   "DWSIM.Controls.IronPythonConsole/DWSIM.Controls.IronPythonConsole.csproj"
  #   "DWSIM.Controls.OutlookGrid/DWSIM.Controls.OutlookGrid.csproj"
  #   "DWSIM.Controls.PythonConsoleControl/DWSIM.Controls.IronPythonConsoleControl.csproj"
  #   "DWSIM.Controls.PythonConsoleControl/PythonConsoleControl.VS08.csproj"
  #   "DWSIM.Controls.TabStrip/DWSIM.Controls.TabStrip.csproj"
  #   "DWSIM.Controls.ZedGraph/DWSIM.Controls.ZedGraph.csproj"
  #   "DWSIM.Controls.ZedGraph/ZedGraph/ZedGraph.csproj"
  #   "DWSIM.DrawingTools.SkiaSharp.Extended/DWSIM.DrawingTools.SkiaSharp.Extended.csproj"
  #   "DWSIM.ExtensionMethods.Eto/DWSIM.ExtensionMethods.Eto.csproj"
  #   "DWSIM.FileStorage/DWSIM.FileStorage.csproj"
  #   "DWSIM.Libraries.OctaveSharp/DWSIM.Libraries.OctaveSharp.csproj"
  #   "DWSIM.Libraries.PythonLink/DWSIM.Libraries.PythonLink.csproj"
  #   "DWSIM.Logging/DWSIM.Logging.csproj"
  #   "DWSIM.Math.DotNumerics/DWSIM.MathOps.DotNumerics.csproj"
  #   "DWSIM.Math.RandomOps/DWSIM.MathOps.RandomOps.csproj"
  #   "DWSIM.Math.SwarmOps/DWSIM.MathOps.SwarmOps.csproj"
  #   "DWSIM.MathOps.Mapack/DWSIM.MathOps.Mapack.csproj"
  #   "DWSIM.MathOps.SimpsonIntegrator/DWSIM.MathOps.SimpsonIntegrator.csproj"
  #   "DWSIM.ProFeatures/DWSIM.ProFeatures.csproj"
  #   "DWSIM.SharedClassesCSharp/DWSIM.SharedClassesCSharp.csproj"
  #   "DWSIM.Simulate365/DWSIM.Simulate365.csproj"
  #   "DWSIM.SkiaSharp.Views.Desktop/DWSIM.SkiaSharp.Views.Desktop.csproj"
  #   "DWSIM.Tests/DWSIM.Tests.csproj"
  #   "DWSIM.Thermodynamics.CoolPropInterface/DWSIM.Thermodynamics.CoolPropInterface.csproj"
  #   "DWSIM.Thermodynamics.ThermoC/DWSIM.Thermodynamics.ThermoC.csproj"
  #   "DWSIM.UI.Desktop/DWSIM.UI.Desktop.csproj"
  #   "DWSIM.UI.Desktop.Editors/DWSIM.UI.Desktop.Editors.csproj"
  #   "DWSIM.UI.Desktop.Forms/DWSIM.UI.Desktop.Forms.csproj"
  #   "DWSIM.UI.Desktop.GTK/DWSIM.UI.Desktop.GTK.csproj"
  #   "DWSIM.UI.Desktop.GTK3/DWSIM.UI.Desktop.GTK3.csproj"
  #   "DWSIM.UI.Desktop.Mac/DWSIM.UI.Desktop.Mac.csproj"
  #   "DWSIM.UI.Desktop.Shared/DWSIM.UI.Desktop.Shared.csproj"
  #   "DWSIM.UI.Desktop.WPF/DWSIM.UI.Desktop.WPF.csproj"
  #   "DWSIM.UI.Desktop.WinForms/DWSIM.UI.Desktop.WinForms.csproj"
  #   "DWSIM.UI.Web/DWSIM.UI.Web.csproj"
  # ];

  nugetDeps = ./deps.json;

  # dotnet-sdk = dotnetCorePackages.dotnet_8.sdk;
  # dotnet-runtime = dotnetCorePackages.dotnet_8.runtime;
  dotnet-sdk = dotnetCorePackages.sdk_9_0-bin;
  # dotnet-sdk = mono;
  dotnet-runtime = dotnetCorePackages.runtime_9_0-bin;

  executables = "DWSIM.exe";

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
