# Create a GitHub Actions workflow that builds the Nix environment and pushes
# its packages to a Cachix cache owned by this fork.
#
# The workflow is generated with rix::ga_cachix() and then adjusted so that it:
#   * runs only in forks, never in microbiome/OMA;
#   * runs from the fork-only rix-env branch, or manually via workflow_dispatch();
#   * rebuilds only when the Nix environment definition changes.
#
# Usage:
#   Rscript setup_fork_cachix.R [CACHE_NAME]
#
# If CACHE_NAME is omitted, CACHIX_CACHE_NAME is used. If that is also unset,
# the cache name defaults to "<GitHub owner>-oma". Create that cache at
# https://app.cachix.org/ and add a CACHIX_AUTH secret to the fork before
# pushing.

args <- commandArgs(trailingOnly = TRUE)
default_cache <- "${{ github.repository_owner }}-oma"
cache_name <- if (length(args) >= 1L && nzchar(args[[1L]])) {
    args[[1L]]
} else {
    Sys.getenv("CACHIX_CACHE_NAME", unset = default_cache)
}

if (!requireNamespace("rix", quietly = TRUE)) {
    stop(
        "The {rix} package is required to create the Cachix workflow. ",
        "Install it with install.packages(\"rix\")."
    )
}

# Generate the base workflow from the {rix} template.
rix::ga_cachix(
    cache_name = cache_name,
    path_default = "default.nix"
)

workflow <- file.path(".github", "workflows", "cachix_dev_env.yaml")
yaml <- readLines(workflow, warn = FALSE)

# Replace the template trigger with a fork-only, environment-specific trigger.
branch_idx <- grep("^    branches: \\[.*\\]$", yaml)
if (length(branch_idx) != 1L) {
    stop("Could not find the branch trigger in ", workflow, ".")
}
yaml <- c(
    yaml[seq_len(branch_idx - 1L)],
    "    branches: [ rix-env ]",
    "    paths:",
    "      - default.nix",
    "      - generate_env.R",
    "      - .github/workflows/cachix_dev_env.yaml",
    "  workflow_dispatch:",
    yaml[seq.int(branch_idx + 1L, length(yaml))]
)

# The upstream repository must never try to use the fork's Cachix credentials.
job_idx <- grep("^  r-update-cachix:", yaml)
if (length(job_idx) != 1L) {
    stop("Could not find the r-update-cachix job in ", workflow, ".")
}
yaml <- append(
    yaml,
    "    if: github.repository != 'microbiome/OMA'",
    after = job_idx
)

writeLines(yaml, workflow)
message("Fork-only Cachix workflow written to: ", workflow)
message("Cache name: ", cache_name)
