# ./overlays/default.nix
{
  config,
  pkgs,
  lib,
  ...
}:

{
  nixpkgs.overlays = [
    # Overlay 1: Use `self` and `super` to express
    # the inheritance relationship
    # (self: super: {
    #   google-chrome = super.google-chrome.override {
    #     commandLineArgs = "--proxy-server='https=127.0.0.1:3128;http=127.0.0.1:3128'";
    #   };
    # })
[ (_: super: {
  rPackages.mia = super.rPackages.mia.overrideAttrs (_: {src = ...;});
})];
}
