#
# NOTE: Does not evaluate:
#
#
# ERROR Backend subprocess exited when trying to invoke get_requires_for_build_wheel
# error: builder for '/nix/store/0qzyaw1zn83mf0wh9ab8zcil92jg671l-python3.11-edk2-basetools-0.1.49.drv' failed with exit code 1;
#        last 10 log lines:
#        >     result = func(*args)
#        >              ^^^^^^^^^^^
#        >   File "/nix/store/mh6gqjf1w1i6ln1a61psnz0gzdmwrspl-python3-3.11.8/lib/python3.11/urllib/request.py", line 1391, in https_open
#        >     return self.do_open(http.client.HTTPSConnection, req,
#        >            ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
#        >   File "/nix/store/mh6gqjf1w1i6ln1a61psnz0gzdmwrspl-python3-3.11.8/lib/python3.11/urllib/request.py", line 1351, in do_open
#        >     raise URLError(err)
#        > urllib.error.URLError: <urlopen error [Errno -3] Temporary failure in name resolution>
#        >
#        > ERROR Backend subprocess exited when trying to invoke get_requires_for_build_wheel
#        For full logs, run 'nix log /nix/store/0qzyaw1zn83mf0wh9ab8zcil92jg671l-python3.11-edk2-basetools-0.1.49.drv'.
# error: 1 dependencies of derivation '/nix/store/8d3n9q6hrxhnazwz3kx2jpd4yqri041l-python3-3.11.8-env.drv' failed to build

{
  lib,
  buildPythonPackage,
  pythonOlder,
  fetchFromGitHub,
  setuptools,
  setuptools-scm,
  edk2-pytool-library,
  antlr4-python3-runtime,
  fetchPypi
}:

buildPythonPackage rec {
  pname = "edk2-basetools";
  version = "0.1.49";
  pyproject = true;
  doCheck = false;

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-RmOcS9BYmqzZlI3ld7riQ5EWywVJx9iTxEtRs56P+L8=";
  };

  # src = fetchFromGitHub {
  #   owner = "tianocore";
  #   repo = "edk2-basetools";
  #   rev = "refs/tags/v${version}";
  #   hash = "sha256-mQzqNHF0uUAW/ROg1YsbEjNiTGh3tUQbs030y//PlHA=";
  # };

  buildInputs = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    edk2-pytool-library
    antlr4-python3-runtime
  ];
}

