# reading-mzTab-into-R

This repository contains the code and supporting materials for evaluating and demonstrating the import of mzTab files into R. The work is carried out as part of **BioHackathon Europe 2025, Project 14**:

https://github.com/elixir-europe/biohackathon-projects-2025/blob/main/14.md

The analysis is implemented in R, while the user-facing interface is available through the GitHub Pages site:

https://burdukiewicz.com/reading-mzTab-into-R/

The GitHub Pages interface presents the rendered evaluation and shows how different mzTab files behave when processed in R.

## Repository structure

    examples/               Example mzTab files
    index.Rmd               Walkthrough for reading mzTab files in R
    prepare-environment.R   Script that sets up the required R environment
    renv/                   Reproducible R environment managed with renv
    README.md               Project description

## Running locally

Clone the repository and install [jmzTab-m](https://github.com/lifs-tools/jmzTab-m).

Then, execute the following scripts:

``` r
source("prepare-environment.R")
source("run-test.R")
```

## renv

The repository relies on [renv](https://github.com/rstudio/renv)’s profiles to make its mzTab import experiments reproducible across alternative packages. The `rendering` profile is the main profile that manages the evaluation of the code and rendering the resulting website.

Other profiles (at this moment: `MetaboAnalystR` and `rmzTabM`) are implemented to run individual R packages. 

## How to add my tool?

To extend the repository with additional mzTab readers:

1. Create an appropriate renv profile (so your tool is evaluated in a controlled dependency context).
2. Add a dedicated **testing wrapper** in `test-scripts/` that reads all files in `examples/` using the new tool and records success or structured failure. 

### Testing wrapper

The **testing wrapper** should be implemented as a function `test_XYZ(all_files)`, where XYZ is replaced by the exact package name, and where `all_files` is a character vector of input mzTab paths. Each wrapper must return structured, tool-agnostic information, allowing results to be aggregated without special casing.

Begin by activating the dedicated renv profile for the tool and ensuring the package is installed and loadable, using the standard preamble below within the **testing wrapper** body (with XYZ substituted accordingly):

``` r
renv::activate(profile = "XYZ")
if (!require("XYZ", character.only = TRUE)) {
  renv::restore()
  require("XYZ", character.only = TRUE)
}
```

Process each file independently, wrapping the read call in `try(..., silent = TRUE)` (or equivalent), so that failures are captured and the loop continues.

Finally, return a list with two elements. First, assessment, a character vector of length `length(all_files)` with exactly three allowed labels: `success` when parsing yields the expected object type for your tool, `crash` when the result inherits `try-error`, and `silent failure` when the call returns neither a valid parse object nor a `try-error`. Second, reads, a list of the raw per file results in the original order, including any `try-error` objects, ensuring that downstream code can both summarize performance and inspect exact failure messages.

## License

MIT License.
