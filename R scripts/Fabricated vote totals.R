## read data
results <- read.csv("Downloads/afgh_rnd_2nd_raw_html/afghanistanrunoff.csv",header=TRUE)

## combine counts for both candidates
vote_counts <- c(results$Abdullah,results$Ghani)

## remove counts under 100
vote_counts_filter <- vote_counts[vote_counts > 99]

## take last two digits; no need to add leading zero because all numbers are three digits
lasttwo <- sapply(vote_counts_filter, function(x) substr(x, nchar(x) -1, nchar(x)))
last2 <- as.data.frame(as.numeric(lasttwo))

## plot, actually done with d3.js in browser
require(ggplot2)
votes <- ggplot(last2, aes(x=lasttwo))
votes + geom_histogram(bins=100, fill='deepskyblue3')

## province level histograms made with the following code

## get polling center information
pc <- read.csv("Downloads/iec_runoff_polling_centers_en_jun2014.csv")

## merge
results <- merge(results, pc, by.x = c("Polling.Center"), by.y = c("PC.number"), all.x=TRUE)

## construct a province list
provincelist <- unique(results$province)

## outputs 34 jpg files of the digit analysis plots
for (i in 1:length(provincelist)){
  if (!provincelist[i] == ""){
    results_temp <- results[results$province == provincelist[i],]
    aafilter <- results_temp[results_temp$Abdullah > 99,]
    aalasttwo <- sapply(aafilter$Abdullah, function(x) substr(x, nchar(x) -1, nchar(x)))
    ghanifilter <- results_temp[results_temp$Ghani > 99,]
    ghanilasttwo <- sapply(ghanifilter$Ghani, function(x) substr(x, nchar(x) -1, nchar(x)))
    joinedvotes <- c(aafilter$Abdullah,ghanifilter$Ghani)
    df <- as.data.frame(c(as.numeric(aalasttwo),as.numeric(ghanilasttwo)))
    a <- as.character(c(aalasttwo,ghanilasttwo))
    savefile <- paste("Desktop/images/color/",provincelist[i],".jpg",sep="")
    jpeg(file=savefile, width = 1280)
    print(ggplot(df, aes(x=a, fill = as.factor(substr(joinedvotes,1,1)))) + geom_bar())  ## delete the "fill = as.factor..." section if coloring by first digit isn't desired
    dev.off()
  }
}
