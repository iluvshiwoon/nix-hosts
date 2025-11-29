{
  inputs,
  pkgs,
  ...
}: {
  nixpkgs.config.allowUnfree = true;
  home.packages = [
    inputs.zen-browser.packages.${pkgs.system}.default
    pkgs.nixgl.nixGLIntel
  ];
}
