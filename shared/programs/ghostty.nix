{
  pkgs,
  lib,
  ...
}: let
  kanso = builtins.fetchGit {
    url = "https://github.com/webhooked/kanso.nvim";
    rev = "748023fd273782e6e056620ce66a176532cdf375";
  };
  local-themes = ../config/ghostty/themes;
  merged-themes = pkgs.linkFarm "themes-merged" [
    {
      name = "kanso-pearl";
      path = "${kanso}/extras/ghostty/kanso-pearl";
    }
    {
      name = "everforest-light";
      path = "${local-themes}/everforest-light";
    }
  ];
in {
  xdg.configFile = {"ghostty/themes".source = merged-themes;};
  programs.ghostty = {
    enable = true;
    package =
      if pkgs.stdenv.isDarwin
      then null
      else pkgs.ghostty;
    enableZshIntegration = true;
    settings = {
      theme = "kanso-pearl";
      clipboard-read = "allow";
      clipboard-write = "allow";
      clipboard-paste-protection = "false";
    };
  };
}
