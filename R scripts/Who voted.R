## read data
runoff_results <- read.csv("Downloads/afgh_rnd_2nd_raw_html/afghanistanrunoff.csv",header=TRUE)
firstround_results <- read.csv("Downloads/2014_afghanistan_election_results.csv",header=TRUE)

## aggregate each to the polling center level
runoff_aggregate <- aggregate(runoff_results[c(3,4)], by=list(pc = runoff_results$Polling.Center), FUN=sum)
firstround_aggregate <- aggregate(firstround_results[c(6,11,16)], by=list(pc = firstround_results$PC_number, province = firstround_results$province, district = firstround_results$district), FUN=sum)

## merge the two rounds
bothrounds <- merge(runoff_aggregate, firstround_aggregate, by.x = c("pc"), by.y = c("pc"), all.x=TRUE, all.y=TRUE)

## apply some more descriptive column names,add a total column for the second round, zero out NAs
colnames(bothrounds) <- c("polling_center","abdullah_votes_runoff","ghani_votes_runoff","province","district","abdullah_votes_firstround","ghani_votes_firstround","total_votes_firstround")
bothrounds$total_votes_runoff <- bothrounds$abdullah_votes_runoff + bothrounds$ghani_votes_runoff
bothrounds[is.na(bothrounds)] <- 0

## all the outputs for the 'Who voted?' section

# April (first round) votes
firstround_votes <- sum(bothrounds$total_votes_firstround)
## [1] 6645384

# June (runoff) votes
runoff_votes <- sum(bothrounds$total_votes_runoff)
## [1] 7947527

# Additional votes in the runoff
runoff_votes - firstround_votes
## [1] 1302143

# Total polling centers
total_pc <- length(bothrounds$total_votes_runoff)
## [1] 6294

# Polling centers with reduced turnout in the runoff election
reduced_turnout_pc <- length(bothrounds$total_votes_runoff[bothrounds$total_votes_runoff < bothrounds$total_votes_firstround])
## [1] 2901

# % of polling centers with reduced turnout in the runoff election
reduced_turnout_pc / total_pc
## [1] 0.4609152

# Votes "lost" from these polling centers
sum(bothrounds$total_votes_firstround[bothrounds$total_votes_runoff < bothrounds$total_votes_firstround] - bothrounds$total_votes_runoff[bothrounds$total_votes_runoff < bothrounds$total_votes_firstround])
## [1] 979470

# Polling centers with higher turnout in the runoff election
higher_turnout_pc <- length(bothrounds$total_votes_runoff[bothrounds$total_votes_runoff > bothrounds$total_votes_firstround])
## [1] 3361

# Votes gained from these polling centers
higher_turnout_votes_gained <- sum(bothrounds$total_votes_runoff[bothrounds$total_votes_runoff > bothrounds$total_votes_firstround] - bothrounds$total_votes_firstround[bothrounds$total_votes_runoff > bothrounds$total_votes_firstround])
## [1] 2281613

# Average increase of votes at these polling centers
higher_turnout_votes_gained / higher_turnout_pc
## [1] 678.8494
