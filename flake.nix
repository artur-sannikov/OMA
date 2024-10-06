{
  description = "Nix Flake for Orchestrating Microbiome Analysis book";
  inputs = {
    nixpkgs.url = "github:rstats-on-nix/nixpkgs/a4e033f90ce58031f324432b8bf0ca3b4bcf155c";
    flake-utils.url = "github:numtide/flake-utils";
    SpiecEasi.url = "github:artur-sannikov/SpiecEasi/nix-flakes";
    SPRING.url = "github:artur-sannikov/SPRING/nix-flakes";
    NetCoMi.url = "github:artur-sannikov/NetCoMi/nix-flakes";
    mia.url = "github:artur-sannikov/mia/nix-flakes";
    # mia.inputs.nixpkgs.follows = "nixpkgs";
    miaTime.url = "github:artur-sannikov/miaTime/nix-flakes";
  };
  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
      SpiecEasi,
      SPRING,
      NetCoMi,
      mia,
      miaTime,
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        # pkgs = nixpkgs.legacyPackages.${system};
        pkgs = import nixpkgs {
          inherit system;
          overlays = [ self.overlays.default ];
          # overlays = [
          #   (_: super: {
          #     rPackages.mia = super.rPackages.mia.overrideAttrs (_: {
          #       src = mia;
          #     });
          #   })
          # ];
        };
        # overlay = final: prev: {
        #   rPackages.mia = prev.rPackages.mia.overrideAttrs (_: {
        # Specify the new source for the package
        # src = fetchFromGitHub {
        #   owner = "microbiome";
        #   repo = "mia";
        #   rev = "devel";
        #   sha256 = "";
        # };
        #     src = mia;
        #   });
        # };
        # pkgs = import nixpkgs {
        #   inherit system;
        #   overlays = [ overlay ];
        # };
        SpiecEasiPkg = SpiecEasi.packages.${system}.default;
        SPRINGPkg = SPRING.packages.${system}.default;
        NetCoMiPkg = NetCoMi.packages.${system}.default;
        # miaPkg = mia.packages.${system}.default;
        miaTimePkg = miaTime.packages.${system}.default;

        # ANCOMBC_Overriden = pkgs.rPackages.ANCOMBC.overrideAttrs (oldAttrs: {
        #   propagatedBuildInputs = (oldAttrs.propagatedBuildInputs or [ ]) ++ [ miaPkg ];
        # });
        # ANCOMBC = pkgs.rPackages.ANCOMBC.overrideAttrs (attrs: {
        #   src = pkgs.rPackages.ANCOMBC.src;
        #   # name = "ANCOMBC-${pkgs.rPackages.ANCOMBC.version}";
        #   # pre Patch = "cd r";
        #   # pos tPatch = ''
        #   # p atchShebangs configure
        #   # '';
        #   buildInputs = attrs.buildInputs ++ [
        #     miaPkg
        #   ];
        # });
        # ANCOMBC = pkgs.rPackages.ANCOMBC.overrideAttrs {
        #   mia = miaPkg;
        # };

        #         overlays = [ (_: super: {
        #   rPackages.mia = super.rPackages.mia.overrideAttrs (_: {src = ...;});
        # })];

        # pkgsWithOverlay = pkgs // {
        #   rPackages = pkgs.rPackages // overlay pkgs.rPackages;
        # };

        OMA = pkgs.rPackages.buildRPackage {
          name = "OMA";
          src = self;
          propagatedBuildInputs =
            builtins.attrValues {
              inherit (pkgs.rPackages)
                # ALDEx2
                ANCOMBC
                # ape
                # biclust
                # BiocBook
                # BiocManager
                # BiocParallel
                # Biostrings
                # bluster
                # caret
                # circlize
                # cluster
                # cobiclust
                # ComplexHeatmap
                # corpcor
                # curatedMetagenomicData # ENforces mia 1.12
                # dada2
                # dendextend
                # devtools
                # DirichletMultinomial
                # dplyr
                # DT
                # factoextra
                # forcats
                # fido
                # ggplot2
                # ggpubr
                # ggtree
                # glmnet
                # glue
                # gtools
                # gsEasy
                # igraph
                # kableExtra
                # knitr
                # Maaslin2
                # microbiome
                # microbiomeDataSets
                # MicrobiomeStat
                # mikropml
                # MMUPHin
                # MOFA2
                # multiview
                # NbClust
                # NMF
                # patchwork
                # phyloseq
                # plotly
                # purrr
                # qgraph
                # RColorBrewer
                # rebook
                # reshape2
                # reticulate
                # rgl
                # ROCR
                # scales
                # scater
                # sechm
                # sessioninfo
                # shadowtext
                # stringr
                # SuperLearner
                # tidyverse
                # topGO
                # vegan
                # WGCNA
                # xgboost
                ;
            }
            ++ [
              # SpiecEasiPkg
              # SPRINGPkg
              # NetCoMiPkg
              # ANCOMBC
              # miaPkg
              # pkgsWithOverlay.rPackages.mia
              # ANCOMBC_Overriden
              # miaTimePkg
            ];
        };
      in
      {
        packages.default = OMA;
        overlays.default = [
          (_: super: {
            rPackages.mia = super.rPackages.mia.overrideAttrs (_: {
              src = mia;
            });
          })
        ];
        devShells.default = pkgs.mkShell {
          buildInputs = [
            OMA
            # miaPkg
          ];
          # inputsFrom = pkgs.lib.singleton OMA;
          inputsFrom = [
            OMA
            # miaPkg
          ];
        };
      }
    );
}
