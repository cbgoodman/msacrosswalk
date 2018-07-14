/*
msacrosswalk: Stata program for merging U.S. MSA/CBSA identifiers
Author: Christopher B. Goodman
Contact: cbgoodman@unomaha.edu
Date: NA
Version: 0.9.0
*/

capture program drop msacrosswalk
program define msacrosswalk

  version 12.1
  syntax, [Statefips(string) Countyfips(string) Fips(string) Statecode(string) Countycode(string) NOGENerate]

  cap quietly findfile msacrosswalk.dta, path("`c(sysdir_personal)'msacrosswalk_data/")

  if _rc==601 {
    preserve
    clear
    quietly findfile msacrosswalk_data.ado
    cap insheet using "`r(fn)'", tab
    label var fips "5-digit FIPS Code"
    label var state_fips "State FIPS Code"
    label var county_fips "County FIPS Code"
    label var state_code "State Census Code"
    label var county_code "County Census Code"
    label var cbsa_code "CBSA Code"
    label var cbsa_name "CBSA Name"
    label var csa_code "CSA Code"
    label var csa_name "CSA Name"
    label var type "1=Metropolitan, 2=Micropolitan"
    label var cen "1=Central, 2=Outlying"
    label define metro 1 "Metropolitan Statistical Area" 2 "Micropolitan Statistical Area"
    label define central 1 "Central" 2 "Outlying"
    label values type metro
    label values cen central
    cap mkdir "`c(sysdir_personal)'"
    cap mkdir "`c(sysdir_personal)'msacrosswalk_data"
    cap save "`c(sysdir_personal)'msacrosswalk_data/msacrosswalk.dta"
    restore
  }

  if "`nogenerate'" != "" {

    if "`statefips'" != "" & "`countyfips'" != "" {
      local statefips "`statefips'"
      local countyfips "`countyfips'"
      rename `countyfips' county_fips
      rename `statefips' state_fips
      merge m:1 state_fips county_fips using "`c(sysdir_personal)'msacrosswalk_data/msacrosswalk.dta", nogen keep(match master)
      drop fips state_code county_code
      rename state_fips `statefips'
      rename county_fips `countyfips'
    }

    else if "`fips'" != "" {
      local fips "`fips'"
      rename `fips' fips
      merge m:1 fips using "`c(sysdir_personal)'msacrosswalk_data/msacrosswalk.dta", nogen keep(match master)
      drop state_code county_code state_fips county_fips
      rename fips `fips'
    }

    else if "`statecode'" != "" & "`countycode'" != "" {
      preserve
      clear
      cap quietly use "`c(sysdir_personal)'msacrosswalk_data/msacrosswalk.dta"
      quietly drop if county_code==.
      tempfile msacrosswalk_datatemp
      cap save `msacrosswalk_datatemp'
      restore
      local statecode "`statecode'"
      local countycode "`countycode'"
      rename `statecode' state_code
      rename `countycode' county_code
      merge m:1 state_code county_code using `msacrosswalk_datatemp', nogen keep(match master)
      drop state_fips county_fips fips
      rename state_code `statecode'
      rename county_code `countycode'
    }

  }

  else if "`statefips'" != "" & "`countyfips'" != "" {
    local statefips "`statefips'"
    local countyfips "`countyfips'"
    rename `countyfips' county_fips
    rename `statefips' state_fips
    merge m:1 state_fips county_fips using "`c(sysdir_personal)'msacrosswalk_data/msacrosswalk.dta"
    drop fips state_code county_code
    rename state_fips `statefips'
    rename county_fips `countyfips'
  }

  else if "`fips'" != "" {
    local fips "`fips'"
    rename `fips' fips
    merge m:1 fips using "`c(sysdir_personal)'msacrosswalk_data/msacrosswalk.dta"
    drop state_code county_code state_fips county_fips
    rename fips `fips'
  }

  else if "`statecode'" != "" & "`countycode'" != "" {
    preserve
    clear
    cap quietly use "`c(sysdir_personal)'msacrosswalk_data/msacrosswalk.dta"
    quietly drop if county_code==.
    tempfile msacrosswalk_datatemp
    cap save `msacrosswalk_datatemp'
    restore
    local statecode "`statecode'"
    local countycode "`countycode'"
    rename `statecode' state_code
    rename `countycode' county_code
    merge m:1 state_code county_code using `msacrosswalk_datatemp'
    drop state_fips county_fips fips
    rename state_code `statecode'
    rename county_code `countycode'
  }

end
