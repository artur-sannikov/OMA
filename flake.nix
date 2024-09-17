# {
#   description = "Nix Flake for Orchestrating Microbiome Analysis book";
#   inputs = {
#     # nixpkgs.url = "github:rstats-on-nix/nixpkgs/06f723de83b04d8899722dbf388b20d77a7223eb";
#     nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
#     flake-utils.url = "github:numtide/flake-utils";
#     SpiecEasi.url = "github:artur-sannikov/SpiecEasi/nix-flakes";
#     SPRING.url = "github:artur-sannikov/SPRING/nix-flakes";
#     NetCoMi.url = "github:artur-sannikov/NetCoMi/nix-flakes";
#   };
#   outputs =
#     {
#       self,
#       nixpkgs,
#       flake-utils,
#       SpiecEasi,
#       SPRING,
#       NetCoMi,
#     }:
#     flake-utils.lib.eachDefaultSystem (
#       system:
#       let
#         pkgs = nixpkgs.legacyPackages.${system};
#         SpiecEasiPkg = SpiecEasi.packages.${system}.default;
#         SPRINGPkg = SPRING.packages.${system}.default;
#         NetCoMiPkg = NetCoMi.packages.${system}.default;
#         rdeps = with pkgs; [
#           curl
#           fontconfig
#           fribidi
#           harfbuzz
#           libjpeg
#           libpng
#           libtiff
#           libxml2
#           openssl
#           pkg-config
#         ];
#         OMA = pkgs.rPackages.buildRPackage {
#           name = "OMA";
#           src = self;
#           propagatedBuildInputs =
#             builtins.attrValues {
#               inherit (pkgs.rPackages)
#                 ALDEx2
#                 ANCOMBC
#                 biclust
#                 cobiclust
#                 ComplexHeatmap
#                 curatedMetagenomicData
#                 dendextend
#                 devtools
#                 fido
#                 ggpubr
#                 ggsignif
#                 glue
#                 gsEasy
#                 GUniFrac
#                 kableExtra
#                 Maaslin2
#                 miaViz
#                 microbiome
#                 microbiomeDataSets
#                 MicrobiomeStat
#                 mikropml
#                 MLeval
#                 MMUPHin
#                 multiview
#                 NbClust
#                 randomcoloR
#                 rebook
#                 rgl
#                 sechm
#                 sessioninfo
#                 SummarizedExperiment
#                 SuperLearner
#                 tidyverse
#                 topGO
#                 ;
#             }
#             ++ [
#               SpiecEasiPkg
#               SPRINGPkg
#               NetCoMiPkg
#             ];
#         };
#       in
#       # system_packages = builtins.attrValues { inherit (pkgs) quarto; };
#       # R = pkgs.rWrapper.override {
#       #   packages = [
#       #     OMA
#       #   ];
#       # };
#       {
#         devShells.default = pkgs.mkShell {
#           packages.default = OMA;
#           buildInputs = [ OMA ];
#           inputsFrom = pkgs.lib.singleton OMA;
#           # buildInputs = [
#           #   # R
#           #   OMA
#           #   # system_packages
#           # ];
#           # inputsFrom = pkgs.lib.singleton OMA;
#           # LD_LIBRARY_PATH = pkgs.lib.strings.makeLibraryPath rdeps;
#         };
#       }
#     );
# }

{
  description = "Nix Flake for Orchestrating Microbiome Analysis book";
  inputs = {
    nixpkgs.url = "github:rstats-on-nix/nixpkgs/06f723de83b04d8899722dbf388b20d77a7223eb";
    flake-utils.url = "github:numtide/flake-utils";
    SpiecEasi = {
      url = "github:artur-sannikov/SpiecEasi/nix-flakes";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    SPRING = {
      url = "github:artur-sannikov/SPRING/nix-flakes";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    NetCoMi = {
      url = "github:artur-sannikov/NetCoMi/nix-flakes";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
      SpiecEasi,
      SPRING,
      NetCoMi,
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        SpiecEasiPkg = SpiecEasi.packages.${system}.default;
        SPRINGPkg = SPRING.packages.${system}.default;
        NetCoMiPkg = NetCoMi.packages.${system}.default;
        OMA = pkgs.rPackages.buildRPackage {
          name = "OMA";
          src = self;
          propagatedBuildInputs =
            builtins.attrValues {
              inherit (pkgs.rPackages)
                ALDEx2
                ANCOMBC
                biclust
                cobiclust
                ComplexHeatmap
                curatedMetagenomicData
                dendextend
                devtools
                fido
                ggpubr
                ggsignif
                glue
                gsEasy
                GUniFrac
                kableExtra
                Maaslin2
                miaViz
                microbiome
                microbiomeDataSets
                MicrobiomeStat
                mikropml
                MLeval
                MMUPHin
                multiview
                NbClust
                randomcoloR
                rebook
                rgl
                sechm
                sessioninfo
                SummarizedExperiment
                SuperLearner
                tidyverse
                topGO
                ;
            }
            ++ [
              SpiecEasiPkg
              SPRINGPkg
              NetCoMiPkg
            ];
        };
      in
      {
        packages.default = OMA;
        devShells.default = pkgs.mkShell {
          buildInputs = [ OMA ];
          inputsFrom = pkgs.lib.singleton OMA;
        };
      }
    );
}
