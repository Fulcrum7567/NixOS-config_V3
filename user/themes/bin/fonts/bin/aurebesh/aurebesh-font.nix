{ stdenv }:

stdenv.mkDerivation rec {
  pname = "aurebesh-font";
  version = "1.0";

  # The source is the local font file.
  src = ./AurebeshAF-Canon.otf;

  # This is the crucial fix:
  # Since the source is a single file and not an archive,
  # we tell stdenv not to try and unpack it.
  dontUnpack = true;

  installPhase = ''
    # Create the destination directory for OpenType fonts
    mkdir -p $out/share/fonts/opentype
    # Copy the source file into the destination directory
    cp $src $out/share/fonts/opentype/AurebeshAF-Canon.otf
  '';

  meta = {
    description = "Aurebesh font";
    # You can add other metadata here, like license, homepage, etc.
  };
}
