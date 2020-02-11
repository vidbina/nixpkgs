{
  lib,
  makeRustPlatform,
  fetchFromGitHub,
  python2,
  glib,
  libgit2
}:
  
let
  moz_overlay = import (builtins.fetchTarball https://github.com/mozilla/nixpkgs-mozilla/archive/master.tar.gz);
  nixpkgs = import <nixpkgs> { overlays = [ moz_overlay ]; };
  rustPlatform = let
    target = (nixpkgs.rustChannelOf { channel = "1.40.0"; });
  in makeRustPlatform {
    cargo = target.cargo;
    rustc = target.rust;
  };
in
with nixpkgs;
rustPlatform.buildRustPackage rec {
  pname = "deno";
  version = "0.32.0";

  src = fetchFromGitHub {
    owner = "denoland";
    repo = pname;
    rev = "v${version}";
    sha256 = "1wi1z20i8inc2bi62xbsvwxl0xp4xsqsam3946jvfmis53pmqczr";
  };

  cargoSha256 = "1x0910yf11wfwqi1hshmf9c3z701l7vrnrgi0aw9skzjh9finqim";

  RUST_BACKTRACE = "full";

  buildInputs = [ glib python2 libgit2 ];

  meta = with lib; {
    description = "A secure runtime for JavaScript and TypeScript";
    homepage = "https://github.com/denoland/deno";
    license = licenses.mit;
    platforms = platforms.unix;
    maintainers = with maintainers; [ vidbina ];
  };
}
