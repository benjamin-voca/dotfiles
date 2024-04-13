{ lib,pkgs, stdenv, rustPlatform, pkg-config, openssl, gcc, zlib, sqlite }: 

rustPlatform.buildRustPackage rec {
  pname = "pray-rs";
  version = "1.0.0";

  src = ./.;

  cargoSha256="tlvXsABJy/6mCUvCKHwtwoSWvUOh6HwPTf6AND+XGh8=";

  OPENSSL_STATIC = "1";
  OPENSSL_LIB_DIR = "${pkgs.pkgsStatic.openssl.out}/lib";
  OPENSSL_INCLUDE_DIR = "${pkgs.pkgsStatic.openssl.dev}/include";

  buildInputs = [
    pkg-config openssl gcc zlib sqlite
# Add any other build dependencies here
  ];

  cargoBuildFlags = [ "--release" ];

  meta = with lib; {
    description = "Prayer Times Daemon";
    license = licenses.unlicense;
    mainProgram = "pray-rs";
  };
}
