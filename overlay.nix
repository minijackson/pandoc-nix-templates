inputs:

final: prev:

{
  inherit (inputs) pandoc-templates;

  pygments = prev.python3Packages.pygments.overrideAttrs (oldAttrs: {
    # TODO: disable italic for non-normal comments for Perldoc style
    postPatch = ''
      cp ${inputs.draculaTheme}/dracula.py pygments/styles/
      sed -i \
        -e 's/bg:.\+ //' \
        -e 's/000080/808bed/' \
        -e 's/800080/ff8bff/' \
        -e 's/A00000/ce4e4e/' \
        -e 's/ff0000/ce4e4e/' \
        -e 's/ffff00/ffcd00/' \
        -e 's/008400/8fff8b/' \
        pygments/styles/inkpot.py

      sed -i \
        -e 's/bg:.\+ //' \
        -e 's/#228B22/italic #228B22/' \
        pygments/styles/perldoc.py
    '';
  });

  texlive = (prev.texlive or { }) // {
    beamertheme-metropolis =
      let
        date = builtins.substring 0 8 inputs.beamertheme-metropolis.lastModifiedDate;
        shortRev = inputs.beamertheme-metropolis.shortRev or "dirty";

        pkg = final.stdenvNoCC.mkDerivation {
          pname = "texlive-beamertheme-metropolis";
          version = "${date}-${shortRev}";

          src = inputs.beamertheme-metropolis;

          outputs = [ "out" "doc" ];

          nativeBuildInputs = [
            (final.texlive.combine {
              inherit (final.texlive)
                scheme-small
                enumitem
                fileinfo
                latexmk;
            })
          ];

          passthru = {
            pname = "beamertheme-metropolis";
            tlType = "run";
          };

          DESTDIR = placeholder "out";

          dontConfigure = true;
        };
      in
      { pkgs = [ pkg ]; };
  };

  mkPandocPdf = final.callPackage ./latex.nix { };
  mkPandocBeamerPdf = final.callPackage ./latex.nix { documentType = "beamer"; };
}
