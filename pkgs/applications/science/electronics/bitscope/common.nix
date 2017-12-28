{ stdenv, fetchurl, buildFHSUserEnv, makeWrapper, writeScriptBin, pkgs }:

{ name, toolName, version, src, ... } @ attrs:
let
  wrapBinary = libPaths: binaryName: ''
    wrapProgram "$out/bin/${binaryName}" \
      --prefix LD_LIBRARY_PATH : "${stdenv.lib.makeLibraryPath libPaths}"
  '';
  pkg = stdenv.mkDerivation (rec {
    inherit (attrs) name version src;

    meta = with stdenv.lib; {
      homepage = http://bitscope.com/software/;
      license = licenses.unfree;
      platforms = [ "i686-linux" "x86_64-linux" ];
      maintainers = with maintainers; [
      ];
    } // (attrs.meta or {});

    buildInputs = with pkgs; [
      dpkg
      makeWrapper
    ];

    libs = attrs.libs or (with pkgs; [
      atk
      cairo
      gdk_pixbuf
      glib
      gtk2-x11
      pango
      xorg.libX11
    ]);

    dontBuild = true;

    unpackPhase = attrs.unpackPhase or ''
      dpkg-deb -x ${attrs.src} ./
    '';

    installPhase = attrs.installPhase or ''
      mkdir -p "$out/bin"
      cp -a usr/* "$out/"
      ${(wrapBinary libs) attrs.toolName}
    '';
  });
in buildFHSUserEnv {
  name = attrs.toolName;
  meta = pkg.meta;
  runScript = "${pkg.outPath}/bin/${attrs.toolName}";
}
