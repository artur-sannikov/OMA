{
  description = "Nix Flake for Orchestrating Microbiome Analysis book";

  inputs = {
    # nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    # nixpkgs.url = "github:rstats-on-nix/nixpkgs/master";
    nixpkgs.url = "github:rstats-on-nix/nixpkgs/r-bioc-devel";
    # bioconductor-nixpkgs.inputs.nixpkgs.follows = "nixpkgs";
    # nixpkgs.url = "github:rstats-on-nix/nixpkgs/b1747d3e8d1533318f627a32327fb5602be58039";
    flake-utils.url = "github:numtide/flake-utils";
    # mia-flake.url = "github:artur-sannikov/mia/nix-flakes";
    SpiecEasi-flake.url = "github:artur-sannikov/SpiecEasi/nix-flakes";
    # SpiecEasi-flake.inputs.nixpkgs.follows = "nixpkgs";
    SPRING-flake.url = "github:artur-sannikov/SPRING/nix-flakes";
    NetCoMi-flake.url = "github:artur-sannikov/NetCoMi/nix-flakes";
    miaTime-flake.url = "github:artur-sannikov/miaTime/nix-flakes";
    miaViz-flake.url = "github:artur-sannikov/miaViz/nix-flakes";
    IntegratedLearner-flake.url = "github:artur-sannikov/IntegratedLearner/nix-flakes";
  };

  outputs =
    {
      self,
      nixpkgs,
      # bioconductor-nixpkgs,
      flake-utils,
      # mia-flake,
      SpiecEasi-flake,
      SPRING-flake,
      NetCoMi-flake,
      miaTime-flake,
      # # miaViz-flake,
      IntegratedLearner-flake,
      ...
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        # overlays = [
        #   (final: prev: {
        #     rPackages = prev.rPackages // {
        #       # Force mia to be the bleeding-edge version
        #       mia = mia-flake.packages.${system}.default;
        #     };
        #   })
        # ];
        pkgs = import nixpkgs {
          inherit system;
        };
        # bioconductor-pkgs = import bioconductor-nixpkgs {
        #   inherit system;
        # };
        SpiecEasi = SpiecEasi-flake.packages.${system}.default;
        SPRING = SPRING-flake.packages.${system}.default;
        NetCoMi = NetCoMi-flake.packages.${system}.default;
        miaTime = miaTime-flake.packages.${system}.default;
        # miaViz = miaViz-flake.packages.${system}.default;
        IntegratedLearner = IntegratedLearner-flake.packages.${system}.default;
        OMA = pkgs.rPackages.buildRPackage {
          name = "OMA";
          src = self;
          propagatedBuildInputs =
            builtins.attrValues {
              inherit (pkgs.rPackages)
                ALDEx2
                ANCOMBC
                ape
                biclust
                BiocBook
                BiocManager
                BiocParallel
                Biostrings
                bluster
                caret
                circlize
                cluster
                cobiclust
                ComplexHeatmap
                corpcor
                curatedMetagenomicData
                dada2
                dendextend
                devtools
                DirichletMultinomial
                dplyr
                DT
                factoextra
                forcats
                fido
                ggplot2
                ggpubr
                ggtree
                glmnet
                glue
                gtools
                gsEasy
                igraph
                kableExtra
                knitr
                Maaslin2
                mia
                # miaTime
                miaViz
                microbiome
                microbiomeDataSets
                MicrobiomeStat
                mikropml
                MMUPHin
                MOFA2
                multiview
                NbClust
                NMF
                patchwork
                phyloseq
                plotly
                purrr
                qgraph
                RColorBrewer
                rebook
                reshape2
                reticulate
                rgl
                ROCR
                scales
                sechm
                sessioninfo
                shadowtext
                stringr
                SuperLearner
                tidyverse
                topGO
                vegan
                WGCNA
                xgboost
                ;
            }
            ++ [
              SpiecEasi
              SPRING
              NetCoMi
              miaTime
              # miaViz
              IntegratedLearner
            ];
        };
        R = with pkgs; [
          (rWrapper.override {
            packages = [
              # rPackages.mia
              OMA
            ];
          })
        ];
        system_packages = builtins.attrValues {
          inherit (pkgs)
            # quarto
            R
            glibcLocales
            nix
            # deno
            ;
        };
      in
      {
        devShells.default = pkgs.mkShell {
          LOCALE_ARCHIVE =
            if pkgs.system == "x86_64-linux" then "${pkgs.glibcLocales}/lib/locale/locale-archive" else "";
          LANG = "en_US.UTF-8";
          LC_ALL = "en_US.UTF-8";
          LC_TIME = "en_US.UTF-8";
          LC_MONETARY = "en_US.UTF-8";
          LC_PAPER = "en_US.UTF-8";
          LC_MEASUREMENT = "en_US.UTF-8";
          buildInputs = [
            R
            system_packages
          ];
        };
      }
    );
}
