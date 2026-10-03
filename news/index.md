# Changelog

## wsabrazil 0.1.0

- First versioned release, planned for the first Zenodo deposit.
  CITATION.cff and inst/CITATION declare the work as a dataset;
  DESCRIPTION gains keywords and the spatial and temporal coverage; the
  pkgdown site is configured per the openwashdata standard and deployed
  from gh-pages; R CMD check runs in CI. The stacked census file is now
  read as Latin-1, so all place names are valid UTF-8 (807,454 invalid
  values before, none after), and `FU_code` holds the two-digit IBGE
  state code (11 to 53) taken from `meso_code`. Both exports are written
  from the same object. The 1,965 rows that came from
  `data-raw/PA_census_data.csv` are dropped: they repeated census
  sectors of the Belém metropolitan region that are already in the data
  with the same household counts and income, but had no geography codes.
  The data now have 190,931 rows, one per census sector; all other
  values are unchanged
  ([\#4](https://github.com/openwashdata/wsabrazil/issues/4)).
