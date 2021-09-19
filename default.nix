{ pkgs ? import (
    builtins.fetchTarball {
      # nixpkgs pin @ NixOS 21.05
      url = "https://github.com/NixOS/nixpkgs/archive/d4590d21006387dcb190c516724cb1e41c0f8fdf.tar.gz";
      sha256 = "17q39hlx1x87xf2rdygyimj8whdbx33nzszf4rxkc6b85wz0l38n";
    }
  ) {}
}:

let
  # sfArkLib library build
  sfArkLib =
    pkgs.stdenv.mkDerivation {
      name = "sfArkLib";
      src = fetchTarball {
        url = "https://github.com/raboof/sfArkLib/archive/master.tar.gz";
        # Uses the most recent commit from master!
        # Specify sha1 in "rev" attribute for exact commit
        # rev = "ffffffffffffffffffffffffffffffffffffffff";
      };

      buildInputs = [ pkgs.zlib ];

      installFlags = [ "PREFIX=$(out)" ];

      meta = {
        description = "Library for decompressing sfArk soundfonts";
        platforms = pkgs.lib.platforms.linux;
      };
    };
in
pkgs.stdenv.mkDerivation {
  name = "sfArkXTm";
  src = builtins.filterSource (
    path: type: baseNameOf path != ".git" && type != "symlink"
  ) ./.;

  buildInputs = [ pkgs.zlib sfArkLib ];

  installFlags = [ "PREFIX=$(out)" ];

  meta = {
    description = "sfArk extractor, console version";
    platforms = pkgs.lib.platforms.linux;
  };
}
