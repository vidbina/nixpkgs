{
  stdenv,
  autoconf,
  automake,
  curl,
  fetchFromGitHub,
  gcc5,
  git,
  libevent,
  libtool,
  libqrencode,
  libudev,
  libusb,
  makeWrapper,
  pkgconfig,
  qt59,
  withDebug ? false
}:

let
  gcc = gcc5;
  qt = qt59;
in stdenv.mkDerivation rec {
  name = "dbb-app-${version}";

  meta = with stdenv.lib; {
    description = "A QT based application for the Digital Bitbox hardware wallet";
    homepage = "https://digitalbitbox.com/";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [
      vidbina
    ];
  };

  src = fetchFromGitHub {
    owner = "digitalbitbox";
    repo = "dbb-app";
    rev = "v${version}";
    sha256 = "1r77fvqrlaryzij5dfbnigzhvg1d12g96qb2gp8dy3xph1j0k3s1";
  };

  version = "2.2.2";

  buildInputs = with stdenv.lib; flatten [
    reqPkgs
    gccPkgs
    utilPkgs
  ];

  reqPkgs = [
    curl
    libevent
    libtool
    libudev
    libusb
    libqrencode
    pkgconfig
    qt.full
  ];

  gccPkgs = [
    autoconf
    automake
    gcc
  ];

  utilPkgs = [
    git
  ];

  QTDIR="${qt.qtbase.dev}";

  MOC="${qt.qtbase.dev}/bin/moc";
  UIC="${qt.qtbase.dev}/bin/uic";
  RCC="${qt.qtbase.dev}/bin/rcc";
  LRELEASE="${qt.qttools.dev}/bin/lrelease";
  LUPDATE="${qt.qttools.dev}/bin/lupdate";

  configurePhase = with stdenv.lib; let
    debugFlag = optionalString withDebug "--enable-debug";
  in ''
    ./autogen.sh
    ./configure --prefix=$out ${debugFlag} --enable-libusb $configureFlags
  '';

  hardeningDisable = [
    "format"
  ];

  installPhase = ''
    make install

    mkdir -p "$out/bin" "$out/lib"
    cp src/libbtc/.libs/*.so* $out/lib
    cp src/libbtc/src/secp256k1/.libs/*.so* $out/lib
    cp src/hidapi/libusb/.libs/*.so* $out/lib
    cp src/univalue/.libs/*.so* $out/lib
    rm -rf $PWD

    mkdir -p "$out/etc/udev/rules.d"
    printf "SUBSYSTEM==\"usb\", TAG+=\"uaccess\", TAG+=\"udev-acl\", SYMLINK+=\"dbb%%n\", ATTRS{idVendor}==\"03eb\", ATTRS{idProduct}==\"2402\"\n" | tee $out/etc/udev/rules.d/51-hid-digitalbitbox.rules > /dev/null && printf "KERNEL==\"hidraw*\", SUBSYSTEM==\"hidraw\", ATTRS{idVendor}==\"03eb\", ATTRS{idProduct}==\"2402\", TAG+=\"uaccess\", TAG+=\"udev-acl\", SYMLINK+=\"dbbf%%n\"\n" | tee $out/etc/udev/rules.d/52-hid-digitalbitbox.rules > /dev/null
  '';

  postInstall = ''
    wrapProgram "$out/bin/dbb-cli" --prefix LD_LIBRARY_PATH : "$out/lib"
    wrapProgram "$out/bin/dbb-app" --prefix LD_LIBRARY_PATH : "$out/lib"
  '';
}
