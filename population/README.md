Population data
==

There are multiple sources of population data for Afghanistan. Our analysis uses the first of these but we're interested in hosting multiple versions to encourage a more holistic view of the situation.

CSO
==

Official population data from the government of Afghanistan is made available at the [Afghanistan Central Statistics Organziation](http://cso.gov.af/en)

UNFPA
==

Working in conjunction with the CSO, UNFPA performed a household survey between 2003-2005 to prepare for a potential future census. The raw data is available in PDF format from the [Afghanistan Agriculture site](http://afghanag.ucdavis.edu/country-info/Province-agriculture-profiles/) at UC Davis.

We used [Tabula](http://tabula.nerdpower.org/) to convert these into rough csv files and then two python scripts ([1](https://github.com/developmentseed/afghanistan-2014-analysis/blob/gh-pages/population/csv-clean.py) & [2](https://github.com/developmentseed/afghanistan-2014-analysis/blob/gh-pages/population/csv-combine.py)) to create a full, district-level csv of the results

Finally, we did a ~~fuzzy-match~~ manual match of these districts to the AGCHO codes for mapping purposes.
