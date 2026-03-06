# Functions for Sockeye Calibration

# Function for more accurate rounding relative to base R
# Source
# https://stackoverflow.com/questions/12688717/round-up-from-5
# Original Source
# http://andrewlandgraf.com/2012/06/15/rounding-in-r/
round2 = function(x, digits) {
  posneg = sign(x)
  z = abs(x)*10^digits
  z = z + 0.5 + sqrt(.Machine$double.eps)
  z = trunc(z)
  z = z/10^digits
  z*posneg
}

# Functions for plotting ordered bars or anything within a facet_wrap in ggplot
# originally found here:
#  https://stackoverflow.com/questions/47090344/how-to-properly-sort-facet-boxplots-by-median
# original author here:
#  https://github.com/dgrtwo/drlib/blob/master/R/reorder_within.R

reorder_within <- function(x, by, within, fun = mean, sep = "___", ...) {
  new_x <- paste(x, within, sep = sep)
  stats::reorder(new_x, by, FUN = fun)
}


scale_x_reordered <- function(..., sep = "___") {
  reg <- paste0(sep, ".+$")
  ggplot2::scale_x_discrete(labels = function(x) gsub(reg, "", x), ...)
}

# rank summary function
# calculates equations 2-4 from the report for each set-level

rank.summary <- function(rank.dat) { # input are the Model Rank leave-one-out outputs, subset based on the set-level
  rank.sum <- rank.dat %>% 
    group_by(source, rank.set.level) %>% # summarizing first by the model
    summarise(no.estimates = n(), # count of estimates
              # equation 3 performance statistics
              mean.percent.error = mean(per.error), # positive percent error means that the fit is an overestimate
              abs.mean.percent.error = abs(mean.percent.error),
              mean.abs.per.error = mean(abs.per.error),
              max.abs.per.error = max(abs.per.error),
              root.mean.sqrd.error = sqrt(sum(squared.error)/no.estimates),
              no.abs.error.over.5 = sum(abs.per.error > 0.5), # sum(condition) counts the occurrences that fulfill the condition
              percent.abs.error.over.5 = ifelse(!is.na(no.abs.error.over.5/no.estimates),
                                                no.abs.error.over.5/no.estimates, 0),
              mean.abs.scaled.error = mean(abs.error) / mean(abs.classic.error), # MASE
              r.correlation = cor(calibrated.estimate, hpe),
              # calculating two CVs, only one is selected as the mean.CV for use later based on the type of space the model was estimated in
              real.CV = round2(mean(se.fit / fit)*100,1),
              fit.CV = round2(mean(sqrt(exp(se.fit^2)-1))*100,1)) %>% 
    ungroup() %>% # need to ungroup to create standardized performance metric ranks (equation 4)
    mutate(mean.CV = ifelse(source %in% c("MoR_Clarity_Model",
                                          "MoR_ESTU_Single_Model"), real.CV, fit.CV),
           rel.abs.MPE = (abs.mean.percent.error - min(abs.mean.percent.error))/
             (max(abs.mean.percent.error) - min(abs.mean.percent.error)),
           rel.MAPE = (mean.abs.per.error - min(mean.abs.per.error))/
             (max(mean.abs.per.error) - min(mean.abs.per.error)),
           rel.RMSE = (root.mean.sqrd.error - min(root.mean.sqrd.error))/
             (max(root.mean.sqrd.error) - min(root.mean.sqrd.error)),
           rel.MASE = (mean.abs.scaled.error - min(mean.abs.scaled.error))/
             (max(mean.abs.scaled.error) - min(mean.abs.scaled.error)),
           rel.cor = ((r.correlation)-(max(r.correlation)))/
             (min(r.correlation)-max(r.correlation)),
           rel.over.5 = (percent.abs.error.over.5 - min(percent.abs.error.over.5))/
             (max(percent.abs.error.over.5) - min(percent.abs.error.over.5))) %>% 
    ungroup() %>% # needed to apply ungroup again, not sure why...
    # Rms from equation 4. Note that 4 variations were investigated but rel.sum is the final one selected and used.
    mutate(rel.sum = (rel.abs.MPE + rel.MAPE + rel.RMSE + rel.cor)/4,
           rel.sumMASE = (rel.abs.MPE + rel.MAPE + rel.RMSE + rel.MASE + rel.cor)/5,
           rel.sumRed = (rel.abs.MPE + rel.MAPE + rel.RMSE)/3,
           rel.sum.5 = (rel.abs.MPE + rel.MAPE + rel.RMSE + rel.cor + rel.over.5)/5)
  
  return(rank.sum)
}