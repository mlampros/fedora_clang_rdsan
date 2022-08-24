# rscript to retrieve the latest Fedora version (an integer value and not a character string version)

get_latest_version = function(URL = 'https://hub.docker.com/v2/repositories/library/fedora/tags') {
  dat = jsonlite::fromJSON(URL)
  results = dat$results
  results$images = NULL
  results$name = suppressWarnings(as.integer(results$name))
  results = results[order(results$name, decreasing = T), ]
  return(results)
}

dat_out = get_latest_version()
cat(dat_out$name[1])
