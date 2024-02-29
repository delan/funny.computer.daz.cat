{ pkgs ? import <nixpkgs> {} }:
pkgs.mkShell {
  buildInputs = [
    pkgs.soupault
    pkgs.rsync
    pkgs.colordiff
  ];
}
