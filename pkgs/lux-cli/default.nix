{
  stdenv,
  pkg-config,
  rustPlatform,
  fetchFromGitHub,
  lib,
}:
rustPlatform.buildRustPackage (self: {
  pname = "lux-cli";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "CppCXY";
    repo = "emmylua-analyzer-rust";
    tag = "v${self.version}";
    hash = lib.fakeHash;
  };
  useFetchCargoVendor = true;
  cargoHash = lib.fakeHash;
})
