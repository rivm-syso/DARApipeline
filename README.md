# DARApipeline

![ci status](https://gitlab.rivm.nl/dara/DARApipeline/badges/develop/pipeline.svg)
![coverage](https://gitlab.rivm.nl/dara/DARApipeline/badges/develop/coverage.svg)

## Tools To Run Your EPI Pipelines


## Overview
DARApipeline (part of [DARAtools](https://gitlab.rivm.nl/dara/DARAtools)) is a R-package that
provides you with the tools to run an EPI pipeline.

## Installation and updating

### From RIVM GitLab

#### Most recent version

To install DARApipeline, first install the graph package by running:

``` r
if (!requireNamespace("BiocManager", quietly = TRUE)) {
  install.packages("BiocManager")
}
BiocManager::install("graph")
```

You can now download the latest version of DARApipeline via the internal Gitlab environment using the remotes package:

``` r
if (!requireNamespace("remotes", quietly = TRUE)) {
  install.packages("remotes")
}
remotes::install_gitlab("dara/DARApipeline@main", host = "https://gitlab.rivm.nl", build = FALSE)
```

Please visit the [Wiki](https://gitlab.rivm.nl/dara/wiki/-/wikis/DARAtools) to find instructions on how to install older versions of DARApipeline.

#### Development version

``` r
remotes::install_gitlab("dara/DARApipeline@develop", host = "https://gitlab.rivm.nl", build = FALSE)
```

### From RIVM-syso GitHub

*Installation via Github*
Will be added in the near future.

### From CRAN

*Installation via CRAN*
Will be added in the near future.

## Usage

`r library(DARApipeline)` will load the DARApipeline package, part of the DARAtools framework.
The other packages within [DARAtools](https://gitlab.rivm.nl/dara/DARAtools) are:

-   [DARAgit](https://gitlab.rivm.nl/dara/DARAgit), for git functionality.
-   [DARAvis](https://gitlab.rivm.nl/dara/DARAvis), for data visualisation in RIVM-house style.
-   [DARAgeo](https://gitlab.rivm.nl/dara/DARAgeo), for loading geographical data.
-   [DARAutils](https://gitlab.rivm.nl/dara/DARAutils), for supporting other DARA packages and related features.

## Getting help

For detailed documentation, use:

``` r
# The function check_data_asset() is used here as an example.
# Please replace it with the specific function for which you want to see documentation.
?check_data_asset
```

First point of contact for questions: DARAteam ([dara-team-list\@rivm.nl](mailto:dara-team-list@rivm.nl){.email}).

Please report an DARApipeline issue at [GitLab issues](https://gitlab.rivm.nl/dara/DARApipeline/-/issues).

## Authors and acknowledgment

This R package was created by the DARA team (RIVM/CiB/EPI in department DIS).

## License

The code can be re-used under license [EUPL v.1.2](https://eupl.eu/1.2/en/).
