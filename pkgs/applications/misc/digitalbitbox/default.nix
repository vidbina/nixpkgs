{
  autoconf,
  automake,
  buildFHSUserEnv,
  curl,
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
  reqPkgs = [
    curl
    libevent
    libtool
    libudev
    libusb
    libqrencode
    pkgconfig
    qt56.full
  ];
  fhsEnv = buildFHSUserEnv {
    name = "dbb-fhs";
    targetPkgs = pkgs: reqPkgs;
  };
in
 stdenv.mkDerivation rec {
  name = "dbb-app";

  src = fetchFromGitHub {
    owner = "digitalbitbox";
    repo = "dbb-app";
    rev = "v${version}";
    sha256 = "1r77fvqrlaryzij5dfbnigzhvg1d12g96qb2gp8dy3xph1j0k3s1";
  };

  version = "2.2.2";

  buildInputs = reqPkgs ++ gccPkgs ++ utilPkgs;

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

  configurePhase = ''
    ./autogen.sh
    ./configure --prefix=$out --enable-debug --enable-libusb $configureFlags
  '';

  hardeningDisable = [
    "all"
  ];

  installPhase = ''
    make install
    mkdir -p $out/bin $out/lib
    cp src/libbtc/.libs/*.so* $out/lib
    cp src/libbtc/src/secp256k1/.libs/*.so* $out/lib
    cp src/hidapi/libusb/.libs/*.so* $out/lib
    cp src/univalue/.libs/*.so* $out/lib
    rm -rf $PWD
  '';

  postInstall = ''
    wrapProgram "$out/bin/dbb-cli" --prefix LD_LIBRARY_PATH : "$out/lib"
    wrapProgram "$out/bin/dbb-app" --prefix LD_LIBRARY_PATH : "$out/lib"
  '';
}
