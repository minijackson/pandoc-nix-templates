{ runCommand
, makeFontsConf
, fira
, fira-code
, freefont_ttf
, lmodern
, pandoc
, pandoc-lua-filters
, pandoc-templates
, pygments
, texlive
, which
, documentType ? "latex"
}:

{ name, src }:

runCommand name
{
  inherit src;

  nativeBuildInputs = [
    pandoc
    pygments
    fira-code
    which
    (texlive.combine {
      inherit (texlive)
        scheme-medium
        latexmk

        beamertheme-metropolis
        beamercolorthemeowl

        # For framed code listings
        tcolorbox environ

        # Optional pandoc dependencies
        microtype upquote parskip xurl bookmark footnotehyper

        # Some dependencies
        fvextra pgfopts minted catchfile xstring framed;
    })
  ];

  FONTCONFIG_FILE = makeFontsConf {
    fontDirectories = [ lmodern freefont_ttf fira fira-code ];
  };
} ''
  unpackFile $src
  cd */
  chmod -R u+w .

  pandoc ${name}.md -t ${documentType} -so document.tex  \
    --template=${pandoc-templates}/default.latex \
    --lua-filter=${pandoc-lua-filters}/share/pandoc/filters/minted.lua \
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
    -output-directory=./build document.tex

  cp build/document.pdf $out
''

# TODO: diagram-generator?
