# Generated by using Rcpp::compileAttributes() -> do not edit by hand
# Generator token: 10BE3573-1514-4C36-9D1C-5A225CD40393

mpcflushesc <- function(data, nevents) {
    .Call(`_TSLib_mpcflushesc`, data, nevents)
}

mpc2tecc <- function(mpc, nevents, resolution) {
    .Call(`_TSLib_mpc2tecc`, mpc, nevents, resolution)
}

rasterc <- function(events, pattern, event_count) {
    .Call(`_TSLib_rasterc`, events, pattern, event_count)
}

trialdefc <- function(events, pattern, event_count, pattern_count, from_first) {
    .Call(`_TSLib_trialdefc`, events, pattern, event_count, pattern_count, from_first)
}

