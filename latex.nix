{
  lib,
  runCommand,
  makeFontsConf,
  fira,
  fira-code,
  fira-mono,
  league-of-moveable-type,
  inkscape,
  freefont_ttf,
  lmodern,
  pandoc,
  pandoc-lua-filters,
  pandoc-templates,
  pygments,
  texlive,
  which,
  documentType ? "latex",
}: {
  name,
  src,
  extraPandocArgs ? "",
  extraLatexArgs ? "",
  extraTeXLivePackages ? {},
}:
with lib;
  runCommand name
  {
    inherit src;

    nativeBuildInputs = [
      pandoc
      pygments
      fira-code
      fira-mono
      which
      (texlive.combine ({
        inherit (texlive) scheme-full;
      } // extraTeXLivePackages))
      league-of-moveable-type
      inkscape
    ];

    FONTCONFIG_FILE = makeFontsConf {
      fontDirectories = [lmodern freefont_ttf fira fira-code];
    };

    pandocCmd = ''
      pandoc ${name}.md -t ${documentType} -so document.tex
        --template=${pandoc-templates}/default.latex
        --lua-filter=${pandoc-lua-filters}/share/pandoc/filters/minted.lua
        --pdf-engine=xelatex
        --pdf-engine-opt=-aux-directory=./build
        --pdf-engine-opt=-shell-escape ${extraPandocArgs}
    '';

    latexmkCmd = ''
      latexmk
        -shell-escape
        -xelatex
        -8bit
        -interaction=nonstopmode
        -verbose
        -file-line-error
        -output-directory=./build document.tex ${extraLatexArgs}
    '';
  } ''
    unpackFile $src
    cd */
    chmod -R u+w .

    $pandocCmd

    $latexmkCmd

    cp build/document.pdf $out
  ''
# TODO: diagram-generator?

