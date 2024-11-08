{
  clangStdenv,
  lld,
  fetchFromGitHub,
  lib,
  php,
  ...
}:
let
  stdenv = clangStdenv;
in
stdenv.mkDerivation rec {
  pname = "plutolang";
  version = "0.10.0";

  src = fetchFromGitHub {
    owner = pname;
    repo = "pluto";
    rev = version;
    hash = "sha256-slsW/Kk3e+kdWkoQtQJbPxhznd/m2joWgOO5i1Y4G6E=";
  };

  outputs = [
    "out"
    "dev"
  ];

  nativeBuildInputs = [ php lld ];

  buildInputs = [ stdenv.cc.cc.lib ];

  buildPhase = ''
    runHook preBuild

    export CXX="${stdenv.cc.targetPrefix}c++"

    php scripts/compile.php "$CXX"
    php scripts/link_pluto.php "$CXX"
    php scripts/link_plutoc.php "$CXX"
    php scripts/link_shared.php "$CXX"
    php scripts/link_static.php "$CXX"

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/bin" "$dev/"{lib,include}

    cp src/pluto{,c} "$out/bin"
    cp src/libpluto* "$dev/lib"
    cp src/{lua,lualib,lauxlib}.h src/lua.hpp "$dev/include"

    runHook postInstall
  '';

  meta = with lib; {
    description = "A superset of Lua 5.4 with a focus on general-purpose programming";
    homepage = "https://pluto-lang.org";
    maintainers = [ ];
    platforms = platforms.all;
  };
}
