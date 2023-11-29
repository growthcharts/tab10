
<!-- README.md is generated from README.Rmd. Please edit that file -->

# tab10

<!-- badges: start -->
<!-- badges: end -->

The goal of `tab10` is to support risk communication. Many people
struggle with the interpretation of probability. This package develops a
new interactive graphical instrument, the **Table of Ten**, to ease
gaining insight into personal risk probabilities. The goals of the
method are to communicate

1.  the prevalence of a future outcome;
2.  the rank of the person’s predicted probability relative to other
    people;
3.  the positive predictive value of the prediction;
4.  the effect of “doing something” versus “doing nothing”.

Not every goal has yet been achieved. Most of the developments in the
present package relate to points 1, 2 and 3.

## Installation

You can install the development version of tab10 like so:

``` r
remotes::install_github("growthcharts/tab10")
```

## Example overweight

This is a basic example to communicate the probability of getting
overweight at the age of 4 years, given data of infants aged 6-12
months.

``` r
library(tab10)
fig <- create_tab10(palet = "redshadow")
fig
```

<img src="man/figures/README-overweight-1.png" width="100%" />

GitHub README does not allow animation. Install and run the above code
locally.

## Example preterm birth (GA \< 37 weeks)

``` r
library(tab10)
fig <- create_tab10(name = "preterm-37w-1", palet = "redshadow")
fig
```

<img src="man/figures/README-preterm-1.png" width="100%" />

## Shiny app

The Shiny app implements models to predict future overweight and
language deficit at age 4 years. The overweight model is designed to be
applied at the age of **4 months**. The language deficit modek should be
applied around the age of **24 months**.

To run the Shiny app on your machine, execute

``` r
library(tab10)
go()
```
