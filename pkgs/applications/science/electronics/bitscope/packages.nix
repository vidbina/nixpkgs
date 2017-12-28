{ stdenv, callPackage, fetchurl, buildFHSUserEnv, makeWrapper, pkgs }:

let
  wrapBinary = libPaths: binaryName: ''
    wrapProgram "$out/bin/${binaryName}" \
      --prefix LD_LIBRARY_PATH : "${stdenv.lib.makeLibraryPath libPaths}"
  '';
  mkBitscope = callPackage (import ./common.nix) { };
in {
  chart = let
    name = "${toolName}_${version}";
    toolName = "bitscope-chart";
    version = "2.0.FK22M";
  in mkBitscope {
    inherit name toolName version;

    meta = {
      description = "Multi-channel waveform data acquisition and chart recording application";
      homepage = "http://bitscope.com/software/chart/";
    };

    src = if stdenv.system == "x86_64-linux" then fetchurl {
      url = "http://bitscope.com/download/files/${name}_amd64.deb";
      sha256 = "08mc82pjamyyyhh15sagsv0sc7yx5v5n54bg60fpj7v41wdwrzxw";
    } else if stdenv.system == "i686-linux" then fetchurl {
      url = "http://bitscope.com/download/files/${name}_i386.deb";
      sha256 = "08p6psh8g6pjp9gpdksb8y6nn9n4hv1j450v1nfhy25h2n8j0f03";
    } else throw "no install instructions for ${stdenv.system}";
  };

  console = let
    name = "${toolName}_${version}";
    toolName = "bitscope-console";
    version = "1.0.FK29A";
  in mkBitscope {
    # NOTE: this is meant as a demo by BitScope
    inherit name toolName version;

    meta = {
      description = "Demonstrative communications program designed to make it easy to talk to any model BitScope";
    };

    src = if stdenv.system == "x86_64-linux" then fetchurl {
      url = "http://bitscope.com/download/files/${name}_amd64.deb";
      sha256 = "00b4gxwz7w6pmfrcz14326b24kl44hp0gzzqcqxwi5vws3f0y49d";
    } else if stdenv.system == "i686-linux" then fetchurl {
      url = "http://bitscope.com/download/files/${name}_i386.deb";
      sha256 = "0llcvbgmwhl3dybv1c4sxxsgc4xl21rxk6bdva5a11w4w9sx6c7s";
    } else throw "no install instructions for ${stdenv.system}";
  };

  display = let
    name = "${toolName}_${version}";
    toolName = "bitscope-display";
    version = "1.0.EC17A";
  in mkBitscope {
    inherit name toolName version;

    meta = {
      description = "Display diagnostic application for BitScope";
      homepage = "http://bitscope.com/software/display/";
    };

    src = if stdenv.system == "x86_64-linux" then fetchurl {
      url = "http://bitscope.com/download/files/${name}_amd64.deb";
      sha256 = "05xr5mnka1v3ibcasg74kmj6nlv1nmn3lca1wv77whkq85cmz0s1";
    } else if stdenv.system == "i686-linux" then fetchurl {
      url = "http://bitscope.com/download/files/${name}_i386.deb";
      sha256 = "13csap7gmc1q19rd6qhd0z64bqafk03zfalnsrz2gxa2db5m5wlk";
    } else throw "no install instructions for ${stdenv.system}";
  };

  dso = let
    name = "${toolName}_${version}";
    toolName = "bitscope-dso";
    version = "2.8.FE22H";
  in mkBitscope {
    inherit name toolName version;

    meta = {
      description = "Test and measurement software for BitScope";
      homepage = "http://bitscope.com/software/dso/";
    };

    src = if stdenv.system == "x86_64-linux" then fetchurl {
      url = "http://bitscope.com/download/files/${name}_amd64.deb";
      sha256 = "0fc6crfkprj78dxxhvhbn1dx1db5chm0cpwlqpqv8sz6whp12mcj";
    } else if stdenv.system == "i686-linux" then fetchurl {
      url = "http://bitscope.com/download/files/${name}_i386.deb";
      sha256 = "0d338g21rzknwgn5wannvkyy9aq37vlfqkppgjv3bkjqkxcyvv7a";
    } else throw "no install instructions for ${stdenv.system}";
  };

  logic = let
    name = "${toolName}_${version}";
    toolName = "bitscope-logic";
    version = "1.2.FC20C";
  in mkBitscope {
    inherit name toolName version;

    meta = {
      description = "Mixed signal logic timing and serial protocol analysis software for BitScope";
      home = "http://bitscope.com/software/logic/";
    };

    src = if stdenv.system == "x86_64-linux" then fetchurl {
      url = "http://bitscope.com/download/files/${name}_amd64.deb";
      sha256 = "0lkb7z9gfkiyxdwh4dq1zxfls8gzdw0na1vrrbgnxfg3klv4xns3";
    } else if stdenv.system == "i686-linux" then fetchurl {
      url = "http://bitscope.com/download/files/${name}_i386.deb";
      sha256 = "092mn88rayfmih4lfhm1skdj8dz1nkcqi55r06lciawqjjjp0ip6";
    } else throw "no install instructions for ${stdenv.system}";
  };

  meter = let
    name = "${toolName}_${version}";
    toolName = "bitscope-meter";
    version = "2.0.FK22G";
  in mkBitscope {
    inherit name toolName version;

    meta = {
      description = "Automated oscilloscope, voltmeter and frequency meter for BitScope";
      homepage = "http://bitscope.com/software/logic/";
    };

    src = if stdenv.system == "x86_64-linux" then fetchurl {
      url = "http://bitscope.com/download/files/${name}_amd64.deb";
      sha256 = "0nirbci6ymhk4h4bck2s4wbsl5r9yndk2jvvv72zwkg21248mnbp";
    } else if stdenv.system == "i686-linux" then fetchurl {
      url = "http://bitscope.com/download/files/${name}_i386.deb";
      sha256 = "0y9s7p36v7agqhi076711ds22nfxqmfgq13r01m57lpn9xfz5fja";
    } else throw "no install instructions for ${stdenv.system}";
  };

  proto = let
    name = "${toolName}_${version}";
    toolName = "bitscope-proto";
    version = "0.9.FG13B";
  in mkBitscope rec {
    inherit name toolName version;
    # NOTE: this is meant as a demo by BitScope
    # NOTE: clicking on logo produces error
    # TApplication.HandleException Executable not found: "http://bitscope.com/blog/DK/?p=DK15A"

    meta = {
      description = "Demonstrative prototype oscilloscope built using the BitScope Library";
      homepage = "http://bitscope.com/blog/DK/?p=DK15A";
    };

    src = if stdenv.system == "x86_64-linux" then fetchurl {
      url = "http://bitscope.com/download/files/${name}_amd64.deb";
      sha256 = "1ybjfbh3narn29ll4nci4b7rnxy0hj3wdfm4v8c6pjr8pfvv9spy";
    } else if stdenv.system == "i686-linux" then fetchurl {
      url = "http://bitscope.com/download/files/${name}_i386.deb";
      sha256 = "13v4r4x3h65ya5lxi5qgim62z7l7qjvyc53hzvkjzhzvd1ab5xzl";
    } else throw "no install instructions for ${stdenv.system}";
  };

  server = let
    name = "${toolName}_${version}";
    toolName = "bitscope-server";
    version = "1.0.FK26A";
  in mkBitscope {
    inherit name toolName version;

    meta = {
      description = "Remote access server solution for any BitScope";
      homepage = "http://bitscope.com/software/server/";
    };

    src = if stdenv.system == "x86_64-linux" then fetchurl {
      url = "http://bitscope.com/download/files/${name}_amd64.deb";
      sha256 = "1079n7msq6ks0n4aasx40rd4q99w8j9hcsaci71nd2im2jvjpw9a";
    } else if stdenv.system == "i686-linux" then fetchurl {
      url = "http://bitscope.com/download/files/${name}_i386.deb";
      sha256 = "0kpxmx0gc83gwk2v8yqyinhc0wndlq33mb9snbmmq3yfiz4qxhq0";
    } else throw "no install instructions for ${stdenv.system}";
  };
}
