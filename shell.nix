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

  targetArch =
    if pkgs.stdenv.isi686 then
      "IA32"
    else if pkgs.stdenv.isx86_64 then
      "X64"
    else if pkgs.stdenv.isAarch32 then
      "ARM"
    else if pkgs.stdenv.isAarch64 then
      "AARCH64"
    else if pkgs.stdenv.hostPlatform.isRiscV64 then
      "RISCV64"
    else
      throw "Unsupported architecture";
in
pkgs.mkShell rec {
  depsBuildBuild = [
    buildPackages.stdenv.cc
    buildPackages.bash
  ];
  depsHostHost = [ pkgs.libuuid ];
  strictDeps = true;
  NUGET_PATH = pkgs.lib.getExe buildPackages.nuget;
  nativeBuildInputs = [
    buildPackages.libuuid
    buildPackages.dtc
    buildPackages.acpica-tools
    buildPackages.gnat
    python
    # FIXME: needs cross fix
    #pkgs.buildPackages.lcov
  ];
}
