# msacrosswalk
`msacrosswalk` is a simple Stata crosswalk program for adding 2017 vintage CBSA/CSA codes, CBSA/CSA names, metropolitan/micropolitan, and central/outlying indicators that may be missing from your dataset.

## Prerequisites

**Stata:** `msacrosswalk` is compatible with Stata version 12.1+. It may be compatible with previous versions, but it has not been tested in those environments.

## Installation

**Github (for Stata v13.1+):** Run the following via the Stata command line.
```Stata
net install msacrosswalk, from(https://raw.github.com/cbgoodman/msacrosswalk/master/) replace
```

**Github (for Stata v12.1+):** Download the [zipped file](https://github.com/cbgoodman/msacrosswalk/archive/master.zip) of this repository. Unzip on your local computer. Run the following code via the Stata command line replacing <local source> with the location of the unzipped repository on your computer.
```Stata
net install msacrosswalk, from(<local source>) replace
```

## Using msacrosswalk
`msacrosswalk` offers three methods of merging using either five-digit county FIPS codes, the combination of two-digit state FIPS and three-digit county FIPS codes, or the combination of two-digit state Census codes and three-digit county Census codes. Vintage must be specified and determines which delineation file to be used. See [here](https://www.census.gov/geographies/reference-files/time-series/demo/metro-micro/delineation-files.html) for more information.

Merging with `fips`
```Stata
. msacrosswalk, fips(county) vintage(year)
```

Merging with `statefips` and `countyfips`
```Stata
. msacrosswalk, statefips(stfips) countyfips(cofips) vintage(year)
```

Merging with `statecode` and `countycode`
```Stata
. msacrosswalk, statecode(stcode) countycode(cocode) vintage(year)
```

By default, `msacrosswalk` will generate a new variable, `_merge`, to indicate the merged results.  If you do not want to create this variable, specify `nogenerate`.
This will keep matched observations and unmatched master observations.
```Stata
. msacrosswalk, fips(county) vintage(year) nogenerate
```

## Limitations
* FIPS codes are available for U.S counties, county equivalents, and territories. Census codes are only available for counties or county equivalents (such as independent cities).
* `msacrosswalk` uses the more recent FIPS code for Miami-Dade county (12086) rather than the FIPS code for Dade county (12025). The Census state (10) and county (13) codes remain unchanged.

## Next steps
* Add historical delineation files

## Bugs
Please report any bugs [here](https://github.com/cbgoodman/msacrosswalk/issues).
