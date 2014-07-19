## read data
results <- read.csv("Downloads/afgh_rnd_2nd_raw_html/afghanistanrunoff.csv")

## add a better province/district id
results$prov_dist_id <- paste("0",results$Polling.Center,sep="")
results$prov_dist_id <- sapply(results$prov_dist_id, function(x) substr(x, nchar(x) -6, nchar(x)-3))

## add flags
results$total <- results$Abdullah + results$Ghani
results$sixhundred <- results$total == 600
results$crit2009 <- results$sixhundred & (results$Abdullah >= 570 | results$Ghani >= 570)
results$A0050 <- sapply(results$Abdullah, function(x) substr(x, nchar(x) -1, nchar(x))) == "00" | sapply(results$Abdullah, function(x) substr(x, nchar(x) -1, nchar(x))) == "50"
results$G0050 <- sapply(results$Ghani, function(x) substr(x, nchar(x) -1, nchar(x))) == "00" | sapply(results$Ghani, function(x) substr(x, nchar(x) -1, nchar(x))) == "50"
results$double0050 <- results$A0050 & results$G0050
results$Aper <- results$Abdullah / results$total
results$Gper <- results$Ghani/ results$total
results$odd <- results$Abdullah == 500 | results$Ghani == 500 | results$Abdullah == 550 | results$Ghani == 550

# show all votes/stations quarantined by "digit analysis"
digit_analysis <- results[(results$double0050 | results$odd) & !(results$Abdullah == 600 | results$Ghani == 600),c(3,4,6)]
c(sum(digit_analysis$Abdullah),sum(digit_analysis$Ghani),sum(digit_analysis$total),length(digit_analysis$total))
## [1]  67669  87795 155464    268

# show all votes/stations quarantined by "voter turnout"
# ht_dist <- look_sort$District[look_sort$per > .6] ## this code has to be run in the "Comparisons to population" script and then stored for this next calculation
voter_turnout <- results[(results$prov_dist_id %in% ht_dist) & (results$Aper > .95 | results$Gper > .95) & results$total >= 550,c(3:6)]
c(sum(voter_turnout$Abdullah),sum(voter_turnout$Ghani),sum(voter_turnout$total),length(voter_turnout$total))
## [1]  85393 796586 881979   1486

# show all votes/stations quarantined by "2009 criteria"
crit2009 <- results[results$crit2009,c(3,4,6)]
c(sum(crit2009$Abdullah),sum(crit2009$Ghani),sum(crit2009$total),length(crit2009$total))
## [1]  53208 365592 418800    698

# show final result with quarantined votes removed
sum(results$Abdullah[!((results$double0050 | results$odd) & !(results$Abdullah == 600 | results$Ghani == 600)) & !((results$prov_dist_id %in% ht_dist) & (results$Aper > .95 | results$Gper > .95) & results$total >= 550) & !results$crit2009])
## [1] 3275344
sum(results$Ghani[!((results$double0050 | results$odd) & !(results$Abdullah == 600 | results$Ghani == 600)) & !((results$prov_dist_id %in% ht_dist) & (results$Aper > .95 | results$Gper > .95) & results$total >= 550) & !results$crit2009])
## [1] 3479175


