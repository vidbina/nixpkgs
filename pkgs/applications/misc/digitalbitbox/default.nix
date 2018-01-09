{
  autoconf,
  automake,
  buildFHSUserEnv,
  curl,
  withGui ? true,
  fetchFromGitHub,
  gcc49,
  git,
  libevent,
  libtool,
  libudev,
  libusb,
  libqrencode,
  makeWrapper,
  pkgconfig,
  qt56,
  stdenv,
  tree,
  writeScriptBin
}:

let
  fhsEnv = buildFHSUserEnv { name = "dbb-fhs"; };
  base = stdenv.mkDerivation rec {
    name = "dbb-app";

    src = fetchFromGitHub {
      owner = "digitalbitbox";
      repo = "dbb-app";
      rev = "v${version}";
      sha256 = "1r77fvqrlaryzij5dfbnigzhvg1d12g96qb2gp8dy3xph1j0k3s1";
    };

    version = "2.2.2";

    #nativeBuildInputs = gccPkgs;

    buildInputs = [
      curl
      libevent
      libtool
      libudev
      libusb
      libqrencode
      pkgconfig
    ] ++ gccPkgs ++ utilPkgs ++ qtPkgs;

    qtPkgs = [
      qt56.full
    ];

    gccPkgs = [
      autoconf
      automake
      gcc49
      #makeWrapper
    ];

    utilPkgs = [
      #file
      git
      #less
      #strace
      tree
      #which
    ];

    QTDIR="${qt56.qtbase.dev}";

    MOC="${qt56.qtbase.dev}/bin/moc";
    UIC="${qt56.qtbase.dev}/bin/uic";
    RCC="${qt56.qtbase.dev}/bin/rcc";
    LRELEASE="${qt56.qttools.dev}/bin/lrelease";
    LUPDATE="${qt56.qttools.dev}/bin/lupdate";

    preConfigure = "./autogen.sh";

    configureFlags = [
      "--enable-debug"
      "--enable-libusb"
      "--with-qt-bindir=${qt56.qtbase.dev}/bin:${qt56.qttools.dev}/bin"
      #"--prefix=`realpath out`/tmp"
    ];

    hardeningDisable = [
      "all"
      #"format"
    ];

  #  writeTextFile {
  #    name = "dbb-cli";
  #    destination = "/bin/dbb-cli";
  #    executable = true;
  #    text = ''
  #    '';
  #  };

  #app = mkBinary;

    installPhase = ''
      mkdir -p $out/bin $out/lib $out/obj $out/tmp
      echo "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"
      cp -r . $out/tmp
      cp -r src/dbb-* $out/bin
      rm -rf $PWD
    '';

    postInstall = ''
      wrapProgram "$out/bin/dbb-cli" --prefix PATH : "$out/tmp"
      wrapProgram "$out/bin/dbb-app" --prefix PATH : "$out/tmp"
    '';
  };
in writeScriptBin "dbb-cli" ''
  #!${stdenv.shell}
  ${fhsEnv}/bin/dbb-fhs ${base}/bin/dbb-cli
''
