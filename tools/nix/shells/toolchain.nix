# This function defines attrsets with packages
# to be used in the different development shells
# in this folder.

# Search for package at:
# https://search.nixos.org/packages
{
  lib,
  pkgs,
  namespace,
  ...
}@args:
let
  language = "go";
  toolchains = lib.${namespace}.toolchain.import ./. args;
in
toolchains
// rec {
  default = toolchains.${language};
  ci = default;
}
