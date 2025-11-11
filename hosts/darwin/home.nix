{
  inputs,
  pkgs,
  ...
}: {
  xdg.configFile = {
    "aerospace/aerospace.toml".source = ./config/aerospace.toml;
  };
}
