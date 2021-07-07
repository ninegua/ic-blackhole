{ pkgs ? import <nixpkgs> { } }:
let
  ic-utils = import (builtins.fetchGit {
    url = "http://github.com/ninegua/ic-utils";
    rev = "d2f1ff5787113febc289c3dda2dcdece4fead12d";
  }) { inherit pkgs; };
  # ic-utils = import ../ic-utils { inherit pkgs; };
  motoko-base = builtins.fetchGit {
    url = "https://github.com/dfinity/motoko-base";
    rev = "927119e172964f4038ebc7018f9cc1b688544bfa";
  };
in with pkgs;
pkgs.stdenv.mkDerivation {
  name = "ic-blackhole";
  version = "0.0.0";
  src = ./.;
  nativeBuildInputs = [ ic-utils binaryen jq xxd protobuf ];
  MOC_OPT="--package base ${motoko-base}/src/";
  UTIL_DIR="${ic-utils}";
  installPhase = "mkdir -p $out/bin && install -m 644 dist/* $out/bin/";
}
