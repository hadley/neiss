# neiss

[![Travis-CI Build Status](https://travis-ci.org/hadley/neiss.svg?branch=master)](https://travis-ci.org/hadley/neiss)

The neiss package provides access to the last five years of data (2013-2017) from the [National Electronic Injury Surveillance System](http://www.cpsc.gov/en/Research--Statistics/NEISS-Injury-Data/), which is a sample of all accidents reported to emergency rooms in the US.

It currently contains three datasets:

* `injuries`: individual injury results
* `products`: product code lookup table
* `population`: population of the US by age, sex, and year

Inspired by [flowing data](http://flowingdata.com/2016/02/09/why-people-visit-the-emergency-room/).

## Installation

`neiss` is not currently on CRAN but you can install it with devtools:

```R
# install.packages("devtools")
devtools::install_github("hadley/neiss")
```

But please note that this will take a while to download because the data is quite large.
