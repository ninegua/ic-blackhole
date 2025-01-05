{ pkgs ? import <nixpkgs> { } }:
with pkgs;
let
  download = { name, version, url, sha256, taropt ? "" }:
    stdenv.mkDerivation ({
      inherit name version;
      phases = [ "installPhase" ];
      installPhase = ''
        mkdir -p $out/bin
        tar zxvf $src ${taropt} -C $out/bin 2> /dev/null || install -m 755 $src $out/bin/${name}
      '';
      src = fetchurl { inherit url sha256; };
    });
  motoko = download (rec {
    name = "motoko";
    version = "0.6.4";
    url =
      "https://github.com/dfinity/motoko/releases/download/${version}/motoko-linux64-${version}.tar.gz";
    sha256 = "sha256-ntPzPyLZwrLZk/4JQL6vAvtGhu3/Z2nrgipq8zfCPSg=";
  });
  binaryen = download (rec {
    taropt = "--strip-component=1";
    name = "binaryen";
    version = "version_96";
    url =
      "https://github.com/WebAssembly/binaryen/releases/download/${version}/binaryen-${version}-x86_64-linux.tar.gz";
    sha256 = "sha256-n4OXoSkx31d7JEonwpPXyXa8fpgKEkV4OfRvggKTWqw=";
  });
in with pkgs;
pkgs.stdenv.mkDerivation {
  name = "ic-blackhole";
  version = "0.0.0";
  src = ./.;
  nativeBuildInputs = [ binaryen motoko jq gnumake ];
  installPhase = "mkdir -p $out/bin && install -m 644 dist/* $out/bin/";
}
