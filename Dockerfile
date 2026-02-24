# ARG BIOC_VERSION
# FROM bioconductor/bioconductor_docker:${BIOC_VERSION}
FROM ghcr.io/bioconductor/bioc2u-builder:noble-bioc-3.22-r-4.5.2
ARG GITHUB_PAT
ENV GITHUB_PAT=${GITHUB_PAT}
ENV QUARTO_VERSION="1.8.27"
COPY . /opt/pkg

RUN mkdir -p /opt/quarto/"${QUARTO_VERSION}" && \
    curl -o quarto.tar.gz -L \
    "https://github.com/quarto-dev/quarto-cli/releases/download/v"${QUARTO_VERSION}"/quarto-$"{QUARTO_VERSION}"-linux-amd64.tar.gz" && \
    tar -zxvf quarto.tar.gz \
    -C "/opt/quarto/${QUARTO_VERSION}" \
    --strip-components=1 && \
    rm quarto.tar.gz && \
    ln -s /opt/quarto/${QUARTO_VERSION}/bin/quarto /usr/local/bin/quarto

# Install book package
RUN Rscript -e 'repos <- BiocManager::repositories() ; remotes::install_local(path = "/opt/pkg/", repos=repos, dependencies=TRUE, build_vignettes=FALSE, upgrade=TRUE) ; sessioninfo::session_info(installed.packages()[,"Package"], include_base = TRUE)'

## Build/install using same approach than BBS
RUN R CMD INSTALL /opt/pkg
RUN R CMD build --keep-empty-dirs --no-resave-data /opt/pkg
