inputs:

final: prev:

{
  inherit (inputs) pandoc-templates;

  pygments = prev.python3Packages.pygments.overrideAttrs (oldAttrs: {
    postPatch = ''
      cp ${inputs.draculaTheme}/dracula.py pygments/styles/
      sed -i 's/bg:.\+ //' pygments/styles/inkpot.py
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
