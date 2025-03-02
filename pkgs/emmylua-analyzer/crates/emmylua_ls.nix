version:
{
  stdenv,
  pkg-config,
  rustPlatform,
  fetchFromGitHub,
  lib,
}:
rustPlatform.buildRustPackage rec {
  pname = "emmylua_ls";
  inherit version;

  src = fetchFromGitHub {
    owner = "CppCXY";
    repo = "emmylua-analyzer-rust";
    rev = version;
    hash = lib.fakeHash;
  };

  cargoHash = lib.fakeHash;

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ stdenv.cc.cc.lib ];

  buildAndTestSubdir = "crates/${pname}";

  postFixup = ''
    patchelf --set-rpath "${stdenv.cc.cc.lib}/lib" $out/bin/${pname}
  '';
}
