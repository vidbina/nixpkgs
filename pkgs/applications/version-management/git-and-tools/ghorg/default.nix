{ stdenv, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "ghorg";
  version = "1.4.0";

  src = fetchFromGitHub {
    owner = "gabrie30";
    repo = "ghorg";
    rev = "${version}";
    sha256 = "0diwndkckv6fga45j9zngizycn5m71r67cziv0zrx6c66ssbj49w";
  };

  deleteVendor = true;
  vendorSha256 = sha256:158r3mg69ag2yj1j1wdycz1wlilpi3s639b5xk3ak1gd1sij8vqy;

  subPackages = [ "." ];

  modSha256 = sha256:1lywbq8d4rrmzynh3dmncsy9hk0dxj157vj89fl2vl7vsmwwngp2;

  preBuild = ''
    export HOME=$TMPDIR
    mkdir -p $HOME/.config/ghorg
    cp sample-conf.yaml $HOME/.config/ghorg/conf.yaml
  '';

  buildFlagsArray = [ "-ldflags=-s -w -X main.version=${version}" ];

  meta = with stdenv.lib; {
    description = "ghorg allows you to quickly clone all of an orgs, or users repos into a single directory";
    homepage = https://github.com/gabrie30/ghorg;
    license = licenses.asl20;
    maintainers = with maintainers; [ vidbina ];
    platforms = platforms.all;
  };
}
