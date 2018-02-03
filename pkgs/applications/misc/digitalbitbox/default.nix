{
  stdenv,
  autoreconfHook,
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
}:

let
  gcc = gcc5;
  qt = qt59;
in stdenv.mkDerivation rec {
  name = "dbb-app-${version}";
  version = "2.2.2";

  src = fetchFromGitHub {
    owner = "digitalbitbox";
    repo = "dbb-app";
    rev = "v${version}";
    sha256 = "1r77fvqrlaryzij5dfbnigzhvg1d12g96qb2gp8dy3xph1j0k3s1";
  };

  nativeBuildInputs = with stdenv.lib; [
    autoreconfHook
    curl
    gcc
    git
    makeWrapper
    pkgconfig
  ];

  buildInputs = with stdenv.lib; [
    libevent
    libtool
    libudev
    libusb
    libqrencode
    qt.full
  ];

  LUPDATE="${qt.qttools.dev}/bin/lupdate";
  LRELEASE="${qt.qttools.dev}/bin/lrelease";
  MOC="${qt.qtbase.dev}/bin/moc";
  QTDIR="${qt.qtbase.dev}";
  RCC="${qt.qtbase.dev}/bin/rcc";
  UIC="${qt.qtbase.dev}/bin/uic";

  configureFlags = [
    "--enable-libusb"
  ];

  hardeningDisable = [
    "format"
  ];

  postInstall = ''
    mkdir -p "$out/lib"
    cp src/libbtc/.libs/*.so* $out/lib
    cp src/libbtc/src/secp256k1/.libs/*.so* $out/lib
    cp src/hidapi/libusb/.libs/*.so* $out/lib
    cp src/univalue/.libs/*.so* $out/lib

    # [RPATH][patchelf] Avoid forbidden reference error
    rm -rf $PWD

    wrapProgram "$out/bin/dbb-cli" --prefix LD_LIBRARY_PATH : "$out/lib"
    wrapProgram "$out/bin/dbb-app" --prefix LD_LIBRARY_PATH : "$out/lib"

    # Provide udev rules as documented in https://digitalbitbox.com/start_linux
    mkdir -p "$out/etc/udev/rules.d"

    printf "SUBSYSTEM==\"usb\", TAG+=\"uaccess\", TAG+=\"udev-acl\", SYMLINK+=\"dbb%%n\", ATTRS{idVendor}==\"03eb\", ATTRS{idProduct}==\"2402\"\n" | tee $out/etc/udev/rules.d/51-hid-digitalbitbox.rules > /dev/null && printf "KERNEL==\"hidraw*\", SUBSYSTEM==\"hidraw\", ATTRS{idVendor}==\"03eb\", ATTRS{idProduct}==\"2402\", TAG+=\"uaccess\", TAG+=\"udev-acl\", SYMLINK+=\"dbbf%%n\"\n" | tee $out/etc/udev/rules.d/52-hid-digitalbitbox.rules > /dev/null
  '';

  meta = with stdenv.lib; {
    description = "A QT based application for the Digital Bitbox hardware wallet";
    homepage = "https://digitalbitbox.com/";
    license = licenses.mit;
    maintainers = with maintainers; [
      vidbina
    ];
    platforms = platforms.linux;
  };
}
