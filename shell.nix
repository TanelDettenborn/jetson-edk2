# shell.nix
{
  nixpkgs ? fetchTarball "https://github.com/NixOS/nixpkgs/archive/a6292e34000dc93d43bccf78338770c1c5ec8a99.tar.gz",
}:
let
  pkgs = import nixpkgs { crossSystem.config = "aarch64-linux-gnu"; };
  buildPackages = pkgs.buildPackages;
  python = buildPackages.python3.withPackages (ps: [
    ps.edk2-pytool-library
    (ps.callPackage ./edk2-pytool-extensions.nix { })
    # NOTE: Error inside basetool.nix file!
    #(ps.callPackage ./edk2-basetools.nix { })
    # python-pkgs.edk2-basetools
    ps.regex
    ps.kconfiglib
  ]);
in
pkgs.mkShell {
  depsBuildBuild = [

  ];
  NUGET_PATH = pkgs.lib.getExe buildPackages.nuget;
  nativeBuildInputs = [
    buildPackages.libuuid
    buildPackages.dtc
    buildPackages.acpica-tools
    python
    # FIXME: needs cross fix
    #pkgs.buildPackages.lcov
  ];
}
