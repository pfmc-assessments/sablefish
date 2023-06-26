
<!-- README.md is generated from README.Rmd. Please edit that file -->

# sablefish

<!-- badges: start -->

[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)
[![R-CMD-check](https://github.com/pfmc-assessments/sablefish/workflows/R-CMD-check/badge.svg)](https://github.com/pfmc-assessments/sablefish/actions?query=workflow%3AR-CMD-check)
<!-- badges: end -->

Welcome to {sablefish}. This repository was created in 2023 for the
limited sablefish update.

## Installation

You can install {sablefish} from [GitHub](https://github.com/) with

``` r
# install.packages("pak")
pak::pkg_install("pfmc-assessments/sablefish")
```

## Workflow

### File structure

This repository is structured like an R package to ease the installation
process and increase the ability to easily test code. Please follow the
following guidelines for the placement of files.

``` bash
├───.github
│   └───workflows
├───data
├───data-raw
├───man
│   └───figures
│       └───README-
├───R
├───sandbox
└───tests
    └───testthat
```

Where

- data is for data in its final form that will be included in the
  assessment or assessment document, do not commit these files;
- data-raw is for data files and .R scripts used to transform these raw
  files into something that is saved in data;
- man stores .Rd files and figures used in the documentation;
- R stores .R scripts that are loaded when building the package, this
  means functions only;
- sandbox is for exploratory scripts; and
- tests is for formal tests.

### Rebase, no merge

Please do not merge main into your feature branch or main; this
repository will operate using a rebase strategy only to facilitate a
linear commit history.

### README

Please render this file every time you change it, and thus, all commits
that include README.Rmd should include associated changes in README.md.
A pre-commit hook will stop you from just committing this file if you
have not also updated and staged changes to README.md.

``` r
devtools::build_readme()
```
