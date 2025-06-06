{
  lib,
  fetchFromGitHub,
  python3,
  sqlite,
  which,
  nix-update-script,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "s3ql";
  version = "5.2.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "s3ql";
    repo = "s3ql";
    tag = "s3ql-${version}";
    hash = "sha256-hNqKLpJd0vj96Jx4YnqYsPLq/iTbvmtvjyLrYozaxpk=";
  };

  build-system = with python3.pkgs; [ setuptools ];

  nativeBuildInputs = [ which ] ++ (with python3.pkgs; [ cython ]);

  propagatedBuildInputs = with python3.pkgs; [
    apsw
    cryptography
    defusedxml
    google-auth
    google-auth-oauthlib
    pyfuse3
    requests
    sqlite
    trio
  ];

  nativeCheckInputs = with python3.pkgs; [
    pytest-trio
    pytestCheckHook
  ];

  preBuild = ''
    ${python3.pkgs.python.pythonOnBuildForHost.interpreter} ./setup.py build_cython build_ext --inplace
  '';

  preCheck = ''
    export HOME=$(mktemp -d)
  '';

  pythonImportsCheck = [ "s3ql" ];

  pytestFlagsArray = [ "tests/" ];

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version-regex"
      "s3ql-([0-9.]+)"
    ];
  };

  meta = {
    description = "Full-featured file system for online data storage";
    homepage = "https://github.com/s3ql/s3ql/";
    changelog = "https://github.com/s3ql/s3ql/releases/tag/s3ql-${version}";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ rushmorem ];
    platforms = lib.platforms.linux;
  };
}
