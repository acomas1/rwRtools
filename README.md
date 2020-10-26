
<!-- README.md is generated from README.Rmd. Please edit that file -->

# rwRtools

<!-- badges: start -->

<!-- badges: end -->

The goal of `rwRtools` is to make it easy to access The Lab’s datasets
and get started with research.

## What is The Lab?

The Lab is [Robot Wealth’s](https://robotwealth.com/) portal for
collaborative research.

It is organized around **Research Pods,** which contain data, ideas,
research and peer-reviewed edges for a given market question.

For example:

  - in the *Equity Factor Research Pod* we look at the question: "*What
    factors predict the relative performance of stocks in the Russell
    1000 index?"*
  - In the *Global Risk Premia Research Pod* we look at the question:
    “*What is the most effective way to get paid for taking on global
    market risks?*”

## What is the purpose of The Lab?

**The Lab serves three purposes:**

1.  It gets you hands-on with the research effort. As well as
    contributing, you’ll learn a ton in the process.
2.  It scales the research effort by enabling community contribution.
3.  It makes the fruits of that scaled research effort available to the
    entire community.

## Demo

### Install and load

The easiest way to install and load `rwRtools` and its dependencies is
via the `pacman` library:

``` r
if(!require("pacman")) install.packages("pacman")
#> Loading required package: pacman
pacman::p_load_gh("RWLab/rwRtools", dependencies = TRUE)
```

If you prfer, you can also use `devtools` to install:

``` r
devtools::install_github("RWLab/rwRtools", dependencies = TRUE)
```

### Quickstart: Set up for working on a Research Pod

After installing and loading `rwRtools`, this is the quickest way to set
up a session for working on a particular Research Pod.

``` r
setup_for_pod(pod = "EquityFactors", path = ".")
```

This kicks off the OAuth process and if successful, transfers all
objects associated with the Pod from GCS to `path`.

If your session is interactive, you will be prompted in a browser to
select a Google Identity and copy and paste an authentication code back
at the call site.

### List The Lab’s Research Pods

Each Pod has an associated GCS bucket containing datasets and other
objects relevant to the Pod. Get a list of currently available Pods by
doing:

``` r
list_pods()
#> [1] "EquityFactors"
```

This function does not access GCS and therefore does not require an
authorisation step.

### See a Research Pod’s GCS objects

See all objects associated with a Research Pod:

``` r
get_pod_meta(pod = "EquityFactors")
#> $bucket
#> [1] "rw_equity_research_sprint"
#> 
#> $datasets
#> [1] "clean_R1000.csv"  "fundamentals.csv"
```

This function does not access GCS and therefore does not require an
authorisation step.

### Kick off an OAuth process to access The Lab’s cloud infrastructure

If called in an interactive session, you will be prompted in a browser
to select a Google Identity and copy and paste an authentication code
back at the call site.

This is useful if you need re-authorise, or if you want to access
specific Lab objects in GCS without doing the entire setup process.

``` r
rwlab_gc_auth()
```

### Load all GCS objects for a Research Pod

This transfers all objects associated with a Pod from GCS to `path`,
overwriting any existing local Pod objects.

This is useful if you need a fresh copy of the Pod’s datasets, but don’t
need to re-authorise to GCS. Requires that you’ve already authorised to
the relevant GCS bucket.

``` r
load_pod_data(pod = "EequityFactors", path = ".")
```

### Load a specific GCS object

This transfers a specifc object from GCS to `path`, overwriting any
existing local instance of that object.

This is useful if you need a fresh copy of a single dataset, but don’t
need to re-authorise to GCS. Requires that you’ve already authorised to
the relevant GCS bucket.

``` r
load_lab_object(path = ".", object = "clean_R1000.csv", bucket = "rw_equity_research_sprint")
```
