Population data
==

There are multiple sources of population data for Afghanistan. Our analysis uses the first of these but we're interested in hosting multiple versions to encourage a more holistic view of the situation.

CSO
==

[CSO district level population, 2012-2013](https://github.com/developmentseed/afghanistan-2014-analysis/blob/gh-pages/population/population_matched_cso.csv)

Official population data from the government of Afghanistan is made available at the [Afghanistan Central Statistics Organziation](http://cso.gov.af/en)

UNFPA
==

[UNFPA district level population, 2003-2005](https://github.com/developmentseed/afghanistan-2014-analysis/blob/gh-pages/population/UNFPA_pop_append.csv)

Working in conjunction with the CSO, UNFPA performed a household survey between 2003-2005 to prepare for a potential future census. The raw data is available in PDF format from the [Afghanistan Agriculture site](http://afghanag.ucdavis.edu/country-info/Province-agriculture-profiles/) at UC Davis.

We used [Tabula](http://tabula.nerdpower.org/) to convert these into rough csv files and then two python scripts ([1](https://github.com/developmentseed/afghanistan-2014-analysis/blob/gh-pages/population/csv-clean.py) & [2](https://github.com/developmentseed/afghanistan-2014-analysis/blob/gh-pages/population/csv-combine.py)) to create a full, district-level csv of the results

Finally, we did a ~~fuzzy-match~~ manual match of these districts to the AGCHO codes for mapping purposes.

WorldPop
===

[WorldPop district level population, 2010 & 2015](https://github.com/developmentseed/afghanistan-2014-analysis/blob/gh-pages/population/worldpop_district.csv)

WorldPop provides population data derived from satelitte imagery. We took their raster image of the following: 

>Alpha version 2010 and 2015 estimates of numbers of people per grid square, with national totals adjusted to match UN    >population division estimates (http://esa.un.org/wpp/) and remaining unadjusted. 

and used the QGIS plug-in [zonal statistics](http://docs.qgis.org/2.2/en/docs/user_manual/plugins/plugins_zonal_statistics.html) to aggregate populations to the district level.

Additional info can be found at the [WorldPop download page for Afghanistan population](http://www.worldpop.org.uk/data/summary/?contselect=Asia&countselect=Afghanistan&typeselect=Population)
