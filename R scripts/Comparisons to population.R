## read in the population data, the results data, and rosetta table
population <- read.csv("population_matched_fix.csv",colClasses=c(rep("numeric",9),rep("character",4)))
results <- read.csv("afgh_rnd_2nd_raw_html/afghanistanrunoff.csv",header=TRUE)
match_table <- read.csv("rosetta_fix.csv",colClasses=c(rep("character",12)))

## aggregate results to the pc level
aggregate_results <- aggregate(results[c(3,4)], by=list(pc = results$Polling.Center), FUN=sum)

## fix the iecid
aggregate_results$joinid <- paste("0",aggregate_results$pc,sep="")
aggregate_results$joinid <- sapply(aggregate_results$joinid, function(x) substr(x, nchar(x) -6, nchar(x)-3))

## aggregate the results to the district level
aggregate_results_dist <- aggregate(aggregate_results[c(2,3)], by=list(District = aggregate_results$joinid), FUN=sum)

## adjustments for mapping purposes at the district level, comment out if this reassignment isn't desired
## justification here: https://gist.github.com/drewbo/184304fedb64843beebf
dist_reassign <- function(x){
  y <- x
  if (x == "1313"){ y <- "1302"}
  if (x == "1312"){ y <- "1308"}
  if (x %in% c("2717","2718")){ y <- "2701"}
  if (x == "3014"){ y <- "3002"}
  if (x == "3406"){ y <- "3405"}
  y
}
aggregate_results_dist$District <- sapply(aggregate_results_dist$District, function(x) dist_reassign(x))
aggregate_results_dist <- aggregate(aggregate_results_dist[c(2,3)], by=list(District = aggregate_results_dist$District), FUN=sum)

## fix the iecid
match_table$joinid <- paste("0",match_table$iec_id_fix,sep="")
match_table$joinid <- sapply(match_table$joinid, function(x) substr(x, nchar(x) -3, nchar(x)))

## join the results to the rosetta table
add_agcho_dist_id <- merge(aggregate_results_dist, match_table, by.x = c("District"), by.y = c("joinid"), all.x=TRUE)

## fix the agchoid
add_agcho_dist_id$agcho_id_zero <- paste("0",add_agcho_dist_id$agcho_dist_id,sep="")
add_agcho_dist_id$agcho_id_zero <- sapply(add_agcho_dist_id$agcho_id_zero, function(x) substr(x, nchar(x) -3, nchar(x)))

## join the results to the population data
full_data <- merge(add_agcho_dist_id, population, by.x = c("agcho_id_zero"), by.y = c("agcho_dist_id_fix"), all.x=TRUE, all.y=TRUE)

## get a voter turnout number and then sort on that
full_data$per <- (full_data$Abdullah + full_data$Ghani) / (full_data$total * 1000)
look <- full_data[complete.cases(full_data),]
look_sort <- look[order(look$per),]

## Use this csv to generate the voter turnout map
## write.csv(look_sort,"Desktop/district_turnout.csv")

## apply some better column names
colnames(look_sort)[25] <- "total_population"
colnames(look_sort[29]) <- "turnout"
look_sort$total_votes <- look_sort$Abdullah + look_sort$Ghani

## all the outputs for the 'Comparisons to population?' section

# people in Warmamy
look_sort$total[look_sort$dist_name == "Wormamay"] * 1000
## [1] 3400

# votes in Warmamy
look_sort$total_votes[look_sort$dist_name == "Wormamay"]
## [1] 23415

# districts with more votes than reported population
length(look_sort$total_votes[look_sort$turnout > 1])
## [1] 21

# districts with votes greater than 60% of the population
length(look_sort$total_votes[look_sort$turnout > 0.6])
## [1] 71

# votes from the above districts
sum(look_sort$total_votes[look_sort$turnout > 1])
## [1] 503131
sum(look_sort$total_votes[look_sort$turnout > 0.6])
## [1] 1855121


## make fingerprint plots
x_axis <- sapply(full_data$per, function(x) min(x,0.6)) ## coerce > 60% to 60%
y_axis <- full_data$Ghani / (full_data$Abdullah + full_data$Ghani)

d1 <- ggplot(as.data.frame(cbind(x_axis,y_axis)),aes(x_axis,y_axis))
d1 + geom_bin2d(bins=40) + scale_fill_gradientn(colours= c('blue','green','yellow','yellow','orange','orange','red','red','red','red','red','red')) + theme(panel.background = element_rect(fill = 'darkblue'), panel.grid.major = element_line(colour = 'darkblue'), panel.grid.minor = element_line(colour= 'darkblue'))
