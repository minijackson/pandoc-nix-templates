{
  description = "My epic presentation";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  inputs.pandoc-nix-templates.url = "github:minijackson/pandoc-nix-templates";

  outputs = { self, nixpkgs, pandoc-nix-templates, }:
    let
      pkgs = import nixpkgs {
        system = "x86_64-linux";
        overlays = [ pandoc-nix-templates.overlay ];
      };
    in
    {
      defaultPackage.x86_64-linux = pkgs.mkPandocBeamerPdf {
        name = "slides";
        src = ./.;
      };
    };
}
