manytrade <img src="man/figures/manytradeContainer.png" align="right" width="220"/>
===================================================================================

<!-- badges: start -->

[![lifecycle](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://www.tidyverse.org/lifecycle/#experimental)
![GitHub release (latest by
date)](https://img.shields.io/github/v/release/globalgov/manytrade)
![GitHub Release
Date](https://img.shields.io/github/release-date/globalgov/manytrade)
![GitHub
issues](https://img.shields.io/github/issues-raw/globalgov/manytrade)
[![CodeFactor](https://www.codefactor.io/repository/github/globalgov/manytrade/badge/main)](https://www.codefactor.io/repository/github/globalgov/manytrade/overview/main)
<!-- [![CII Best Practices](https://bestpractices.coreinfrastructure.org/projects/4867/badge)](https://bestpractices.coreinfrastructure.org/projects/4867) -->
<!-- badges: end -->

manytrade is a data package in the [many
packages](https://github.com/globalgov/) universe. It currently includes
an ensemble of datasets on international trade agreements, and
[states](https://github.com/globalgov/manystates)’ membership or other
relationships to those agreements. Please also check out
[`{manydata}`](https://github.com/globalgov/manydata) for more about the
other packages in the ‘many packages’ universe.

How to install:
---------------

We’ve made it easier than ever to install and start analysing global
governance data in R. Simply install the core package,
[manydata](https://github.com/globalgov/manydata), and then you can
discover, install and update various ‘many packages’ from the console.

``` r
manydata::get_packages() # this prints a list of the publicly available data packages currently available
```

    ## # A tibble: 7 × 6
    ##   name        full_name            
    ##   <chr>       <chr>                
    ## 1 manydata    globalgov/manydata   
    ## 2 manyenviron globalgov/manyenviron
    ## 3 manyhealth  globalgov/manyhealth 
    ## 4 manypkgs    globalgov/manypkgs   
    ## 5 manystates  globalgov/manystates 
    ## 6 manytrade   globalgov/manytrade  
    ## 7 messydates  globalgov/messydates 
    ##   description                                                          
    ##   <chr>                                                                
    ## 1 An R portal for ensembled global governance data                     
    ## 2 R Package for ensembled data on environmental agreements             
    ## 3 An R package for ensembled data on international health organisations
    ## 4 Support for creating new manyverse packages                          
    ## 5 An R package for ensembled data on sovereign states                  
    ## 6 An R package for ensembled data on trade agreements                  
    ## 7 An R package for ISO's Extended Date/Time Format (EDTF)              
    ##   installed latest        updated   
    ##   <chr>     <chr>         <date>    
    ## 1 0.7.3     0.7.3         2022-03-31
    ## 2 0.1.2     0.1.2         2022-03-16
    ## 3 0.1.1     0.1.1-272ea19 2022-02-15
    ## 4 0.2.1     0.2.1         2022-02-18
    ## 5 0.1.0     0.0.6         2021-12-06
    ## 6 0.1.1     0.1.1         2022-03-23
    ## 7 0.2.2     0.2.1         2022-02-18

``` r
#manydata::get_packages("manytrade") # this downloads and installs the named package
```

Data included
-------------

Once you have installed the package, you can see the different databases
and datasets included in the {`manytrade`} package using the following
function.

    manydata::data_contrast("manytrade")

    ## agreements :
    ##        Unique ID Missing Data Rows Columns        Beg End
    ## DESTA          0       4.21 %  959      10 1948-01-01  NA
    ## TREND          0       0.29 %  729       7 1947-01-01  NA
    ## LABPTA         0          0 %  483       7 1990-01-01  NA
    ## GPTAD          0        6.5 %  340      10 1957-03-25  NA
    ## GNEVAR         0      36.99 % 1678      16 1947-01-01  NA
    ##                                                                                                                                                                                                                                        URL
    ## DESTA                                                                                                                                                                                   https://www.designoftradeagreements.org/downloads/
    ## TREND                                                                                                                                                                                             http://www.chaire-epi.ulaval.ca/en/trend
    ## LABPTA                                                                                                                                                                                           https://doi.org/10.1007/s11558-018-9301-z
    ## GPTAD                                                                                                                                                                                        https://wits.worldbank.org/gptad/library.aspx
    ## GNEVAR https://www.designoftradeagreements.org/downloads/, https://wits.worldbank.org/gptad/library.aspx, https://doi.org/10.1007/s11558-018-9301-z, http://www.chaire-epi.ulaval.ca/en/trend, https://github.com/mappingtreaties/tota.git
    ## 
    ## memberships :
    ##           Unique ID Missing Data Rows Columns        Beg End
    ## GPTAD_MEM         0       4.12 % 2201       9 1957-03-25  NA
    ## DESTA_MEM         0       6.16 % 7492       9 1948-01-01  NA
    ##                                                          URL
    ## GPTAD_MEM      https://wits.worldbank.org/gptad/library.aspx
    ## DESTA_MEM https://www.designoftradeagreements.org/downloads/
    ## 
    ## references :
    ##           Unique ID Missing Data Rows Columns Beg End
    ## DESTA_REF         0       27.6 % 1000       3  NA  NA
    ##                                                          URL
    ## DESTA_REF https://www.designoftradeagreements.org/downloads/
    ## 
    ## texts :
    ##          Unique ID Missing Data Rows Columns        Beg End
    ## AGR_TXT          0      20.62 % 1264      11 1947-01-01  NA
    ## TOTA_TXT         0          0 %  450       9 1948-12-06  NA
    ##                                                                                                                                                                        URL
    ## AGR_TXT  https://wits.worldbank.org/gptad/library.aspx, http://rtais.wto.org/UI/PublicMaintainRTAHome.aspx, https://edit.wti.org/app.php/document/investment-treaty/search
    ## TOTA_TXT                                                                                                                       https://github.com/mappingtreaties/tota.git

Working with ensembles of related data has many advantages for robust
analysis. Just take a look at our vignettes
[here](https://globalgov.github.io/manydata/articles/user.html).

The ‘many packages’ universe
----------------------------

The [many packages](https://github.com/globalgov/) universe is aimed at
collecting, connecting and correcting network data across issue-domains
of global governance.

While the packages in the many universe can and do include novel data,
much of what they offer involves standing on the shoulders of giants.
The ‘many packages’ universe endeavours to be as transparent as possible
about where data comes from, how it has been coded and/or relabeled, and
who has done the work. As such, we make it easy to cite both the
particular datasets you use by listing the official references in the
function above, as well as the package providers for their work
assembling the data by using the function below.

    citation("manytrade")

    ## 
    ## To cite manytrade in publications use:
    ## 
    ##   J. Hollway. Trade agreements for manydata. 2021.
    ## 
    ## A BibTeX entry for LaTeX users is
    ## 
    ##   @Manual{,
    ##     title = {manytrade: International Trade Agreements for manydata},
    ##     author = {James Hollway},
    ##     year = {2021},
    ##     url = {https://github.com/globalgov/manytrade},
    ##   }

Contributing
------------

[`{manypkgs}`](https://github.com/globalgov/manypkgs) also makes it easy
to contribute in lots of different ways.

If you have already developed a dataset salient to this package, please
reach out by flagging this as an
[issue](https://github.com/globalgov/manytrade/issues) for us, or by
forking, further developing the package yourself, and opening a [pull
request](https://github.com/globalgov/manytrade/pulls) so that your data
can be used easily.

If you have collected or developed other data that may not be best for
this package, but could be useful within the wider ‘many packages’
universe, [manypkgs](https://github.com/globalgov/manypkgs) includes a
number of functions that make it easy to create a new ‘many package’ and
populate it with clean, consistent global governance data.

If you have any other ideas about how this package or the ‘many
packages’ universe more broadly might better facilitate your empirical
analysis, we’d be very happy to hear from you.
