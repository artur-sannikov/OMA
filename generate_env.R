# Regenerate the Nix environment with the latest available R packages.
#
# "bioc-devel" tracks the latest Bioconductor development packages (including
# mia and miaViz), so the book can be tested against the current devel APIs.
# Set RIX_R_VERSION="bleeding-edge" to use the latest released CRAN and
# Bioconductor packages instead. For a reproducible environment, use a date
# from rix::available_dates(), for example RIX_R_VERSION="2026-11-18".
#
# Usage from the repository root:
#   Rscript generate_env.R
#   cachix use rstats-on-nix   # optional, but strongly recommended
#   direnv allow               # or start the environment with: nix-shell
#
# Then render the book as usual, for example with:
#   Rscript -e 'BiocBook::preview(BiocBook::BiocBook("."))'

if (!requireNamespace("rix", quietly = TRUE)) {
    stop(
        "The {rix} package is required to regenerate default.nix. ",
        "Install it with install.packages(\"rix\")."
    )
}

r_ver <- Sys.getenv("RIX_R_VERSION", unset = "bioc-devel")

rix::rix(
    r_ver = r_ver,
    r_pkgs = c(
        "ape",
        "BiocBook",
        "BiocManager",
        "BiocStyle",
        "bluster",
        "ComplexHeatmap",
        "curatedMetagenomicData",
        "dendextend",
        "DirichletMultinomial",
        "dplyr",
        "DT",
        "GenomeInfoDb",
        "factoextra",
        "ggdag",
        "ggExtra",
        "ggplot2",
        "ggpubr",
        "ggtree",
        "glue",
        "gt",
        "knitr",
        "Maaslin2",
        "maaslin3",
        "mediation",
        "mia",
        "miaTime",
        "miaViz",
        "microbiomeDataSets",
        "mikropml",
        "MOFA2",
        "NbClust",
        "NMF",
        "patchwork",
        "philr",
        "phyloseq",
        "qgraph",
        "rebook",
        "rix",
        "scales",
        "scater",
        "scuttle",
        "sechm",
        "sessioninfo",
        "shadowtext",
        "tidySingleCellExperiment",
        "tidyverse",
        "vegan"
    ),
    system_pkgs = c("quarto", "radian"),
    ide = "none",
    project_path = ".",
    overwrite = TRUE
)
