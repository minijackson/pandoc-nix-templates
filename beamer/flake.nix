{
  description = "My epic presentation";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  inputs.beamertheme-metropolis = {
    url = "github:matze/mtheme";
    flake = false;
  };
  inputs.draculaTheme = {
    url = "github:dracula/pygments";
    flake = false;
  };
  inputs.pandoc-templates = {
    url = "github:minijackson/pandoc-templates";
    flake = false;
  };

  outputs = { self, nixpkgs, beamertheme-metropolis, draculaTheme, pandoc-templates, }:
    let
      pkgs = nixpkgs.legacyPackages.x86_64-linux;
    in
    {

      packages.x86_64-linux.pygments = pkgs.python3Packages.pygments.overrideAttrs (oldAttrs: {
        postPatch = ''
          cp ${draculaTheme}/dracula.py pygments/styles/
          sed -i 's/bg:.\+ //' pygments/styles/inkpot.py
        '';
      });

      defaultPackage.x86_64-linux =
        let
          beamertheme-metropolis' = pkgs.stdenvNoCC.mkDerivation {
            pname = "texlive-beamertheme-metropolis";
            version = "${builtins.substring 0 8 beamertheme-metropolis.lastModifiedDate}-${beamertheme-metropolis.shortRev or "dirty"}";

            src = beamertheme-metropolis;

            outputs = [ "out" "doc" ];

            nativeBuildInputs = with pkgs; [
              (texlive.combine {
                inherit (texlive)
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
        pkgs.runCommand "slides"
          {
            src = ./.;
            nativeBuildInputs = with pkgs; [
              pandoc
              self.packages.x86_64-linux.pygments
              fira-code
              which
              (texlive.combine {
                inherit (texlive)
                  scheme-medium
                  latexmk

                  beamercolorthemeowl

                  # For framed code listings
                  tcolorbox environ

                  # Optional pandoc dependencies
                  microtype upquote parskip xurl bookmark footnotehyper

                  # Some dependencies
                  fvextra pgfopts minted catchfile xstring framed;
                beamertheme-metropolis = { pkgs = [ beamertheme-metropolis' ]; };
              })
            ];

            FONTCONFIG_FILE = pkgs.makeFontsConf {
              fontDirectories = with pkgs; [ lmodern freefont_ttf fira fira-code ];
            };
          } ''
          unpackFile $src
          cd */
          chmod -R u+w .

          pandoc slides.md -t beamer -so slides.tex  \
            --template=${pandoc-templates}/default.latex \
            --lua-filter=${pkgs.pandoc-lua-filters}/share/pandoc/filters/minted.lua \
            --pdf-engine=xelatex \
            --pdf-engine-opt=-aux-directory=./build \
            --pdf-engine-opt=-shell-escape

          latexmk \
            -shell-escape \
            -xelatex \
            -8bit \
            -interaction=nonstopmode \
            -verbose \
            -file-line-error \
            -output-directory=./build slides

          cp build/slides.pdf $out
        '';
      # TODO: diagram-generator?
    };
}
