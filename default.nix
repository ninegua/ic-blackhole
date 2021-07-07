{ pkgs ? import <nixpkgs> { } }:
let
  ic-utils = import (builtins.fetchGit {
    url = "http://github.com/ninegua/ic-utils";
    rev = "56d404d73dd5253372a1d50997df51e2ddc4d6fb";
  }) { inherit pkgs; };
  motoko-base = builtins.fetchGit {
    url = "https://github.com/dfinity/motoko-base";
    rev = "927119e172964f4038ebc7018f9cc1b688544bfa";
  };
in pkgs.stdenv.mkDerivation {
  name = "ic-blackhole";
  version = "0.0.0";
  phases = [ "buildPhase" "installPhase" ];
  src = ./.;
  nativeBuildInputs = [ pkgs.binaryen ];
  buildPhase = ''
    export PATH=${ic-utils}/bin:$PATH
    cp -r $src/* .
    make MOC_OPT='--package base ${motoko-base}/src/' UTIL_DIR='${ic-utils}'
  '';
  installPhase = "mkdir -p $out/bin && install -m 644 dist/* $out/bin/";
}
