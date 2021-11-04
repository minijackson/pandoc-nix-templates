{
  description = "My templates for making things with pandoc";

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

  outputs = inputs @ { self, nixpkgs, beamertheme-metropolis, draculaTheme, pandoc-templates, }: {
    overlay = import ./overlay.nix inputs;

    templates = {
      beamer = {
        path = ./beamer;
        description = "Beamer slides with pandoc";
      };
    };

    defaultTemplate = self.templates.beamer;
  };
}
