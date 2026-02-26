# DARApipeline

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

To install DARApipeline from GitHub, first install the graph package by running:

``` r
if (!requireNamespace("BiocManager", quietly = TRUE)) {
  install.packages("BiocManager")
}
BiocManager::install("graph")
```

You can now download the latest version of DARApipeline via GitHub using the remotes package:

``` r
if (!requireNamespace("remotes", quietly = TRUE)) {
  install.packages("remotes")
}
remotes::install_github("rivm-syso/DARApipeline@main", build = FALSE")
```

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

First point of contact for questions: DARAteam ([epi-dara\@rivm.nl](mailto:epi-dara@rivm.nl){.email}).

Please report a DARApipeline issue at [GitLab issues](https://gitlab.rivm.nl/dara/DARApipeline/-/issues).

## Authors and acknowledgment

This R package was created by the DARA team (RIVM/CIb/EPI in department DIS).

## License

The code can be re-used under license [EUPL v.1.2](https://eupl.eu/1.2/en/).

## Code of Conduct

We want to create a welcoming and respectful environment for everyone.

- Be kind and respectful to others.
- Do not use offensive or inappropriate language.
- Respect differences in opinion, experience, and background.
- If you experience or witness unacceptable behavior, please report it by contacting the maintainers at epi-dara@rivm.nl.

## Disclaimer

This R package was originally developed to meet the specific needs of the EPI (Epidemiology & Surveillance) department
within the CIb (Centre for Infectious Disease Control) at the RIVM. However, it is made openly available to all
RIVM employees who may find it useful for their work. While we welcome and encourage feedback from users
outside the EPI department, please note that the package's primary development focus remains
aligned with the needs of its original user base.

We strive to ensure that the package is reliable and effective for its intended purposes, but we cannot guarantee
that every feature or functionality will fully meet the requirements of your specific use case. Additionally, while
we appreciate all suggestions and feedback, we cannot guarantee that we will have the time or resources to incorporate
every requested feature or fix into future updates.

This package is provided "as is", without any express or implied warranties of accuracy, completeness, fitness for a
particular purpose, or non-infringement. Use of the package, and interpretation of its results, is at your own risk.
We encourage users to validate outputs thoroughly before applying them in critical contexts.

If you encounter issues, have suggestions, or wish to share feedback, please report them via the package's
GitHub issue board or by contacting the package maintainer(s):
DARAteam (epi-dara@rivm.nl). Your input is highly valuable
and helps us improve the package for all users.
Thank you for your understanding and cooperation!
