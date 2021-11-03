{
  description = "My templates for making things with pandoc";

  outputs = { self, nixpkgs }: {

    templates = {
      beamer = {
        path = ./beamer;
        description = "Beamer slides with pandoc";
      };
    };

    defaultTemplate = self.templates.beamer;

  };
}
