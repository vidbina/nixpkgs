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

  subPackages = [ "." ];

  modSha256 = "1lywbq8d4rrmzynh3dmncsy9hk0dxj157vj89fl2vl7vsmwwngp2";

  buildFlagsArray = [ "-ldflags=-s -w -X main.version=${version}" ];

  meta = with stdenv.lib; {
    description = "ghorg allows you to quickly clone all of an orgs, or users repos into a single directory";
    homepage = https://github.com/gabrie30/ghorg;
    license = licenses.asl20;
    maintainers = with maintainers; [ vidbina ];
    platforms = platforms.all;
  };
}
