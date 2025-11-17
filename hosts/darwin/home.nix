{
  inputs,
  pkgs,
  ...
}: {
  xdg.configFile = {
    "aerospace/aerospace.toml".source = ./config/aerospace.toml;
  };
  home.file.".emacs.d/tree-sitter".source = "${pkgs.emacsPackages.treesit-grammars.with-all-grammars}/lib";
}
