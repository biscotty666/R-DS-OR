{
  description = "A basic flake with a shell";
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  inputs.flake-utils.url = "github:numtide/flake-utils";

  outputs = { nixpkgs, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        RStudio-with-my-packages = pkgs.rstudioWrapper.override{ packages = with pkgs.rPackages;
        [
          tidyverse
          DBI
          tidymodels
          dbplyr
          nycflights13
          jsonlite
          palmerpenguins
          ggthemes
          ggridges
          arrow
          duckdb
        ]; };
      in
      {
        devShells.default = pkgs.mkShell {
          packages = [ pkgs.bashInteractive ];
          buildInputs = with pkgs; [
            R rPackages.pagedown pandoc chromium rPackages.pandoc RStudio-with-my-packages
          ];
        };
      });
}
