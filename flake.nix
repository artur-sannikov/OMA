{
  description = "Nix Flake for Orchestrating Microbiome Analysis book";

  inputs = {
    nixpkgs.url = "github:rstats-on-nix/nixpkgs/51f769d97829f3bc233d21094d8acbbfce0f6d0f"; # Bioconductor devel
    flake-utils.url = "github:numtide/flake-utils";

    SpiecEasi-flake.url = "github:artur-sannikov/SpiecEasi/nix-flakes";
    SpiecEasi-flake.inputs.nixpkgs.follows = "nixpkgs";

    SPRING-flake.url = "github:artur-sannikov/SPRING/nix-flakes";
    SPRING-flake.inputs.nixpkgs.follows = "nixpkgs";

    NetCoMi-flake.url = "github:artur-sannikov/NetCoMi/nix-flakes";
    NetCoMi-flake.inputs.nixpkgs.follows = "nixpkgs";

    miaTime-flake.url = "github:artur-sannikov/miaTime/nix-flakes";
    miaTime-flake.inputs.nixpkgs.follows = "nixpkgs";

    miaViz-flake.url = "github:artur-sannikov/miaViz/nix-flakes";
    miaViz-flake.inputs.nixpkgs.follows = "nixpkgs";

    IntegratedLearner-flake.url = "github:artur-sannikov/IntegratedLearner/nix-flakes";
    IntegratedLearner-flake.inputs.nixpkgs.follows = "nixpkgs";
  };
  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
      SpiecEasi-flake,
      SPRING-flake,
      NetCoMi-flake,
      miaTime-flake,
      miaViz-flake,
      IntegratedLearner-flake,
      ...
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs {
          inherit system;
        };
        SpiecEasi = SpiecEasi-flake.packages.${system}.default;
        SPRING = SPRING-flake.packages.${system}.default;
        NetCoMi = NetCoMi-flake.packages.${system}.default;
        miaTime = miaTime-flake.packages.${system}.default;
        miaViz = miaViz-flake.packages.${system}.default;
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
              miaViz
              IntegratedLearner
            ];
        };
        R = with pkgs; [
          (rWrapper.override {
            packages = [
              OMA
            ];
          })
        ];
        system_packages = builtins.attrValues {
          inherit (pkgs)
            quarto
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
