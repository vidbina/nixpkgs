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
  pkgconfig,
  qt56,
  stdenv,
  tree
}:

stdenv.mkDerivation rec {
  name = "dbb-app";

  src = fetchFromGitHub {
    owner = "digitalbitbox";
    repo = "dbb-app";
    rev = "v${version}";
    sha256 = "1r77fvqrlaryzij5dfbnigzhvg1d12g96qb2gp8dy3xph1j0k3s1";
  };

  version = "2.2.2";

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
    #"--with-qt-bindir=${qt56.qtbase.dev}/bin:${qt56.qttools.dev}/bin"
    #"--with-qt-bindir=${QT_BINDDIR}"
  ];

  hardeningDisable = [
    "all"
    #"format"
  ];

  fhsEnv = buildFHSUserEnv {
    inherit name;
  };

  installPhase = ''
    mkdir -p $out/bin
    tree -L 2
    cp src/dbb-* "$out/bin/"
      ${stdenv.lib.optionalString withGui ''
    ''}
  '';
}
