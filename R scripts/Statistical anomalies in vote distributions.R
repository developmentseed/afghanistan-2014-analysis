## read data
results <- read.csv("Downloads/afgh_rnd_2nd_raw_html/afghanistanrunoff.csv",header=TRUE)

## aggregate at the polling center level
results_aggregate <- aggregate(results[c(3,4)], by=list(pc = results$Polling.Center), FUN=sum)

## assign a district/province ID
results_aggregate$dist_prov_id <- paste("0",results_aggregate$pc,sep="")
results_aggregate$dist_prov_id <- sapply(results_aggregate$dist_prov_id, function(x) substr(x, nchar(x) -6, nchar(x)-3))

## polling centers in Gian, Paktika (IEC ID = 1215)
results_aggregate[results_aggregate$dist_prov_id == "1215",]

####   row      pc Abdullah Ghani dist_prov_id
####  2502 1215267        0  2400         1215
####  2503 1215268        0  1800         1215
####  2504 1215269        0  1800         1215
####  2505 1215270        0  1800         1215
####  2506 1215272        0  3000         1215
####  2507 1215273        0  1800         1215
####  2508 1215274        0  1800         1215
####  2509 1215275        0  1200         1215
####  2510 1215276       11  1189         1215
####  2511 1215278        0  2400         1215
####  2512 1215279        0  1699         1215
####  2513 1215280        0  1800         1215

## creating the data for the histograms/density plots (which are rendered in browser via d3.js)

## Adding province column and total votes
results$prov <- paste("0",results$Polling.Center,sep="")
results$prov <- sapply(results$prov, function(x) substr(x, nchar(x) -6, nchar(x) -5))
results$total <- results$Abdullah + results$Ghani

## initlaize a helpful function from this stackoverflow chain: http://stackoverflow.com/questions/6988184/combining-two-data-frames-of-different-lengths
## this is used for binding columns of variable lengths and adding NAs into the non-matching portion instead of looping and repeating the smaller column
cbindPad <- function(...){
  args <- list(...)
  n <- sapply(args,nrow)
  mx <- max(n)
  pad <- function(x, mx){
    if (nrow(x) < mx){
      nms <- colnames(x)
      padTemp <- matrix(NA,mx - nrow(x), ncol(x))
      colnames(padTemp) <- nms
      return(rbind(x,padTemp))
      }
    else{
      return(x)
    }
  }
  rs <- lapply(args,pad,mx)
  return(do.call(cbind,rs))
}

## create one set of data for the first province then loop to make them all
bigdf <- results$total[results$prov == unique(results$prov)[1]]
for (i in 2:34){
  bigdf <- cbindPad(as.data.frame(bigdf),as.data.frame(results$total[results$prov == unique(results$prov)[i]]))
}

## this step is weirdly crucial for plotting in R (colnames won't get dynamic assignment during the for loop and then it won't plot correctly)
colnames(bigdf) <- unique(results$prov)

## output data for use in browser
## write.csv(bigdf, "results_ps_freq.csv")
