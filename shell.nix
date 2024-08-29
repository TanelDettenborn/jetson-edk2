# shell.nix

let
  pkgs = import <nixpkgs> {};
  cross = import <nixpkgs> {
    crossSystem = { config = "aarch64-linux-gnu"; };
  };

  python = pkgs.python3.override {
    self = python;
    packageOverrides = pyfinal: pyprev: {
      edk2-pytools-ext = pyfinal.callPackage ./edk2-pytool-extensions.nix { };
      # NOTE: Error inside basetool.nix file!
      # edk2-basetools = pyfinal.callPackage ./edk2-basetools.nix { };
    };
  };

  my-uefi36-3-gcc-tools = pkgs.linkFarm "uefi36-3-gcc-tools" [
    { name = "bin/aarch64-linux-gnu-gcc-ar"; path = "${cross.buildPackages.libgcc}/bin/aarch64-linux-gnu-gcc-ar"; }
    { name = "bin/aarch64-linux-gnu-gcc"; path = "${cross.buildPackages.gcc12}/bin/aarch64-linux-gnu-gcc"; }
    { name = "bin/aarch64-linux-gnu-objcopy"; path = "${cross.buildPackages.gcc12}/bin/aarch64-linux-gnu-objcopy"; }
  ];

in pkgs.mkShell {

  packages = [
    pkgs.nuget
    pkgs.mono
    pkgs.libuuid
    pkgs.gcc12 # TODO: Needed?
    pkgs.dtc
    pkgs.acpica-tools
    pkgs.lcov
    my-uefi36-3-gcc-tools

    (python.withPackages (python-pkgs: [
      python-pkgs.edk2-pytool-library
      python-pkgs.edk2-pytools-ext
      # python-pkgs.edk2-basetools
      python-pkgs.regex
      python-pkgs.kconfiglib
    ]))
  ];
}

