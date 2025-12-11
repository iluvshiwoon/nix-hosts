#!/bin/sh
export NIXPKGS_ALLOW_UNFREE=1
export NP_LOCATION=/media/$USER/Nix_Store
export NP_DEBUG=1
export NP_GIT=/usr/bin/git
export NP_RUNTIME=bwrap

NIX=$HOME/nix-portable

export TERM=xterm-256color
export PATH=$HOME/.nix-profile/bin:$PATH

#fix double char
export LANG=C.UTF-8

$NIX nix run --impure github:nix-community/nixGL -- emacs
